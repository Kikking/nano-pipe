#!/bin/bash


MODEL=rna004_130bps_hac@v3.0.1

pip install NanoPlot --upgrade append 2>/dev/null #Check np needs updgrade
NanoPlot -v #check np version

for NAME in "$@";do
#basecall the pod5
dorado basecaller $MODEL /mnt/d/SGNEX/p5/${NAME}.pod5 --emit-fastq > /mnt/d/SGNEX/fq/${NAME}.fastq

#QC the resulting fq
mkdir /mnt/d/SGNEX/nplot/${NAME} #make dir for output
#NANOPLOT
echo "XXXXXXX NANOPLOTTING" $NAME "XXXXXXXXXXX"
time NanoPlot -t 6 --fastq /mnt/d/SGNEX/fq/${NAME}.fastq  -o /mnt/d/SGNEX/nplot/${NAME} --tsv_stats --raw
done 
 