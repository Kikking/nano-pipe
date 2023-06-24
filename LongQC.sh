#!/usr/bin/env bash



for i in ~/mount/preqc; do 
    echo $i;
    python ~/LongQC/longQC.py sampleqc -x ont-rapid -o "QC_"+="$i"  $i;
done