#!/usr/bin/env bash

TARGET=$1
NAME=$2
#PLEX=${2-plex1} #plex1 or plex2
#This takes .tar.gz files and extracts them into fast5 files

#for FILE in $TARGET/*; #tar106_data
echo "******************************************************************"
echo $FILE;
echo "******************************************************************"
time tar -xvf $FILE -C /mnt/c/Users/User/Desktop/darter/f5_untar/${NAME}; 
echo "<<<<<<<<<<<<<<<<<<<DONE>>>>>>>>>>>>>>>>>>>>>>>>"
#find f5_untar/${PLEX} -type f -iname  *"SGNEX"* -exec cp {} f5/${PLEX} \;


#find f5_untar/plex2 -type f -iname  *"SGNEX"* -exec cp {} f5/plex2 \;
