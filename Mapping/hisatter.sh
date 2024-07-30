#!/bin/bash

INPUT=$1

#Reads a txt file list of sample names
while read -r NAME ;do

# Define variables
INDEX="/home/kikking/hisat2/GRCh38.p14_chr1S_SIRV"
READ1="/mnt/e/barbet/trim/${NAME}/${NAME}_R1_val_1.fq.gz"
READ2="/mnt/e/barbet/trim/${NAME}/${NAME}_R2_val_2.fq.gz"

#Run Hisat2
echo "[[[[[[[[[HISATTING ${NAME}]]]]]]]]]"
time /home/kikking/hisat2/hisat2 -x $INDEX \
-1 $READ1 -2 $READ2 \
-p 10 \
-S /mnt/e/barbet/short_bam/${NAME}.sam

#Convert SAM output to BAM
echo "[[[[[[[[[SAMMING ${NAME}]]]]]]]]]"
samtools view -@ 10 -bS /mnt/e/barbet/short_bam/${NAME}.sam | samtools sort -@ 10 > /mnt/e/barbet/short_bam/${NAME}.bam

#Delete SAM file if BAM file exists
if [ -f /mnt/e/barbet/short_bam/${NAME}.bam ]; then
echo "[[[[[[[[[RMING ${NAME}]]]]]]]]]"
rm /mnt/e/barbet/short_bam/${NAME}.sam
fi

done < $INPUT