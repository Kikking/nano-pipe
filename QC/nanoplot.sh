#!/bin/bash
NAME=$1

pip install NanoPlot --upgrade
NanoPlot -t 6 --fastq ~/mnt/d/SGNEX/fq/${NAME}  --tsv_stats
    