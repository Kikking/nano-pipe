#!/usr/bin/env bash

cd LongQC

for i in ~/mount/preqc; do 
    echo $i;
    python longQC.py sampleqc -x ont-rapid -o postqc/"QC_"+="$i"  $i;
done