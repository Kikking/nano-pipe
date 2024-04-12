#!/bin/bash

SIRV_REF=/mnt/e/refData/current/GRCh38.p14_chr1S_SIRV.fa
SIRV_ANNO=/mnt/e/refData/current/gencode45_chrIS_SIRV.db
#SIRV_ANNO=/mnt/e/refData/lrgasp_gencode_v38_sirvs.db
#SIRV_REF=/mnt/e/refData/lrgasp_grch38_sirvs.fasta

NAME=$1
echo "indexing..."
time samtools index /mnt/d/SGNEX/mini_bam/${NAME}.bam 

echo "quanting..."
isoquant.py --reference $SIRV_REF --genedb $SIRV_ANNO \
--prefix $NAME \
--complete_genedb \
--clean_start --force \
-t 8 --high_memory \
--bam /mnt/d/SGNEX/mini_bam/${NAME}.bam \
--data_type nanopore -o /mnt/d/SGNEX/GTF_files/isoquant/

echo "renaming..." 
time mv /mnt/d/SGNEX/GTF_files/isoquant/${NAME}/${NAME}.extended_annotation.gtf /mnt/d/SGNEX/GTF_files/isoquant/${NAME}/${NAME}.gtf 

