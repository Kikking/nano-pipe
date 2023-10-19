#!/bin/bash

NAME=${1}
MODEL=${2-dna_r9.4.1_e8_hac@v3.3}

#basecall the pod5
dorado basecaller $MODEL ~/darter/p5/${NAME}.pod5 --emit-fastq > /mnt/d/SGNEX/fq/${NAME}.fastq

#QC the resulting fq
mkdir /mnt/d/SGNEX/nplot/${NAME} #make dir for output
pip install NanoPlot --upgrade append 2>/dev/null #Check np needs updgrade
NanoPlot -v #check np version

#NANOPLOT
echo "XXXXXXX NANOPLOTTING XXXXXXXXXXX"
time NanoPlot -t 2 --fastq /mnt/d/SGNEX/fq/${NAME}.fastq  -o /mnt/d/SGNEX/nplot/${NAME} --tsv_stats
    
 