#!/usr/bin/env bash



for i in ~/mount/preqc/*
do 
    echo "$i"
    echo "I love Julia"
    python ~/LongQC/longQC.py sampleqc -x ont-rapid -o postqc/QC_"${i##*/}"  "$i"
done