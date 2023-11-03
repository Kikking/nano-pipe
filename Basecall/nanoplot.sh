#!/bin/bash 



for NAME in "$@"; do;
echo "XXXXXXX NANOPLOTTING" $NAME "XXXXXXXXXXX"
time NanoPlot -t 4 --fastq /mnt/d/SGNEX/fq/${NAME}.fastq  -o /mnt/d/SGNEX/nplot/${NAME} --tsv_stats --raw
done