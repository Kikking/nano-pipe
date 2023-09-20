#!/bin/bash

$SAMPLE=$1

samtools view -bS $SAMPLE | samtools sort > /mnt/c/Users/User/Desktop/darter/minidata_bam/"${SAMPLE%.*}".bam
qualimap bamqc -bam /mnt/c/Users/User/Desktop/darter/minidata_bam/"${SAMPLE%.*}".bam -outdir /mnt/c/Users/User/Desktop/darter/qualimap -c -nw 400 -hm 3