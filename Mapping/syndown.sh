#!/bin/bash

$HOME/miniconda3/envs/isoQ/bin/pip install synapseclient

synapse login "kikking" "SincosTan300615!"
synapse -h


#Files fond at:
#https://lrgasp.github.io/lrgasp-submissions/docs/reference-genomes.html
cd mount2
cd ref_data
synapse get syn25683364 #lrgasp_grch38_sirvs.fasta.gz
synapse get syn25683628 #lrgasp_gencode_v38_sirvs.gtf.gz