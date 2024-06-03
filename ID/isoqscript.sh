#!/bin/bash

SIRV_REF=/home/kikking/long_realm/ref/GRCh38.p14_chr1S_SIRV.fa
SIRV_ANNO=/home/kikking/long_realm/ref/gencode45_chrIS_SIRV.db
NOVEL_ANNO=/mnt/e/refData/current/gencode45_novel.db
#SIRV_ANNO=/mnt/e/refData/lrgasp_gencode_v38_sirvs.db
#SIRV_REF=/mnt/e/refData/lrgasp_grch38_sirvs.fasta


NAME=$1
NOVEL=${2-f}

if [ $NOVEL == "novel" ];then
echo "________NOVEL BEGIN___________"
ANNO=$NOVEL_ANNO
OUT=isoquant/novel
else 
echo "________NORMAL BEGIN___________"
ANNO=$SIRV_ANNO
OUT=isoquant
fi


echo "indexing..."
time samtools index /mnt/d/SGNEX/mini_bam/${NAME}.bam 

echo "quanting..."
isoquant.py --reference $SIRV_REF --genedb $ANNO \
--prefix $NAME \
--complete_genedb \
--force \
-t 8 --high_memory \
--bam /mnt/d/SGNEX/mini_bam/${NAME}.bam \
--data_type nanopore -o /mnt/d/SGNEX/GTF_files/${OUT}/ > /dev/null

echo "renaming..." 
time mv /mnt/d/SGNEX/GTF_files/${OUT}/${NAME}/${NAME}.extended_annotation.gtf /mnt/d/SGNEX/GTF_files/${OUT}/${NAME}/${NAME}.gtf 
