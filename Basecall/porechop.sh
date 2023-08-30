#!/bin/bash

TARGET=$1

for SAMPLE in $TARGET
sudo porechop_abi -abi -i $SAMPLE -o $HOME/mount/trim/trim_"${SAMPLE##*/}"
done