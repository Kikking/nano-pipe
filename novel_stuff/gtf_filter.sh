#!/bin/bash

NAME=$1

# Define text formatting variables
RED=$(tput setaf 1)       # Red text for error messages
YELLOW=$(tput setaf 3)    # Yellow text for warning messages
GREEN=$(tput setaf 2)     # Green text for success messages
RESET=$(tput sgr0)        # Reset text formatting

# Function for logging messages with color
log_message() {
    local message="$1"
    local color="$2"
    echo -e "${color}${message}${RESET}"
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
STRING_PATH="/mnt/d/SGNEX/GTF_files/stringtie/novel/${NAME}/${NAME}.filt.gtf"
if [ ! -f "$STRING_PATH" ]; then
    log_message "Filtering STRINGTIE $NAME..." "YELLOW"
    TOOL="stringtie"
    COUNT_FILE="/mnt/d/SGNEX/GTF_files/stringtie/novel/${NAME}/t_data.ctab"
    GTF_FILE="/mnt/d/SGNEX/GTF_files/stringtie/novel/${NAME}/${NAME}.gtf"
    awk '$11 > 0 {print $6}' "$COUNT_FILE" > "/mnt/d/SGNEX/GTF_files/stringtie/novel/${NAME}/${NAME}.trans_list"
    GFFCOMPARE "$NAME" "$TOOL"
else
    log_message "STRING file ${NAME}.filt.gtf exists. Skipping..." "YELLOW"
fi

# ISOQUANT
ISOQUANT_PATH="/mnt/d/SGNEX/GTF_files/isoquant/novel/${NAME}/${NAME}.filt.gtf"
if [ ! -f "$ISOQUANT_PATH" ]; then
    log_message "Filtering isoQUANT $NAME..." "YELLOW"
    TOOL="isoquant"
    COUNT_FILE="/mnt/d/SGNEX/GTF_files/isoquant/novel/${NAME}/${NAME}.transcript_tpm.tsv"
    GTF_FILE="/mnt/d/SGNEX/GTF_files/isoquant/novel/${NAME}/${NAME}.gtf"
    awk '$2 > 0 {print $1}' "$COUNT_FILE" > "/mnt/d/SGNEX/GTF_files/isoquant/novel/${NAME}/${NAME}.trans_list"
    GFFCOMPARE "$NAME" "$TOOL"
else
    log_message "isoQUANT file ${NAME}.filt.gtf exists. Skipping..." "YELLOW"
fi

# BAMBU
BAMBU_PATH="/mnt/d/SGNEX/GTF_files/bambu/novel/${NAME}/extended_annotations.filt.gtf"
if [ ! -f "$BAMBU_PATH" ]; then
    log_message "Filtering BAMBU $NAME..." "YELLOW"
    TOOL="bambu"
    COUNT_FILE="/mnt/d/SGNEX/GTF_files/bambu/novel/${NAME}/counts_transcript.txt"
    GTF_FILE="/mnt/d/SGNEX/GTF_files/bambu/novel/${NAME}/extended_annotations.gtf"
    awk '$3 > 0 {print $1}' "$COUNT_FILE" > "/mnt/d/SGNEX/GTF_files/bambu/novel/${NAME}/${NAME}.trans_list"
    GFFCOMPARE "$NAME" "$TOOL"
else
    log_message "BAMBU file ${NAME}.filt.gtf exists. Skipping..." "YELLOW"
fi

# TALON
TALON_PATH="/mnt/d/SGNEX/GTF_files/talon/novel/${NAME}/${NAME}.filt.gtf"
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
FLAIR_PATH="/mnt/d/SGNEX/GTF_files/flair/novel/${NAME}/${NAME}.filt.gtf"
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
