#!/bin/bash

SIRV_REF=$HOME/lrgasp_grch38_sirvs.fasta.gz
SIRV_ANNO=$HOME/lrgasp_gencode_v38_sirvs.gtf.gz
SAMPLE=$1
#$HOME/mount/A549_QC/SGNex_A549_directcDNA_replicate2_run1.fastq.gz

cd
cd minimap2
./minimap2 -ax splice $SIRV_REF $SAMPLE > $HOME/minitest/map_"${SAMPLE##*/}".sam