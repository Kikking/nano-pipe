#!/usr/bin/env bash

CELL_LINE=$1
RERUN=${2:-y} #y or n (if n, will init as if not rerunning already processed data)
ONT_TYPE=${3:-ont-ligation} #-x ont-ligation, ont-rapid, ont-1dsq (maybe 1d2?)

#Create dir of reads to process
if [ $RERUN = "n" ]
then
    mkdir ~/mount/"$CELL_LINE"_QC
    find $HOME/mount/nanopore_data/ -type f -iname  *"$CELL_LINE"*"DNA"*".fastq.gz" -exec cp {} ~/mount/"$CELL_LINE"_QC/ \;
fi

#Run LongQC
for i in ~/mount/"$CELL_LINE"_QC/*
do
    echo "$i"
    python ~/LongQC/longQC.py sampleqc -x "$ONT_TYPE" -o $HOME/mount/postqc/QC_"${i##*/}"_"$ONT_TYPE"  "$i"
done

#bash ~/nano-pipe/LongQC.sh HepG2 n
#bash ~/nano-pipe/LongQC.sh A549 y ont-1dsq


#python ~/LongQC/longQC.py sampleqc -x ont-ligation -o $HOME/mount/postqc/QC_A549_rep2_run1_guppy  $HOME/mount/`A549_rep2_run1_guppy.fastq**`