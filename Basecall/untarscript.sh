#!/usr/bin/env bash

TARGET=$1
PLEX=${2-plex1} #plex1 or plex2
#This takes .tar.gz files and extracts them into fast5 files

for FILE in $TARGET/*; #tar106_data
do 
echo "******************************************************************"
echo $FILE;
echo "******************************************************************"
tar -xvf $FILE -C f5_untar/${PLEX}; 
echo "<<<<<<<<<<<<<<<<<<<FINDING>>>>>>>>>>>>>>>>>>>>>>>>"
find f5_untar -type f -iname  *"SGNEX"* -exec cp {} f5/${PLEX} \;
done 


