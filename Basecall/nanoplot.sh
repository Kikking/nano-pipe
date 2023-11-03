#!/bin/bash 

NAME=$1

echo "XXXXXXX NANOPLOTTING XXXXXXXXXXX"
time NanoPlot -t 4 --fastq /mnt/d/SGNEX/fq/${NAME}.fastq  -o /mnt/d/SGNEX/nplot/${NAME} --tsv_stats --raw