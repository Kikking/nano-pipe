#!/bin/bash

SAMPLE=$1

samtools view -b $SAMPLE | samtools sort > /mnt/c/Users/User/Desktop/darter/minidata_bam/"${SAMPLE%.*}".bam
qualimap bamqc -bam /mnt/c/Users/User/Desktop/darter/minidata_bam/"${SAMPLE%.*}".bam -outdir /mnt/c/Users/User/Desktop/darter/qualimap/"quali_"${SAMPLE%.*}" -c -nw 400 -hm 3