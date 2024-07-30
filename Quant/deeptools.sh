#!/bin/bash

# Define file paths
BAM_FILE=/mnt/d/IFN_darter/minidata_bam/minidata_bam/$1.bam
BIGWIG_FILE=/mnt/d/IFN_darter/minidata_bam/minidata_bam/$1.bw

# Run bamCoverage with optimizations
bamCoverage \
  -b $BAM_FILE \
  -o $BIGWIG_FILE \
  --numberOfProcessors max \
  --binSize 50 \
  --verbose
