#!/bin/bash

SIRV_REF=/mnt/e/refData/current/GRCh38.p14_chr1S_SIRV.fa
SIRV_ANNO=/mnt/e/refData/current/gencode45_chrIS_SIRV.gtff

STAR --runThreadN 8 \
--runMode genomeGenerate \
--genomeDir /mnt/e/refData/star_index/ \
--genomeFastaFiles $SIRV_REF \
--sjdbGTFfile $SIRV_ANNO