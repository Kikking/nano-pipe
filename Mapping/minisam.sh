#!/bin/bash

SIRV_REF=~/darter/refData/lrgasp_grch38_sirvs.mmi
SIRV_ANNO=$HOME/mount/ref_data/lrgasp_gencode_v38_sirvs.gtf
NAME=$1

minimap2 -ax splice $SIRV_REF /mnt/d/SGNEX/fq/${NAME}.fastq | samtools view -b | samtools sort > /mnt/d/SGNEX/mini_bam/${NAME}.bam

qualimap bamqc -bam /mnt/d/SGNEX/mini_bam/${NAME}.bam -outdir /mnt/d/SGNEX/qualimap/${NAME} -c -nw 400 -hm 3