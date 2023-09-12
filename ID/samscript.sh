#!/bin/bash

conda install -c bioconda samtools

samtools view -bS /mnt/d/minidata_sam/map_A549_IFNB_nanopore.fastq.gz.sam > /mnt/d/minidata_bam/map_A549_IFNB_nanopore.bam

samtools sort /mnt/d/minidata_bam/map_A549_IFNB_nanopore.bam > /mnt/d/minidata_bam/sorted_A549_IFNB_nanopore.bam