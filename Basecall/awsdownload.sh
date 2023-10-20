#!/bin/bash

SAMPLE_LIST=$1

for SAMPLE in $SAMPLE_LIST
do
aws s3 sync --no-sign-request s3://sg-nex-data/data/sequencing_data_ont/fast5/$SAMPLE /mnt/d/gcp/tardata
done