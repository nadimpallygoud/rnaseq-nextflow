# RNA-seq Analysis Pipeline (Nextflow DSL2)

This repository contains a **minimal, fully reproducible RNA-seq analysis pipeline**
implemented using **Nextflow DSL2**.

The pipeline was developed and executed locally using **publicly available test data**
(human chromosome X subset) and standard RNA-seq analysis tools. It demonstrates a
complete end-to-end RNA-seq workflow following best practices for reproducible
computational genomics.

---

## Pipeline Overview

The workflow performs the following steps:

1. Read trimming using **Trim Galore**
2. Quality control (QC) using **FastQC** and **MultiQC**
3. Genome index generation using **STAR**
4. Read alignment using **STAR**
5. Gene-level read counting using **featureCounts**

All steps are orchestrated using **Nextflow DSL2**, enabling modularity,
reproducibility, and easy extension to other datasets and computing environments.

---

## Tools Used

| Tool | Purpose |
|------|--------|
| Nextflow (DSL2) | Workflow orchestration |
| Trim Galore | Adapter and quality trimming |
| FastQC | Read quality assessment |
| MultiQC | QC report aggregation |
| STAR | RNA-seq read alignment |
| featureCounts (Subread) | Gene-level read quantification |

---

## Directory Structure

rnaseq-nextflow/
├── rnaseq.nf
├── README.md
├── .gitignore
├── ref/
├── fastq/
├── INDEX/
├── TRIMMED/
├── QC_REPORTS/
├── MAPPING/
├── READ_COUNT/
└── work/


**Notes:**
- `ref/` contains reference genome and annotation files (user provided)
- `fastq/` contains paired-end FASTQ files (user provided)
- `work/` is the Nextflow working directory and is not tracked in Git

⚠️ Large reference genomes and FASTQ files are intentionally **not committed** to Git.

---

## Requirements

### Software

- Linux
- Java ≥ 11
- Conda or Mamba
- Nextflow ≥ 23 (DSL2 enabled)

### Tool Installation (Conda)

```bash
conda create -n rnaseq \
  -c conda-forge -c bioconda \
  nextflow fastqc multiqc trim-galore star subread
conda activate rnaseq
Input Requirements
1. FASTQ Files
Paired-end FASTQ files placed in the fastq/ directory:

fastq/
├── sample1_1.fastq.gz
├── sample1_2.fastq.gz
├── sample2_1.fastq.gz
├── sample2_2.fastq.gz
2. Reference Files (User Provided)
Reference genome and annotation placed in the ref/ directory:

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
Parameter	Description
--ref_fasta	Reference genome FASTA
--ref_gtf	Gene annotation GTF
--reads	Paired-end FASTQ glob pattern
--strand	0 = unstranded, 1 = stranded, 2 = reverse-stranded
Output Summary
Directory	Description
TRIMMED/	Adapter- and quality-trimmed FASTQ files
QC_REPORTS/	FastQC and MultiQC reports
INDEX/	STAR genome index
MAPPING/	Sorted BAM alignment files
READ_COUNT/	Gene-level read count matrix
Design Notes
Implemented using Nextflow DSL2

Modular and reusable process structure

STAR genome index is generated once and reused

Reference and FASTQ files are excluded from version control

Suitable for:

Local execution

HPC environments

Extension to nf-core–style workflows

Future Extensions
Planned extensions include:

Differential expression analysis using DESeq2

Sample metadata support via CSV samplesheets

Docker and Singularity execution profiles

Extension to additional NGS workflows:

Whole-genome sequencing (WGS)

Whole-exome sequencing (WES)

ATAC-seq

ChIP-seq

Metagenomics

Author
Developed and executed by Tharun Goud
GitHub: https://github.com/nadimpallygoud


---

### What to do now

```bash
git add README.md
git commit -m "Add consistent README for RNA-seq Nextflow DSL2 pipeline"
git push
