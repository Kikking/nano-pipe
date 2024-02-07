#!/bin/bash

SIRV_REF=/mnt/d/refData/lrgasp_grch38_sirvs.fasta
SIRV_ANNO=/mnt/d/refData/lrgasp_gencode_v38_sirvs.gtf
TARGET=$1
TOOL=$2 # b = bambu, s = stringtie , i = isoquant

if [[ -z "$TOOL" ]]; then
    echo "Error: Please specify a tool using the 'tool' variable."
    exit 1 
elif [$TOOL == b]; then
    INDIR=bambu
elif [$TOOL == s]; then
    INDIR=stringtie
elif [$TOOL == i]; then
    INDIR=isoquant
fi


python sqanti3_qc.py \
/mnt/d/SGNEX/GTF_files/$INDIR/$TARGET $SIRV_ANNO $SIRV_REF \
-o  $TARGET \
-d /mnt/d/SGNEX/sqantout/$INDIR \
--cpus 10 --report pdf                    

"""

sqanti3_qc.py \
-o ST_SQ_A_r2r1 \
-d mount/sqant_output \ sqanti3_qc.py /mnt/d/SGNEX/String/A_d_r1r3 /mnt/d/refData/lrgasp_gencode_v38_sirvs.gtf /mnt/d/refData/lrgasp_grch38_sirvs.fasta 
--cpus 8 --report pdf

sqanti3_qc.py /mnt/d/SGNEX/M2/bamGTF/A_d_r1r3extended_annotations.gtf /mnt/d/refData/lrgasp_gencode_v38_sirvs.gtf /mnt/d/refData/lrgasp_grch38_sirvs.fasta



Run this in UBUNTU 18
Activate Conda env SQANTI3.env
#ADD this to /.bashrc:
export PYTHONPATH=$PYTHONPATH:~/SQANTI3-5.2/cDNA_Cupcake/sequence/
"""