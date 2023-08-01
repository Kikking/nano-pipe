#!/bin/bash
SIRV_REF=$HOME/mount/ref_data/lrgasp_grch38_sirvs.fasta
SIRV_ANNO=$HOME/mount/ref_data/lrgasp_gencode_v38_sirvs.gtf
TARGET=$1

python sqanti3_qc.py $TARGET $SIRV_ANNO $SIRV_REF \
-o ST_SQ_A_r2r1 \
-d mount/sqant_output \
--cpus 4 --report both                     
