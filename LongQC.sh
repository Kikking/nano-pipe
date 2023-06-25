#!/usr/bin/env bash



for i in ~/mount/preqc/*
do 
    echo "$i"
    python ~/LongQC/longQC.py sampleqc -x ont-ligation -o $HOME/mount/postqc/QC_"${i##*/}"  "$i"
done
#-x ont-ligation, ont-rapid, ont-1dsq (maybe 1d2?)