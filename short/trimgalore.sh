#!/bin/bash 

NAME=$1
mkdir /mnt/e/barbet/trim/${NAME}
trim_galore --cores 4 -o /mnt/e/barbet/trim/${NAME}/ --paired /mnt/d/SGNEX/short_fq/${NAME}_R1.fastq.gz /mnt/d/SGNEX/short_fq/${NAME}_R2.fastq.gz
