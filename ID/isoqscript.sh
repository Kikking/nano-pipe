#!/bin/bash

SIRV_REF=/mnt/d/refData/lrgasp_grch38_sirvs.fasta
SIRV_ANNO=/mnt/d/refData/lrgasp_gencode_v38_sirvs.gtf

NAME=$1
echo "indexing..."
time samtools index /mnt/d/SGNEX/mini_bam/${NAME}.bam 
echo "quanting..."
time isoquant.py --reference $SIRV_REF --prefix $NAME --genedb $SIRV_ANNO --complete_genedb -t 8 --high_memory --bam  /mnt/d/SGNEX/mini_bam/${NAME}.bam --data_type nanopore -o /mnt/d/SGNEX/GTF_files/isoquant/${NAME}
echo "renaming..." 
#time mv /mnt/d/SGNEX/GTF_files/isoquant/${NAME}/OUT/OUT.extended_annotations.gtf /mnt/d/SGNEX/GTF_files/isoquant/${NAME}/OUT/${NAME}.gtf 



