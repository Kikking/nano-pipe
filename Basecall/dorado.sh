#!/bin/bash

TARGET=${1-p5}
MODEL=${2-dna_r9.4.1_e8_hac@v3.3}

for POD in $TARGET/*
 do
 dorado basecaller $MODEL $POD --emit-fastq > fq/${POD%.*}.fastq
 done