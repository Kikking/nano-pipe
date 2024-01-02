#!/bin/bash

NAME=$1
#MODE={$2-both} #sam, quali or both 

samtools view -b /mnt/d/SGNEX/mini/$NAME.sam | samtools sort > /mnt/d/SGNEX/mini_bam/${NAME}.bam
qualimap bamqc -bam /mnt/d/SGNEX/mini_bam/${NAME}.bam -outdir /mnt/d/SGNEX/qualimap/${NAME} -c -nw 200 -hm 3
