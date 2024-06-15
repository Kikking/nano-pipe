#!/bin/bash

# A script that runs IsoQuant with paired long and short reads

SIRV_REF=/home/kikking/long_realm/ref/GRCh38.p14_chr1S_SIRV.fa
SIRV_ANNO=/home/kikking/long_realm/ref/gencode45_chrIS_SIRV.db

TAG=$1 # Either Hc, H, A, K

#echo "Indexing..."
#time samtools index /mnt/d/SGNEX/mini_bam/${TAG}_d*.bam

echo "Quantifying..."
echo "__________SHORT__________________"
echo /mnt/d/SGNEX/short_bam/${TAG}_*.bam
echo "_________________________________"
echo "___________LONG__________________"
echo /mnt/d/SGNEX/mini_bam/${TAG}_d*.bam 
echo "_________________________________"
isoquant.py --reference $SIRV_REF --genedb $SIRV_ANNO \
--prefix $TAG \
--complete_genedb \
--no_model_construction \
--force \
-t 8 --high_memory \
--bam /mnt/d/SGNEX/mini_bam/${TAG}_d*.bam \
--illumina_bam /mnt/e/barbet/${TAG}_*.bam \
--data_type nanopore -o /mnt/d/SGNEX/GTF_files/isoquant/${TAG}/ 

echo "Renaming..."
time mv /mnt/d/SGNEX/GTF_files/isoquant/${TAG}/${TAG}.extended_annotation.gtf /mnt/d/SGNEX/GTF_files/isoquant/${TAG}/${TAG}.gtf
