#!/bin/bash

#Create Conda env with python v3.8 and dependencies
conda create -c conda-forge -c bioconda -n isoQ python=3.8 pandas isoquant gffutils biopython pybedtools pyfaidx
conda activate isoQ
conda install -c bioconda pysam
conda install -c bioconda edlib
conda install -c bioconda python-edlib
conda install -c bioconda samtools

