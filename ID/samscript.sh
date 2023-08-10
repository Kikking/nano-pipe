#!/bin/bash

conda install -c bioconda samtools

samtools view -bS map_comb_A549_rep2_run1_guppy.fastq.sam > comb_A_d_r2r1.bam

samtools sort comb_A_d_r2r1.bam > sorted_comb_A_d_r2r1.bam