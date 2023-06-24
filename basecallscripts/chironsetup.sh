#!/bin/bash

#install Miniconda

#create virtual env that supports tensorflow 1.15.0
conda create -n tf15 python tensorflow=1.15
conda activate tf15

#install chiron
git clone https://github.com/haotianteng/chiron.git
cd chiron
python setup.py install
pip install statsmodels
export PYTHONPATH=chiron/chiron:$PYTHONPATH

#Run Chiron
python chiron/chiron/entry.py call -i mount/gcp/nano_untar/mnt/projectsInstanceStore1/chenying/ena_upload/fast5/SGNex_A549_directcDNA_replicate2_run1 -o mount/chiron_fastq -m chiron/model/DNA_default -p dna-pre