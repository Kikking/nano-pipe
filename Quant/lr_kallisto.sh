#!/bin/bash

#Reference Files
GTF=/home/kikking/long_realm/ref/gencode45_chrIS_SIRV.gtf
INDEX=/mnt/e/refData/kallindex/transcriptome_chr1S_SIRV.fa.idx

#Input and Output destinations
TARGET=$1
OUTPUT=/mnt/d/SGNEX/quant/kallisto/${TARGET}
mkdir -p ${OUTPUT}

#Genarate cm

kallisto quant --long -P ONT \
-i $INDEX \
-o $OUTPUT \
-t 10 \
/mnt/d/SGNEX/fq/${TARGET}.fastq
