#!/bin/bash

for SAMPLE in "$@"; do
echo "::FETCHING::> '$SAMPLE'"
time aws s3 sync --no-sign-request s3://sg-nex-data/data/sequencing_data_illumina/fastq/$SAMPLE/ ~/barbet/fq/
done