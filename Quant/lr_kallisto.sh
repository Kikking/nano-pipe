#!/bin/bash

GTF=/home/kikking/long_realm/ref/gencode45_chrIS_SIRV.db
TARGET=$1

mkdir /mnt/d/SGNEX/quant/kallisto/${TARGET}

kallisto bus /mnt/d/SGNEX/fq/$TARGET.fastq \
-o /mnt/d/SGNEX/quant/kallisto/${TARGET}/ \
-p ONT \
-i /mnt/e/refData/kallindex/transcriptome_chr1S_SIRV.fa.idx \
--gtf $GTF \
-t 10 \
--long

