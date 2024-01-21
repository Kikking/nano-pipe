#!/bin/bash

SIRV_REF=/mnt/d/refData/lrgasp_grch38_sirvs.fasta
SIRV_ANNO=/mnt/d/refData/lrgasp_gencode_v38_sirvs.gtf

for NAME in "$@"; do
echo "::STRINGING::> '$NAME'"
time stringtie /mnt/d/SGNEX/mini_bam/${NAME}.bam -e -G $SIRV_ANNO -L -o /mnt/d/SGNEX/String/${NAME}.gtf  
done



