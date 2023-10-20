#!/bin/bash

#SAMPLE=$1

for arg in "$@"; do
  echo "Executing looping on '$arg'"
done
#aws s3 sync --no-sign-request s3://sg-nex-data/data/sequencing_data_ont/fast5/$SAMPLE /mnt/d/gcp/tardata
