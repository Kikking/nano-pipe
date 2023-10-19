#!/bin/bash

SIRV_REF=/mnt/d/refData/lrgasp_grch38_sirvs.mmi
SIRV_ANNO=$HOME/mount/ref_data/lrgasp_gencode_v38_sirvs.gtf
NAME=$1
#$HOME/mount2/A549_QC/SGNex_A549_directcDNA_replicate2_run1.fastq.gz


minimap2 -ax splice $SIRV_REF /mnt/d/SGNEX/fq/${NAME}.fastq > /mnt/d/SGNEX/mini/${NAME}.sam


 #minimap2 -ax splice $HOME/mount2/ref_data/lrgasp_grch38_sirvs.mmi $HOME/mount2/A549_QC/SGNex_A549_directcDNA_replicate2_run1.fastq.gz > $HOME/mount2/minidata_sam/A_d_r2r1.sam