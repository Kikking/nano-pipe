#!/bin/bash
SIRV_ANNO=/mnt/e/refData/current/gencode45_chrIS_SIRV.gtf
TRANS_REF=/mnt/e/refData/latest/gencode.v44.transcripts.fa
SIRV_REF=/mnt/e/refData/current/GRCh38.p14_chr1S_SIRV.fa
TARGET=sd_1_9000-2000_0.85
PRESET=$1
CYCLE=$2


file_exists() {
    local file="$1"
    [[ -f "$file" ]]
}

# Create SAM file

if ! file_exists "/mnt/e/tksm_realm/${TARGET}_tksm.tsv"; then
tksm abundance \
--paf /mnt/e/tksm_realm/$TARGET.paf \
--output /mnt/e/tksm_realm/${TARGET}_tksm.tsv 
awk 'BEGIN {FS=OFS="\t"} {sub(/\|.*$/, "", $1); print}' /mnt/e/tksm_realm/${TARGET}_tksm.tsv > /mnt/e/tksm_realm/tmp.tsv
mv /mnt/e/tksm_realm/tmp.tsv /mnt/e/tksm_realm/${TARGET}_tksm.tsv 
fi

ABTAB=/mnt/e/tksm_realm/${TARGET}_tksm.tsv 
echo "ABTAB: ${ABTAB}"

if ! file_exists "/mnt/e/tksm_realm/1000.MDF"; then
tksm transcribe -g $SIRV_ANNO \
-a $ABTAB \
-o /mnt/e/tksm_realm/1000.MDF \
--use-whole-id \
--molecule-count 1000
fi

MOL_NUM=$(echo "scale=0; 1000 * 2^${CYCLE}" | bc)
echo "MOL_NUM: ${MOL_NUM}"
tksm pcr -i   \
--molecule-count $MOL_NUM \
--cycles $CYCLE \
--preset $PRESET \
-o /mnt/e/tksm_realm/${PRESET}_${MOL_NUM}_${CYCLE}.MDF


tksm sequence \
-r $SIRV_REF \
-i /mnt/e/tksm_realm/${PRESET}_${MOL_NUM}_${CYCLE}.MDF \
--output-format fastq \
--perfect /mnt/d/SGNEX/fq/${PRESET}_${MOL_NUM}_${CYCLE}.fastq

echo "KEY: ${PRESET}_${MOL_NUM}_${CYCLE}"



