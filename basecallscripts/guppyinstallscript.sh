#!/bin/bash
sudo apt update;
sudo apt install wget lsb-release;
export PLATFORM=$(lsb_release -cs);
wget -O- https://cdn.oxfordnanoportal.com/apt/ont-repo.pub | sudo apt-key add -;
echo "deb http://cdn.oxfordnanoportal.com/apt ${PLATFORM}-stable non-free" | sudo tee /etc/apt/sources.list.d/nanoporetech.sources.list;
sudo apt update;
sudo apt install ont-guppy-cpu;