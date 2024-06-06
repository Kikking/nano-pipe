#!/bin/bash 

SIRV_REF=/home/kikking/long_realm/ref/GRCh38.p14_chr1S_SIRV.fa
SIRV_ANNO=/home/kikking/long_realm/ref/gencode45_chrIS_SIRV.gtf

NAME=$1
NOVEL=${2-f}

if [ $NOVEL == "novel" ];then
echo "________NOVEL BEGIN___________"

stripped="${NAME#sd}"
TAG="${stripped%%_*}"
ANNO="/home/kikking/novel_realm/novel/NOVEL_${TAG}_gencode45_chrIS_SIRV.gtf"
OUT=flair/novel

else 
echo "________NORMAL BEGIN___________"
ANNO=$SIRV_ANNO
OUT=flair
fi

echo ":::PUTTING $NAME TO BED:::::>"
bam2Bed12 -i /mnt/d/SGNEX/mini_bam/${NAME}.bam > /mnt/e/flair_realm/${NAME}.bed12

echo ":::CORRECTING BED:::::>"
flair correct -q /mnt/e/flair_realm/${NAME}.bed12 \
 -f $ANNO -g $SIRV_REF \
 --output /mnt/e/flair_realm/${NAME} \
 --threads 10 > /dev/null

echo ":::BED IS COLLAPSING!!:::::>"
mkdir /mnt/d/SGNEX/GTF_files/flair/${NAME}
flair collapse -q /mnt/e/flair_realm/${NAME}_all_corrected.bed \
-r /mnt/d/SGNEX/fq/${NAME}.fastq \
-g $SIRV_REF --gtf $ANNO \
--generate_map \
--annotation_reliant generate \
--support 1 \
--output /mnt/d/SGNEX/GTF_files/${OUT}/${NAME}/${NAME} \
--threads 10

#echo ":::QUANTIFYING:::::>"
#flair quantify -r reads_manifest -i flair.collapse.isoforms.fa
