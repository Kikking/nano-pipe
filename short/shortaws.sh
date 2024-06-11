#!/bin/bash
INPUT=$1

while read -r SAMPLE ; do
echo "::FETCHING::> '$SAMPLE'"
time aws s3 sync --no-sign-request s3://sg-nex-data/data/sequencing_data_illumina/bam/$SAMPLE/ /mnt/d/SGNEX/short_bam/
done < $INPUT


