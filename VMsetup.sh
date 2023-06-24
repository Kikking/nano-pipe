#!/bin/bash

#install gcsfuse
export GCSFUSE_REPO=gcsfuse-`lsb_release -c -s`
echo "deb http://packages.cloud.google.com/apt $GCSFUSE_REPO main" | sudo tee /etc/apt/sources.list.d/gcsfuse.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo apt-get update
sudo apt-get install gcsfuse

#create folder for mounting
mkdir mountfolder

#mount your storage bucket:
gcsfuse myBucketName mountfolder #Where myBucketName is the name of the storage bucket you created.

#install MiniConda

#download setup install script
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh

#run setup
bash Miniconda3-latest-Linux-x86_64.sh
conda --version

