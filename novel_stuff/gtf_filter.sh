#!/bin/bash

# Define colors using set
set YELLOW='\033[1;33m'
set NC='\033[0m' # No Color

NAME=$1

log_message() {
    local MESSAGE="$1"
    local COLOR="$2"
    echo -e "${!COLOR}$MESSAGE${NC}"
}

GFFCOMPARE() {
    local NAME="$1"
    local TOOL="$2"
    local TRANS_LIST="/mnt/d/SGNEX/GTF_files/${TOOL}/novel/${NAME}/${NAME}.trans_list"

    # This will create a pattern like: transcript_id "ENST00000642060.*"|transcript_id "ENST00000373850.*"|...
    grep_pattern=$(awk '{print "transcript_id \""$1".*\""}' "$TRANS_LIST" | tr '\n' '|')
    grep_pattern=${grep_pattern%?}  # Remove the trailing '|'

    grep -E "$grep_pattern" "$GTF_FILE" > "/mnt/d/SGNEX/GTF_files/${TOOL}/novel/${NAME}/${NAME}.filt.gtf"
    bash ~/nano-pipe/novel_stuff/gffcompare.sh "$NAME" "$TOOL"
}

# STRINGTIE
STRING_PATH="/mnt/d/SGNEX/gffcmp/stringtie/novel/${NAME}/${NAME}.annotated.gtf"
if [ ! -f "$STRING_PATH" ]; then
    log_message "Filtering STRINGTIE $NAME..." "YELLOW"
    TOOL="stringtie"
    COUNT_FILE="/mnt/d/SGNEX/GTF_files/stringtie/novel/${NAME}/t_data.ctab"
    GTF_FILE="/mnt/d/SGNEX/GTF_files/stringtie/novel/${NAME}/${NAME}.gtf"
    awk '$11 > 0 {print $6}' "$COUNT_FILE" > "/mnt/d/SGNEX/GTF_files/stringtie/novel/${NAME}/${NAME}.trans_list"
    GFFCOMPARE "$NAME" "$TOOL"
else
    log_message "STRING file ${NAME}.annotated.gtf exists. Skipping..." "YELLOW"
fi

# ISOQUANT
ISOQUANT_PATH="/mnt/d/SGNEX/gffcmp/isoquant/novel/${NAME}/${NAME}.annotated.gtf"
if [ ! -f "$ISOQUANT_PATH" ]; then
    log_message "Filtering isoQUANT $NAME..." "YELLOW"
    TOOL="isoquant"
    COUNT_FILE="/mnt/d/SGNEX/GTF_files/isoquant/novel/${NAME}/${NAME}.transcript_tpm.tsv"
    GTF_FILE="/mnt/d/SGNEX/GTF_files/isoquant/novel/${NAME}/${NAME}.gtf"
    awk '$2 > 0 {print $1}' "$COUNT_FILE" > "/mnt/d/SGNEX/GTF_files/isoquant/novel/${NAME}/${NAME}.trans_list"
    GFFCOMPARE "$NAME" "$TOOL"
else
    log_message "isoQUANT file ${NAME}.annotated.gtf exists. Skipping..." "YELLOW"
fi

# BAMBU
BAMBU_PATH="/mnt/d/SGNEX/gffcmp/bambu/novel/${NAME}/${NAME}.annotated.gtf"
if [ ! -f "$BAMBU_PATH" ]; then
    log_message "Filtering BAMBU $NAME..." "YELLOW"
    TOOL="bambu"
    COUNT_FILE="/mnt/d/SGNEX/GTF_files/bambu/novel/${NAME}/counts_transcript.txt"
    GTF_FILE="/mnt/d/SGNEX/GTF_files/bambu/novel/${NAME}/extended_annotations.gtf"
    awk '$3 > 0 {print $1}' "$COUNT_FILE" > "/mnt/d/SGNEX/GTF_files/bambu/novel/${NAME}/${NAME}.trans_list"
    GFFCOMPARE "$NAME" "$TOOL"
else
    log_message "BAMBU file ${NAME}.annotated.gtf exists. Skipping..." "YELLOW"
fi

# TALON
TALON_PATH="/mnt/d/SGNEX/gffcmp/talon/novel/${NAME}/${NAME}.annotated.gtf"
if [ ! -f "$TALON_PATH" ]; then
    log_message "Filtering TALON $NAME..." "YELLOW"
    TOOL="talon"
    COUNT_FILE="/mnt/d/SGNEX/GTF_files/talon/novel/${NAME}/${NAME}.tsv"
    GTF_FILE="/mnt/d/SGNEX/GTF_files/talon/novel/${NAME}/${NAME}.gtf"
    awk '$12 > 0 {print $4}' "$COUNT_FILE" > "/mnt/d/SGNEX/GTF_files/talon/novel/${NAME}/${NAME}.trans_list"
    GFFCOMPARE "$NAME" "$TOOL"
else
    log_message "TALON output file exists. Skipping TALON..." "YELLOW"
fi

# FLAIR
FLAIR_PATH="/mnt/d/SGNEX/gffcmp/flair/novel/${NAME}/${NAME}.annotated.gtf"
if [ ! -f "$FLAIR_PATH" ]; then
    log_message "Filtering Flair $NAME..." "YELLOW"
    TOOL="flair"
    COUNT_FILE="/mnt/d/SGNEX/GTF_files/flair/novel/${NAME}/${NAME}.annotated_transcripts.alignment.counts"
    GTF_FILE="/mnt/d/SGNEX/GTF_files/flair/novel/${NAME}/${NAME}.gtf"
    awk '$2 > 0 {print $1}' "$COUNT_FILE" | sed 's/_ENSG[0-9]\+\.[0-9]\+//' > "/mnt/d/SGNEX/GTF_files/flair/novel/${NAME}/${NAME}.trans_list"
    GFFCOMPARE "$NAME" "$TOOL"
else
    log_message "Flair output file exists. Skipping Flair..." "YELLOW"
fi
