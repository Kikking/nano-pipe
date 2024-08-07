#!/bin/bash

REF=~/long_realm/ref/transcriptome_chr1S_SIRV.fa #Transcriptome
NAME=$1

#Need to align to transcriptome prior
minimap2 -ax splice $REF -t 8 --MD /mnt/d/SGNEX/fq/${NAME}.fastq | samtools view -b | samtools sort > /mnt/d/SGNEX/trans_bam/${NAME}.bam


OUTPUT=/mnt/d/SGNEX/quant/oarfish/${NAME}/${NAME}
mkdir -p ${OUTPUT}

oarfish \
    -a /mnt/d/SGNEX/trans_bam/${NAME}.bam \
    -o ${OUTPUT} \
    -j 10 #Threads
