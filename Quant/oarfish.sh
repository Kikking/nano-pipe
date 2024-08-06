#!/bin/bash

TARGET=$1
OUTPUT=/mnt/d/quant/oarfish/${TARGET}
mkdir -p ${OUTPUT}

oarfish \
    -a /mnt/d/SGNEX/mini_bam/${TARGET}.bam \
    -o ${OUTPUT} \
    -j 10 #Threads
