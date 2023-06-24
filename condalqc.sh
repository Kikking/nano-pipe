#!/bin/bash

#Create Conda env with python v3.7 and dependencies
conda create -n lqc -y python=3.7 numpy scipy matplotlib scikit-learn pandas jinja2 h5py
conda activate lqc
conda install -c bioconda pysam
conda install -c bioconda edlib
conda install -c bioconda python-edlib

#Download LongQC tool
git clone https://github.com/yfukasawa/LongQC.git
cd LongQC/minimap2-coverage
sudo apt-get install libz-dev #Required to make the minimap2-coverage file, not included in source code
make

#Run analysis code within LongQC directory