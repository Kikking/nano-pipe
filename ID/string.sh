#!/bin/bash

SIRV_ANNO=/mnt/e/refData/lrgasp_gencode_v38_sirvs.gtf
SIRV_REF=/mnt/e/refData/lrgasp_grch38_sirvs.fasta
#SIRV_REF=/mnt/d/refData/hg38_sequins_SIRV_ERCCs_longSIRVs.fa 
#SIRV_ANNO=/mnt/d/refData/hg38_sequins_SIRV_ERCCs_longSIRVs_v5_reformatted.gtf

for NAME in "$@"; do
echo "::STRINGING::> '$NAME'"
time stringtie /mnt/d/SGNEX/mini_bam/${NAME}.bam -e -B -G $SIRV_ANNO -L -o /mnt/d/SGNEX/GTF_files/stringtie/${NAME}/${NAME}.gtf  
done



