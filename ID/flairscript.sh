#!/bin/bash 

SIRV_REF=/mnt/e/refData/current/GRCh38.p14_chr1S_SIRV.fa
SIRV_ANNO=/mnt/e/refData/current/gencode45_chrIS_SIRV.gtf
TARGET=$1

echo ":::PUTTING $TARGET TO BED:::::>"
bam2Bed12 -i /mnt/d/SGNEX/mini_bam/${TARGET}.bam > /mnt/e/flair_realm/sd_1_9000-2000_0.85.bed12

echo ":::CORRECTING BED:::::>"
flair correct -q /mnt/e/flair_realm/${TARGET}.bed12 \
 -f $SIRV_ANNO -g $SIRV_REF \
 --output /mnt/e/flair_realm/${TARGET} \
 --threads 8 \
 --print_check

echo ":::BED IS COLLAPSING!!:::::>"
flair collapse -q reads.flair_all_corrected.bed \
-r $TARGET.fastq \
-g $SIRV_REF --gtf $SIRV_ANNO \ 
--stringent \
--check_splice \
--generate_map \
--annotation_reliant generate \
--support 1

echo ":::QUANTIFYING:::::>"
flair quantify -r reads_manifest -i flair.collapse.isoforms.fa
