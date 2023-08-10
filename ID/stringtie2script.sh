#!/bin/bash

SIRV_REF=$HOME/mount2/ref_data/lrgasp_grch38_sirvs.fasta.gz
SIRV_ANNO=$HOME/mount/ref_data/lrgasp_gencode_v38_sirvs.gtf.gz

stringtie -G $HOME/mount/ref_data/lrgasp_gencode_v38_sirvs.gtf.gz -o ST2_sorted_A_d_r2r1 -L true -p 4 ~/mount/minidata_sam/sorted_A_d_r2r1.bam 