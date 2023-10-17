#!/bin/bash
PLEX=${1-plex1}

for FILE in f5_untar/${PLEX}/*
do
 single_to_multi_fast5 --input_path $FILE --save_path multif5/${PLEX}/${FILE##*/} --filename_base batch_output --batch_size 100 --recursive
 #Convert the multireads into pod5 format
 done
 for DIR in multif5/${PLEX}/*
 pod5 convert fast5 $DIR --output p5/${DIR%.*}.pod5
 done