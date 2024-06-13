#!/bin/bash 

INPUT_FILE=$1

while read NAME ;do
mkdir /mnt/e/barbet/trim/${NAME}
trim_galore --cores 4 -o /mnt/e/barbet/trim/${NAME}/ --paired /mnt/d/SGNEX/short_fq/${NAME}_R1.fastq.gz /mnt/d/SGNEX/short_fq/${NAME}_R2.fastq.gz
done < $INPUT_FILE