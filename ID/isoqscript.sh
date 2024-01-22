#!/bin/bash

SIRV_REF=/mnt/d/refData/lrgasp_grch38_sirvs.fasta
SIRV_ANNO=/mnt/d/refData/lrgasp_gencode_v38_sirvs.gtf

NAME=$1
#samtools index $TARGET > $HOME/mount2/minidata_index/"${TARGET##*/}".bam
time isoquant.py --reference $SIRV_REF  --genedb $SIRV_ANNO --complete_genedb --bam /mnt/d/SGNEX/mini_bam/${NAME}.bam  --data_type nanopore -o /mnt/d/SGNEX/isoq/${NAME}



