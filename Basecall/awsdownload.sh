#!/bin/bash

#without fa,gz 
for SAMPLE in "$@"; do
echo "::FETCHING::> '$SAMPLE'"
time wget -c http://sg-nex-data.s3.amazonaws.com/data/sequencing_data_ont/fast5/$SAMPLE/$SAMPLE.tar.gz  /mnt/d/gcp/tardata 
done
