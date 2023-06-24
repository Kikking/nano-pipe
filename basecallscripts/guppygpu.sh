#!/bin/bash

#Add Oxford Nanopore's deb repository to your system (this is to install Oxford Nanopore Technologies-specific dependency packages):
sudo apt update
sudo apt install wget lsb-release
export PLATFORM=$(lsb_release -cs)
wget -O- https://cdn.oxfordnanoportal.com/apt/ont-repo.pub | sudo apt-key add -
echo "deb http://cdn.oxfordnanoportal.com/apt ${PLATFORM}-stable non-free" | sudo tee /etc/apt/sources.list.d/nanoporetech.sources.list
sudo apt update

 #To install the .deb for Guppy, use the following command:
sudo apt update
sudo apt install ont-guppy