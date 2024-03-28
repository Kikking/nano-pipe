#!/bin/bash

#SIRV_REF=/mnt/e/refData/hg38_sequins_SIRV_ERCCs_longSIRVs.fa.mmi
SIRV_REF=/mnt/e/refData/current/GRCh38.p14_chr1S_SIRV.mmi
#SIRV_REF=/mnt/d/refData/lrgasp_grch38_sirvs.mmi
SIRV_ANNO=$HOME/mount/ref_data/lrgasp_gencode_v38_sirvs.gtf
NAME=$1

minimap2 -ax splice $SIRV_REF -t 6 --MD /mnt/d/SGNEX/fq/${NAME}.fastq | samtools view -b | samtools sort > /mnt/d/SGNEX/mini_bam/${NAME}.bam

