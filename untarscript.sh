#!/usr/bin/env bash

#This takes .tar.gz files and extracts them into fast5 files

for i in tar106_data/*; #tar106_data
do 
echo $i;
tar -xvf $i -C nano_untar; #nano_untar

done 

tar -xvf tar106_data/SGNex_MCF7_directcDNA_replicate1_run2.tar.gz -C nano_untar

gsutil cp -r /mnt/d/gcp/tar106d_data gs://nano_bucket