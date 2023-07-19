#!/bin/bash

SIRV_REF=$HOME/mount2/ref_data/lrgasp_grch38_sirvs.fasta.gz
SIRV_ANNO=$HOME/mount2/ref_data/lrgasp_gencode_v38_sirvs.gtf.gz
TARGET=$1
#samtools index $TARGET > $HOME/mount2/minidata_index/"${TARGET##*/}".bam
isoquant.py --reference $SIRV_REF  --genedb $SIRV_ANNO --bam $HOME/mount2/minidata_index/"${TARGET##*/}".bam --data_type nanopore -o $HOME/mount2/isoqdata

