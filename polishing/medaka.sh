#!/bin/bash

PORE=r941
DEVICE=min
CALLER=high
CALLERVER=g303

source ${MEDAKA}  # i.e. medaka/venv/bin/activate
NPROC=4
BASECALLS=/mnt/c/Users/User/Desktop/darter/raw_IFN/A549_IFNB_nanopore.fastq.gz
DRAFT=/mnt/c/Users/User/Desktop/darter/rac/IFN/rac_A549_IFNB_nanopore.fastq.gz.fasta
OUTDIR=/mnt/c/Users/User/Desktop/darter/med/IFN


medaka_consensus -i ${BASECALLS} -d ${DRAFT} -o ${OUTDIR} -t ${NPROC} -m r941_min_high_g303
#${PORE}_${DEVICE}_${CALLER}_${CALLERVER}