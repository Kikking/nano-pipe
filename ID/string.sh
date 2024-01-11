#!/bin/bash


NAME=$1

SIRV_REF=/mnt/d/refData/lrgasp_grch38_sirvs.fasta
SIRV_ANNO=/mnt/d/refData/lrgasp_gencode_v38_sirvs.gtf

stringtie -G $SIRV_ANNO -o /mnt/d/SGNEX/String/${NAME}.gtf -L true -p 4 /mnt/d/SGNEX/mini_bam/${NAME}.bam