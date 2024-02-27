#!/bin/bash

SIRV_REF=/mnt/d/refData//mnt/d/refData/hg38_sequins_SIRV_ERCCs_longSIRVs.fa 
SIRV_ANNO=/mnt/d/refData/hg38_sequins_SIRV_ERCCs_longSIRVs_v5_reformatted.gtf

NAME=$1
echo "indexing..."
time samtools index /mnt/d/SGNEX/mini_bam/${NAME}.bam 
echo "quanting..."
time isoquant.py --reference $SIRV_REF --prefix $NAME --genedb $SIRV_ANNO -t 8 --high_memory disable_infer_transcripts=True --bam  /mnt/d/SGNEX/mini_bam/${NAME}.bam --data_type nanopore -o /mnt/d/SGNEX/GTF_files/isoquant/
echo "renaming..." 
time mv /mnt/d/SGNEX/GTF_files/isoquant/${NAME}/${NAME}.extended_annotation.gtf /mnt/d/SGNEX/GTF_files/isoquant/${NAME}/${NAME}.gtf 



