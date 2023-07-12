#!/bin/bash

SIRV_REF=$HOME/lrgasp_grch38_sirvs.fasta.gz
SIRV_ANNO=$HOME/lrgasp_gencode_v38_sirvs.gtf.gz
TARGET=$1
#$HOME/mount/A549_QC/SGNex_A549_directcDNA_replicate2_run1.fastq.gz
cd
cd minimap2
for SAMPLE in $TARGET/*
./minimap2 -ax splice $SIRV_REF $SAMPLE | samtools view -b | samtools sort > $HOME/mount/minidata/map_"${SAMPLE##*/}".bam
 