#!/bin/bash

SIRV_REF=/home/kikking/long_realm/ref/GRCh38.p14_chr1S_SIRV.fa
SIRV_ANNO=/home/kikking/long_realm/ref/gencode45_chrIS_SIRV.gtf
TARGET="$1"
TOOL="$2" # b = bambu, s = stringtie , i = isoquant , f = flair
REP=$3

case "$TOOL" in
  b)
    INDIR=bambu/${TARGET}/extended_annotations.gtf
    KEY=bambu
    ;;
  s)
    INDIR=stringtie/${TARGET}/${TARGET}.gtf
    KEY=stringtie
    ;;
  i)
    INDIR=isoquant/${TARGET}/${TARGET}.gtf
    KEY=isoquant
    ;;
  f)
    INDIR=flair/${TARGET}/${TARGET}.isoforms.gtf
    KEY=flair
    ;;
  e)
    INDIR=espresso/${TARGET}/${TARGET}.gtf
    KEY=espresso
    ;;
  t)
    INDIR=talon/${TARGET}/${TARGET}.gtf
    KEY=talon
    ;;

  *)
    echo "Error: Invalid tool value '$TOOL'."
    exit 1
    ;;
esac

if [[ "$TOOL" == "s" ]]; then
    # Only perform awk command if tool is stringtie
    awk -F'\t' 'BEGIN {OFS="\t"} {if ($7 == ".") $7 = "+"} 1' "/mnt/d/SGNEX/GTF_files/$INDIR" > tmp.gtf
    mv tmp.gtf /mnt/d/SGNEX/GTF_files/$INDIR
fi

# Run Sqanti script
python ~/SQANTI3/sqanti3_qc.py \
  "/mnt/d/SGNEX/GTF_files/$INDIR" "$SIRV_ANNO" "$SIRV_REF" \
  -d "/mnt/d/SGNEX/sqantout/${KEY}/${TARGET}/" \
  --polyA_motif_list ~/SQANTI3/data/polyA_motifs/mouse_and_human.polyA_motif.txt \
  --CAGE_peak ~/SQANTI3/data/ref_TSS_annotation/human.refTSS_v3.1.hg38.bed \
  --skipORF \
  --cpus 10 \
  --report pdf

 # -c /mnt/e/star_stuff/rep${REP}/SJ.out.tab \

#conda activate SQANTI3.env

