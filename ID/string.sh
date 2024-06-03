#!/bin/bash

#SIRV_ANNO=/mnt/e/refData/lrgasp_gencode_v38_sirvs.gtf
#SIRV_REF=/mnt/e/refData/lrgasp_grch38_sirvs.fasta
#SIRV_REF=/mnt/e/refData/hg38_sequins_SIRV_ERCCs_longSIRVs.fa 
SIRV_REF=/mnt/e/refData/current/GRCh38.p14_chr1S_SIRV.fa
#SIRV_ANNO=/mnt/e/refData/current/gencode45_chrIS_SIRV.gtf
SIRV_ANNO=/home/kikking/long_realm/ref/gencode45_chrIS_SIRV.gtf
#SIRV_ANNO=/mnt/e/refData/SIRV_edited.gtf

for NAME in "$@"; do
echo "::STRINGING::> '$NAME'"
time stringtie /mnt/d/SGNEX/mini_bam/${NAME}.bam -p 10 -B -G $SIRV_ANNO -L -o /mnt/d/SGNEX/GTF_files/stringtie/${NAME}/${NAME}.gtf  
done



