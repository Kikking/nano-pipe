#!/bin/bash
TARGET=$1

for DIR in TARGET/*
do
for FILE in DIR/*
do
pod5 convert fast5 $FILE --output "${FILE%.*}".pod5
done 
done