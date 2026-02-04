nextflow.enable.dsl = 2

process TRIM_GALORE {
    publishDir "TRIMMED", mode: 'copy'

    input:
        tuple val(sampleid), path(reads)

    output:
        path "*trimmed*.fq.gz", emit: trimmed

    script:
    """
    trim_galore --paired -q 20 --gzip --basename ${sampleid}_trimmed ${reads}
    """
}

process QC {
    publishDir "QC_REPORTS", mode: 'copy'

    input:
        path(reads)

    output:
        path "*"

    script:
    """
    fastqc ${reads}
    multiqc .
    """
}

process STAR_INDEX {
    publishDir "INDEX", mode: 'copy'

    input:
        path fasta
        path gtf

    output:
        path "index", emit: index

    script:
    """
    mkdir -p index
    STAR \
      --runThreadN 8 \
      --runMode genomeGenerate \
      --genomeDir index \
      --genomeFastaFiles ${fasta} \
      --sjdbGTFfile ${gtf} \
      --genomeSAindexNbases 12
    """
}

process STAR_MAPPING {
    publishDir "MAPPING", mode: 'copy'
    cpus 4

    input:
        tuple val(sampleid), path(read1), path(read2), path(index)

    output:
        path "*.bam", emit: bams

    script:
    """
    STAR \
      --runThreadN 4 \
      --genomeDir ${index} \
      --readFilesIn ${read1} ${read2} \
      --readFilesCommand zcat \
      --outSAMtype BAM SortedByCoordinate \
      --outFileNamePrefix ${sampleid}.
    """
}


process FEATURE_COUNT {
    publishDir "READ_COUNT", mode:'copy'
    
    input:
         path(bams)
         path(gtf)
         val(strand)
    output:
         path "*"
    
    script:
    """
    featureCounts -T 8 -s ${strand} -p --countReadPairs -t exon \
    -g gene_id -Q 10 -a  ${gtf} -o gene_count ${bams}
    
    multiqc gene_count*
    
    """



}





workflow {

    ref_fasta = Channel.fromPath(params.ref_fasta)
    ref_gtf   = Channel.fromPath(params.ref_gtf)

    fastq_ch = Channel.fromFilePairs(params.reads)

    trimmed_ch = TRIM_GALORE(fastq_ch).trimmed

    QC(
        fastq_ch.map { it[1] }.flatten()
                .mix(trimmed_ch.flatten())
    )

    star_index_ch = STAR_INDEX(ref_fasta, ref_gtf).index

    mapping_input = trimmed_ch.map { r1, r2 ->
        tuple(r1.baseName.replace('_trimmed',''), r1, r2)
    }

    bams_ch = STAR_MAPPING(
        mapping_input.combine(star_index_ch)
                     .map { sid, r1, r2, idx -> tuple(sid, r1, r2, idx) }
    ).bams

    bams_ch.view()

    FEATURE_COUNT(
        bams_ch,
        ref_gtf,
        params.strand
    )
}


