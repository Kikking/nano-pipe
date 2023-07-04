#!/bin/bash

SIRV_REF=$HOME/mount/refiles/lrgasp_grch38_sirvs.fasta.gz
SIRV_ANNO=$HOME/mount/refiles/lrgasp_gencode_v38_sirvs.gtf.gz
SAMPLE=$HOME/mount/A549_QC/SGNex_A549_directcDNA_replicate2_run1.fastq.gz

./minimap2 -ax splice $SIRV_REF $SAMPLE > map_"${SAMPLE##*/}".sam