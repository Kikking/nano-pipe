#!/bin/bash

SIRV_REF=/mnt/d/refData/lrgasp_grch38_sirvs.fasta
SIRV_ANNO=/mnt/d/refData/lrgasp_gencode_v38_sirvs.gtf

NAME=$1
echo "indexing..."
#time samtools index /mnt/d/SGNEX/mini_bam/${NAME}.bam  > /mnt/d/SGNEX/mini_bam/index/${NAME}.bam
echo "quanting..."
time isoquant.py --reference $SIRV_REF  --genedb $SIRV_ANNO --complete_genedb --bam  /mnt/d/SGNEX/mini_bam/${NAME}.bam.bai --data_type nanopore -o /mnt/d/SGNEX/isoq/${NAME}



