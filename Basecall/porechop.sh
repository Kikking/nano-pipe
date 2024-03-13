#!/bin/bash

SAMPLE=$1
bash ~/nano-pipe/Basecall/porechop.sh raw_IFN/HT1376_mock_nanopore.fastq.gz
bash ~/nano-pipe/Basecall/porechop.sh raw_IFN/A549_mock_nanopore.fastq.gz

porechop_abi -abi -t 8 -i $SAMPLE -o /mnt/c/Users/User/Desktop/darter/porechopped/"${SAMPLE##*/}".fasta