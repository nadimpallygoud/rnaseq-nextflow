# RNA-seq Analysis Pipeline (Nextflow DSL2)

This repository contains a **minimal, fully reproducible RNA-seq analysis pipeline**
implemented in **Nextflow DSL2**.

The pipeline was developed and executed locally using publicly available test data
(chrX subset) and standard RNA-seq tools.

---

##  Pipeline Overview

The workflow performs the following steps:

1. **Read trimming** using Trim Galore
2. **Quality control (QC)** using FastQC + MultiQC
3. **STAR genome index generation**
4. **Read alignment** using STAR
5. **Gene-level read counting** using featureCounts

All steps are orchestrated using **Nextflow DSL2**.

---

##  Tools Used

| Tool | Purpose |
|-----|--------|
| Nextflow (DSL2) | Workflow orchestration |
| Trim Galore | Adapter and quality trimming |
| FastQC | Read quality assessment |
| MultiQC | QC report aggregation |
| STAR | RNA-seq read alignment |
| featureCounts (Subread) | Gene-level read quantification |

---

##  Directory Structure

├── rnaseq.nf # Main Nextflow pipeline
├── ref/ # Reference genome and annotation
│ ├── chrX.fa
│ └── chrX.gtf
├── fastq/ # Paired-end FASTQ files
├── INDEX/ # STAR genome index
├── TRIMMED/ # Trimmed FASTQ files
├── QC_REPORTS/ # FastQC + MultiQC reports
├── MAPPING/ # Aligned BAM files
├── READ_COUNT/ # featureCounts output
└── work/ # Nextflow working directory (not tracked)


⚠️ **Large reference genomes and FASTQ files are intentionally NOT tracked in Git.**

---

## Requirements

### Software
- Linux
- Java ≥ 11
- Conda / Mamba
- Nextflow ≥ 23 (DSL2 enabled)

### Tools (installed via Conda)
- `trim-galore`
- `fastqc`
- `multiqc`
- `star`
- `subread` (featureCounts)

Example Conda environment:
bash
conda create -n rnaseq \
  -c conda-forge -c bioconda \
  nextflow fastqc multiqc trim-galore star subread
conda activate rnaseq

Input Requirements
1. FASTQ files

Paired-end FASTQ files in fastq/ directory:

fastq/
├── sample1_1.fastq.gz
├── sample1_2.fastq.gz
├── sample2_1.fastq.gz
├── sample2_2.fastq.gz

2. Reference files (user provided)
Place reference files in ref/ directory:
ref/
├── genome.fa
└── annotation.gtf
Running the Pipeline



Basic execution command:

nextflow run rnaseq.nf \
  --ref_fasta ref/genome.fa \
  --ref_gtf ref/annotation.gtf \
  --reads 'fastq/*{_1,_2}.fastq.gz' \
  --strand 0



Parameters
Parameter	                Description
--ref_fasta	            Reference genome FASTA
--ref_gtf             	Gene annotation GTF
--reads	                Paired-end FASTQ pattern
--strand	              0 = unstranded, 1 = stranded, 2 = reverse


Output Summary
Directory	                  Content
TRIMMED/	              Adapter- and quality-trimmed FASTQ files
QC_REPORTS/	            FastQC + MultiQC reports
INDEX/	                STAR genome index
MAPPING/	              Sorted BAM alignment files
READ_COUNT/	            Gene-level count matrix

Design Notes
Implemented using Nextflow DSL2
Each step is modular and reusable
STAR index is built once and reused
Reference files are excluded from Git for reproducibility and size safety
Pipeline is suitable for:
                        Local execution
                        HPC clusters
                        Extension to nf-core–style workflows

Future Extensions
Planned additions:
                 Differential expression analysis (DESeq2)
                 Multi-sample metadata support (CSV samplesheet)
                 Docker / Singularity profiles
                 Extension to WGS, WES, ATAC-seq, ChIP-seq, and Metagenomics pipelines

## Author

Developed and executed by **Tharun Goud**  
GitHub: https://github.com/nadimpallygoud
