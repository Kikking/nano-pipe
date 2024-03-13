#!/bin/bash

#SIRV_REF=/mnt/e/refData/hg38_sequins_SIRV_ERCCs_longSIRVs.fa 
#SIRV_ANNO=/mnt/e/refData/filtered_fin.db
SIRV_ANNO=/mnt/e/refData/lrgasp_gencode_v38_sirvs.db
SIRV_REF=/mnt/e/refData/lrgasp_grch38_sirvs.fasta

NAME=$1
echo "indexing..."
time samtools index /mnt/d/SGNEX/mini_bam/${NAME}.bam 
echo "quanting..."
time isoquant.py --force --reference $SIRV_REF --prefix $NAME --genedb $SIRV_ANNO --complete_genedb --clean_start -t 8 --high_memory --bam  /mnt/d/SGNEX/mini_bam/${NAME}.bam --data_type nanopore -o /mnt/d/SGNEX/GTF_files/isoquant/
echo "renaming..." 
time mv /mnt/d/SGNEX/GTF_files/isoquant/${NAME}/${NAME}.extended_annotation.gtf /mnt/d/SGNEX/GTF_files/isoquant/${NAME}/${NAME}.gtf 



#cat test.gtf | awk '$3!="gene" && $3!="transcript"{print}' > filteredtest.gtf

#awk 'BEGIN {counter = 0} $3=="exon" {gsub(/"|;/,"",$14);gsub(/"|;/,"",$12);$14="\""$12"-"$14"\";";$12="\""$12"\";"}1' test.gtf > mod.gtf