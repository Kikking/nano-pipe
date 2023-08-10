#!/bin/bash

TARGET=$1

for SAMPLE in $TARGET/*
find $SAMPLE -f ".txt" > $HOME/mount/RTXT/"${SAMPLE##*/".txt 