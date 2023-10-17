#!/bin/bash
NAME=$1


 single_to_multi_fast5 --input_path $NAME --save_path /mnt/c/Users/User/Desktop/darter/multif5/${NAME} --filename_base batch_output --batch_size 400 --recursive
 #Convert the multireads into pod5 format

 pod5 convert fast5 /mnt/c/Users/User/Desktop/darter/multif5/${NAME} --output p5/${NAME%.*}.pod5
 