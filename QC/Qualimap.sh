#!/bin/bash
SIRV_ANNO=/mnt/e/refData/current/gencode45_chrIS_SIRV.gtf
TRANS_REF=/mnt/e/refData/latest/gencode.v44.transcripts.fa
SIRV_REF=/mnt/e/refData/current/GRCh38.p14_chr1S_SIRV.fa
NAME=$1

qualimap bamqc -bam /mnt/d/SGNEX/mini_bam/${NAME}.bam -outdir /mnt/d/SGNEX/qualimap/${NAME} \
--feature-file $SIRV_ANNO \
--java-mem-size=18G 