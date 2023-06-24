#!/usr/bin/env bash



for i in ~/mount/preqc; do 
    echo $i;
    python longQC/longQC.py sampleqc -x ont-rapid -o postqc/"QC_"+="$i"  $i;
done