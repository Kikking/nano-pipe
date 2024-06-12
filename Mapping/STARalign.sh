#!/bin/bash
NAME=$1 

# Define variables
INDEX="/mnt/e/refData/STAR_index"
READ1="/mnt/d/barbet/trim/${NAME}/${NAME}_R1_val_1.fq.gz"
READ2="/mnt/d/barbet/trim/${NAME}/${NAME}_R2_val_2.fq.gz"

# Calculate genomeChrBinNbits value (replace this with a constant integer)
GENOME_CHR_BIN_NBITS=18

# Run STAR with correct parameters
STAR --runMode alignReads \
     --genomeDir "$INDEX" \
     --readFilesIn "$READ1" "$READ2" \
     --runThreadN 8 \
     --genomeChrBinNbits "$GENOME_CHR_BIN_NBITS" \
     --genomeSAindexNbases 10 \
     --genomeSAsparseD 2 \
     --outSAMtype BAM SortedByCoordinate \
     --outFileNamePrefix /mnt/e/star_stuff/${NAME}/${NAME}_

      # --genomeLoad LoadAndRemove \
