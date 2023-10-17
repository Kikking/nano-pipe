#!/bin/bash
NAME=$1

echo "merging file path: /mnt/c/Users/User/Desktop/darter/f5_untar/"${NAME}
 single_to_multi_fast5 --input_path /mnt/c/Users/User/Desktop/darter/f5_untar/${NAME} --save_path /mnt/c/Users/User/Desktop/darter/multif5/${NAME} --filename_base batch_output --batch_size 100 --recursive
 #Convert the multireads into pod5 format
echo "::::::::::::::CONVERTING:::::::::::::"
 pod5 convert fast5 /mnt/c/Users/User/Desktop/darter/multif5/${NAME} --output p5/${NAME%.*}.pod5
 