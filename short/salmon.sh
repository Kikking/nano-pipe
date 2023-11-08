#!/bin/bash 

#salmon 1.10.2

#salmon index -t ~/darter/refData/gencode.v44.transcripts.fa.gz -i ~/darter/refData/salindex

for sample in ~/darter/trim/;
do
samp=`basename ${fn}`
echo "Processing sample ${samp}"
salmon quant -i ~/darter/refData/salindex -l A \
         -1 ${fn}/${samp}_R1_val_1.fq.gz \
         -2 ${fn}/${samp}_R2_val_2.fq.gz \
         -p 6 --gcBias -o ~/barbet/quants/${samp}_quant
done