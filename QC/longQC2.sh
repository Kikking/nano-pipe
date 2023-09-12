#!/bin/bash

TARGET=$1
ONT_TYPE=${2:-ont-ligation}

for i in $TARGET/*
do
    echo "$i"
    python ~/LongQC/longQC.py sampleqc -x "$ONT_TYPE" -o $HOME/mnt/d/postqc_IFN/QC_"${i##*/}"_"$ONT_TYPE"  "$i"
done