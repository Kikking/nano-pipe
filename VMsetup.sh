#!/bin/bash

sudo apt install build-essential

#env variables
alias autopull="bash ~/nano-pipe/autopull.sh"

#install gcsfuse
export GCSFUSE_REPO=gcsfuse-`lsb_release -c -s`
echo "deb http://packages.cloud.google.com/apt $GCSFUSE_REPO main" | sudo tee /etc/apt/sources.list.d/gcsfuse.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo apt-get update
sudo apt-get install gcsfuse

#create folder for mounting
mkdir mount

#mount your storage bucket:
gcsfuse tiny_little_one mount #Where myBucketName is the name of the storage bucket you created.

#install MiniConda

#download setup install script
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh

#run setup
bash Miniconda3-latest-Linux-x86_64.sh 
source .bashrc
conda --version



#get MiniMap2 Setup
 sudo apt-get install libz-dev
 git clone https://github.com/lh3/minimap2
 cd minimap2 
 sudo make


./stringtie  ~/mount/minidata_sam/sorted_A_d_r2r1.bam -G $HOME/mount/ref_data/lrgasp_gencode_v38_sirvs.gtf.gz -o ST2 -L -p 4 
