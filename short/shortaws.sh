#!/bin/bash
INPUT=$1

while read -r SAMPLE ; do
echo "::FETCHING::> '$SAMPLE'"
time aws s3 sync --no-sign-request s3://sg-nex-data/data/sequencing_data_illumina/fastq/$SAMPLE/ /mnt/d/SGNEX/short_fq/
done < $INPUT


