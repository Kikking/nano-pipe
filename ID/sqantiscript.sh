#!/bin/bash

SIRV_REF=/mnt/e/refData/current/GRCh38.p14_chr1S_SIRV.fa
SIRV_ANNO=/mnt/e/refData/current/gencode45_chrIS_SIRV.gtf
TARGET="$1"
TOOL="$2" # b = bambu, s = stringtie , i = isoquant

if [[ "$TOOL" =~ ^[ibs]$ ]]; then
  case "$TOOL" in
    b) INDIR=bambu/${TARGET}/extended_annotations.gtf ;;
    s) INDIR=stringtie/${TARGET}/${TARGET}.gtf ;;
    i) INDIR=isoquant/${TARGET}/${TARGET}.gtf ;;
  esac
else
  echo "Error: Invalid tool value '$TOOL'. Please use 'b', 's', or 'i'."
  exit 1
fi

 
#Run Sqanti script
python sqanti3_qc.py \
/mnt/d/SGNEX/GTF_files/"$INDIR" $SIRV_ANNO $SIRV_REF \
-d /mnt/d/SGNEX/sqantout/"$INDIR"/"$TARGET" \
--polyA_motif_list ~/SQANTI3/data/polyA_motifs/mouse_and_human.polyA_motif.txt \
--CAGE_peak ~/SQANTI3/data/ref_TSS_annotation/human.refTSS_v3.1.hg38.bed \
--skipORF \
--cpus 10 \
--report pdf                   




#conda activate SQANTI3.env

