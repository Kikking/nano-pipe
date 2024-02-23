#!/bin/bash

SIRV_REF=/mnt/d/refData/lrgasp_grch38_sirvs.fasta
NAME=$1 

samtools view -h /mnt/d/SGNEX/mini_bam/${NAME}.bam | samtools sort > /mnt/d/SGNEX/talon_stuff/sam_files/${NAME}.sam
transcriptclean --sam /mnt/d/SGNEX/talon_stuff/sam_files/${NAME}.sam --genome $SIRV_REF --outprefix /mnt/d/SGNEX/talon_stuff/clean_files