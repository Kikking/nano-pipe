#!/bin/bash

TARGET=$1

for SAMPLE in $TARGET
porechop_abi -abi -i ~/mount/raw_SGNex/SGNex_A549_cDNAStranded_replicate5_run2.fastq.gz -o $HOME/mount/trim/trim_"${SAMPLE##*/}"
done