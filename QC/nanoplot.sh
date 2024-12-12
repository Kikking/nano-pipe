#!/bin/bash
NAME=$1

mkdir /mnt/d/SGNEX/nplot/${NAME}
pip install NanoPlot --upgrade append 2>/dev/null 
NanoPlot -v
echo "XXXXXXX NANOPLOTTING XXXXXXXXXXX"
time NanoPlot -t 10 --tsv_stats --raw --fastq /mnt/d/SGNEX/fq/${NAME}.fastq  -o /mnt/d/SGNEX/nplot/${NAME} 
    