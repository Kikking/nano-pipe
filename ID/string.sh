#!/bin/bash

#SIRV_ANNO=/mnt/e/refData/lrgasp_gencode_v38_sirvs.gtf
#SIRV_REF=/mnt/e/refData/lrgasp_grch38_sirvs.fasta
#SIRV_REF=/mnt/e/refData/hg38_sequins_SIRV_ERCCs_longSIRVs.fa 
SIRV_REF=/mnt/e/refData/current/GRCh38.p14_chr1S_SIRV.fa
#SIRV_ANNO=/mnt/e/refData/current/gencode45_chrIS_SIRV.gtf
SIRV_ANNO=/home/kikking/long_realm/ref/gencode45_chrIS_SIRV.gtf
#SIRV_ANNO=/mnt/e/refData/SIRV_edited.gtf

NAME=$1
NOVEL=${2-f}

if [ $NOVEL == "novel" ];then
echo "________NOVEL BEGIN___________"

stripped="${NAME#sd}"
TAG="${stripped%%_*}"
ANNO="/home/kikking/novel_realm/novel/NOVEL_${TAG}_gencode45_chrIS_SIRV.gtf"
OUT=stringtie/novel

else 
echo "________NORMAL BEGIN___________"
ANNO=$SIRV_ANNO
OUT=stringtie
fi

echo "::STRINGING::> '$NAME'"
time stringtie /mnt/d/SGNEX/mini_bam/${NAME}.bam -p 10 -B -G $ANNO -L -o /mnt/d/SGNEX/GTF_files/${OUT}/${NAME}/${NAME}.gtf



