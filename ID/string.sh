#!/bin/bash


NAME=$1

SIRV_REF=~/darter/refData/lrgasp_grch38_sirvs.fasta.gz
SIRV_ANNO=~/darter/refData/lrgasp_gencode_v38_sirvs.gtf.gz

stringtie -G $SIRV_ANNO -o /mnt/d/SGNEX/String/${NAME}.gtf -L true -p 4 /mnt/d/SGNEX/mini_bam/${NAME}.bam