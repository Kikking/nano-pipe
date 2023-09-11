#!/bin/bash

TARGET=$1

for SAMPLE in $TARGET/*
do
porechop_abi -abi -t 4 -i $SAMPLE -o $HOME/mount/trim/trim_"${SAMPLE##*/}"
done