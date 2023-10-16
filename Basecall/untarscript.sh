#!/usr/bin/env bash

TARGET=$1
#This takes .tar.gz files and extracts them into fast5 files

for FILE in $TARGET/*; #tar106_data
do 
echo $FILE;
tar -xvf $FILE -C f5_untar; 
find f5_untar -type f -iname  *"SGNEX"* -exec cp {} f5/ \;
done 


