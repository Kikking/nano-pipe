#!/bin/bash 

INDEX=
READ1=/mnt/d/barbet/trim/SGNex_Hct116_Illumina_replicate3_run1/SGNex_Hct116_Illumina_replicate3_run1_R1_val_1.fq.gz
READ2=/mnt/d/barbet/trim/SGNex_Hct116_Illumina_replicate3_run1/SGNex_Hct116_Illumina_replicate3_run1_R2_val_2.fq.gz

STAR  alignReads --genomeDir $INDEX  \
 --readFilesIn $READ1 $READ2 \
 --runThreadN 6 \
 --genomeLoad LoadAndKeep \
 --genomeChrBinNbits min(18, log2[max(GenomeLength/NumberOfReferences,ReadLength)]) \
 --genomeSAindexNbases 10 \
 --genomeSAsparseD 2  