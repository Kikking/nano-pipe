#!/bin/bash

# Define variables
INDEX="/mnt/e/refData/STAR_index"
READ1="/mnt/d/barbet/trim/SGNex_Hct116_Illumina_replicate4_run1/SGNex_Hct116_Illumina_replicate4_run1_R1_val_1.fq"
READ2="/mnt/d/barbet/trim/SGNex_Hct116_Illumina_replicate4_run1/SGNex_Hct116_Illumina_replicate4_run1_R2_val_2.fq"

# Calculate genomeChrBinNbits value (replace this with a constant integer)
GENOME_CHR_BIN_NBITS=18

# Run STAR with correct parameters
STAR --runMode alignReads \
     --genomeDir "$INDEX" \
     --readFilesIn "$READ1" "$READ2" \
     --runThreadN 6 \
     --genomeLoad LoadAndKeep \
     --genomeChrBinNbits "$GENOME_CHR_BIN_NBITS" \
     --genomeSAindexNbases 10 \
     --genomeSAsparseD 2
