#!/bin/bash
NAME=$1

mkdir /mnt/d/SGNEX/nplot/${NAME}
pip install NanoPlot --upgrade
NanoPlot -t 6 --fastq ~/mnt/d/SGNEX/fq/${NAME}.fastq  -o /mnt/d/SGNEX/nplot/${NAME} --tsv_stats
    