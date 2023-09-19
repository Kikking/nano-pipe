#!/bin/bash

TARGET=$1
ONT_TYPE=${2:-ont-ligation}

for i in $TARGET/*
do
    echo "#########################################################################"
    echo "$i"
    echo "#########################################################################"
    python ~/LongQC/longQC.py sampleqc -x "$ONT_TYPE" -o /mnt/c/Users/User/Desktop/darter/porechopped/"${i##*/}"_"$ONT_TYPE"  "$i"
done