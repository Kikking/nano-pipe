#!/bin/bash

SIRV_REF=/mnt/d/refData/lrgasp_grch38_sirvs.mmi
SIRV_ANNO=$HOME/mount/ref_data/lrgasp_gencode_v38_sirvs.gtf
TARGET=$1
#$HOME/mount2/A549_QC/SGNex_A549_directcDNA_replicate2_run1.fastq.gz

for SAMPLE in $TARGET/*
do
minimap2 -ax splice $SIRV_REF $SAMPLE > /mnt/c/Users/User/Desktop/darter/minidata_sam/map_"${SAMPLE##*/}".sam
done

 #minimap2 -ax splice $HOME/mount2/ref_data/lrgasp_grch38_sirvs.mmi $HOME/mount2/A549_QC/SGNex_A549_directcDNA_replicate2_run1.fastq.gz > $HOME/mount2/minidata_sam/A_d_r2r1.sam