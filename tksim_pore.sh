#!/bin/bash

SIRV_ANNO=/mnt/e/refData/current/gencode45_chrIS_SIRV.gtf
TRANS_REF=/mnt/e/refData/latest/gencode.v44.transcripts.fa
SIRV_REF=/mnt/e/refData/current/GRCh38.p14_chr1S_SIRV.fa
TARGET=sd_1_9000-2000_0.85
MODEL=18,20,23
MOL_NUM=$1



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

if ! file_exists "/mnt/e/tksm_realm/${MOL_NUM}.MDF"; then
tksm transcribe -g $SIRV_ANNO \
-a $ABTAB \
-o /mnt/e/tksm_realm/${MOL_NUM}.MDF \
--use-whole-id \
--molecule-count ${MOL_NUM}
fi
for YEAR in $MODEL;do
echo $YEAR
tksm sequence \
-r $SIRV_REF \
-i /mnt/e/tksm_realm/${MOL_NUM}.MDF \
--output-format fastq \
--badread-error-model ~/miniconda3/pkgs/tksm-0.6.0-py310h2b6aa90_0/bin/tksm_models/badread/nanopore20${YEAR}.error.gz \
--badread-qscore-model ~/miniconda3/pkgs/tksm-0.6.0-py310h2b6aa90_0/bin/tksm_models/badread/nanopore20${YEAR}.qscore.gz \
--badread /mnt/d/SGNEX/fq/bad_${MOL_NUM}_${YEAR}.fastq \
--perfect /mnt/d/SGNEX/fq/per_${MOL_NUM}_${YEAR}.fastq
done