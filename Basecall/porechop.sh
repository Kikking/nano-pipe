#!/bin/bash

TARGET=$1

porechop_abi -abi -t 8 -i $SAMPLE -o /mnt/c/Users/User/Desktop/darter/porechopped/"${SAMPLE##*/}".fasta