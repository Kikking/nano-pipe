#!/usr/bin/env bash

CELL_LINE=$1

mkdir ~/mount/"$CELL_LINE"_QC
find $HOME/mount/nanopore_data/ -type f -iname  *"$CELL_LINE"*"DNA"*".fastq.gz" -exec cp {} ~/mount/"$CELL_LINE"_QC/ \;

for i in ~/mount/"$CELL_LINE"_QC/*
do
    echo "$i"
    python ~/LongQC/longQC.py sampleqc -x ont-ligation -o $HOME/mount/postqc/QC_"${i##*/}"  "$i"
done
#-x ont-ligation, ont-rapid, ont-1dsq (maybe 1d2?)