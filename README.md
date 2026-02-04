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



## Author

Developed and executed by **Tharun Goud**  
GitHub: https://github.com/nadimpallygoud
