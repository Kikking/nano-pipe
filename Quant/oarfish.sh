#!/bin/bash

TARGET=$1
OUTPUT=/mnt/d/SGNEX/quant/oarfish/${TARGET}/${TARGET}
mkdir -p ${OUTPUT}

oarfish \
    -a /mnt/d/SGNEX/mini_bam/${TARGET}.bam \
    -o ${OUTPUT} \
    -j 10 #Threads
