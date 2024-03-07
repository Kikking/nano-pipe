#!/bin/bash

#without fa,gz 
for SAMPLE in "$@"; do
echo "::FETCHING::> '$SAMPLE'"
time aws s3 sync --no-sign-request s3://sg-nex-data/data/sequencing_data_ont/fast5/$SAMPLE/ /mnt/d/gcp/tardata 
done
