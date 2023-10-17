#!/bin/bash

TARGET=${1-p5}
MODEL=${2-dna_r9.4.1_e8_hac@v3.3}


 dorado basecaller $MODEL ~/darter/p5/${TARGET}.pod5 --emit-fastq > ~/darter/fq/${TARGET}.fastq
 