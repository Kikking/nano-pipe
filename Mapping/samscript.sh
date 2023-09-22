#!/bin/bash

TARGET=$1
#MODE={$2-both} #sam, quali or both 
for SAMPLE in $TARGET/*
do
samtools view -b $SAMPLE | samtools sort > /mnt/d/minidata_bam/${SAMPLE%.*}.bam
qualimap bamqc -bam /mnt/d/minidata_bam/${SAMPLE%.*}.bam -outdir /mnt/d/qualimap/quali_${SAMPLE%.*} -c -nw 400 -hm 3
done