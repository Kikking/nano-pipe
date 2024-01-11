#!/bin/bash


NAME=$1

SIRV_REF=/mnt/d/refData/lrgasp_grch38_sirvs.fasta
SIRV_ANNO=/mnt/d/refData/lrgasp_gencode_v38_sirvs.gtf
echo $SIRV_ANNO
stringtie /mnt/d/SGNEX/mini_bam/${NAME}.bam -G $SIRV_ANNO -L -o /mnt/d/SGNEX/String/${NAME}.gtf  
--_