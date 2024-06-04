#!/bin/bash
SIRV_REF=/home/kikking/long_realm/ref/GRCh38.p14_chr1S_SIRV.fa
SIRV_ANNO=/home/kikking/long_realm/ref/gencode45_chrIS_SIRV.gtf
TARGET="$1"

# Define tput color codes
RED=$(tput setaf 1)      # Red color for errors
GREEN=$(tput setaf 2)    # Green color for success
PURPLE=$(tput setaf 5)   # Purple color for progress
RESET=$(tput sgr0)       # Reset color

if [ -z "$TARGET" ]; then
    echo "${RED}Error: Please provide a target argument.${RESET}"
    exit 1
fi

mkdir -p "/mnt/e/talon_realm/${TARGET}"

# Function to echo colored messages
print_message() {
    local message="$1"
    local color="$2"
    echo "${color}${message}${RESET}"
}

file_exists() {
    local file="$1"
    [[ -f "$file" ]]
}

# Create SAM file

if ! file_exists "/mnt/e/talon_realm/${TARGET}/${TARGET}.sam"; then
print_message "::: SAMMING... :::::" "$PURPLE"
samtools view -h "/mnt/d/SGNEX/mini_bam/${TARGET}.bam" > "/mnt/e/talon_realm/${TARGET}/${TARGET}.sam"
print_message "::: SAMMING Done :::::" "$GREEN"
fi
# Create CSV Config File
print_message "::: Creating CSV Config File... :::::" "$PURPLE"
echo "${TARGET},single_run,ONT,/mnt/e/talon_realm/${TARGET}/${TARGET}_labeled.sam" > "/mnt/e/talon_realm/${TARGET}/${TARGET}.csv"
print_message "::: Created ${TARGET}.csv :::::" "$GREEN"

# Label reads
print_message "::: LABELLING... :::::" "$PURPLE"
talon_label_reads \
  --f "/mnt/e/talon_realm/${TARGET}/${TARGET}.sam" \
  --g "$SIRV_REF" \
  --t 10 \
  --o "/mnt/e/talon_realm/${TARGET}/${TARGET}"
print_message "::: LABELLING Done :::::" "$GREEN"

# Initialize database
if ! file_exists "/mnt/e/talon_realm/${TARGET}/${TARGET}.db"; then 
print_message "::: INITIALISING DATABASE... :::::" "$PURPLE"
talon_initialize_database \
  --f "$SIRV_ANNO" \
  --g grch38 \
  --a SIRV_annotation \
  --o "/mnt/e/talon_realm/${TARGET}/${TARGET}" > /dev/null
print_message "::: DATABASE Initialised :::::" "$GREEN"
fi

# Identify isoforms
if ! file_exists "/mnt/e/talon_realm/${TARGET}/${TARGET}_talon_read_annot.tsv"; then 
print_message "::: IDENTIFYING ISOFORMS... :::::" "$PURPLE"
talon \
  --f "/mnt/e/talon_realm/${TARGET}/${TARGET}.csv" \
  --db "/mnt/e/talon_realm/${TARGET}/${TARGET}.db" \
  --build grch38 \
  --threads 10 \
  --o "/mnt/e/talon_realm/${TARGET}/${TARGET}" > /dev/null
print_message "::: ISOFORMS Identified :::::" "$GREEN"
fi

# Filter transcripts
print_message "::: FILTERING... :::::" "$PURPLE"
talon_filter_transcripts \
  --db "/mnt/e/talon_realm/${TARGET}/${TARGET}.db" \
  -a SIRV_annotation \
  --o "/mnt/e/talon_realm/${TARGET}/snowwhitelist"
print_message "::: FILTERING Done :::::" "$GREEN"

# Quantify abundance
if ! file_exists "/mnt/e/talon_realm/${TARGET}/${TARGET}_talon_abundance_filtered.tsv"; then 
print_message "::: QUANTIFYING... :::::" "$PURPLE"
talon_abundance \
  --db "/mnt/e/talon_realm/${TARGET}/${TARGET}.db" \
  -a SIRV_annotation \
  --whitelist "/mnt/e/talon_realm/${TARGET}/snowwhitelist" \
  -b grch38 \
  --o "/mnt/e/talon_realm/${TARGET}/${TARGET}"
print_message "::: QUANTIFICATION Done :::::" "$GREEN"
fi

# Create GTF
if ! file_exists "/mnt/e/talon_realm/${TARGET}/${TARGET}_talon_observedOnly.gtf"; then 
print_message "::: GTFing... :::::" "$PURPLE"
talon_create_GTF \
  --db "/mnt/e/talon_realm/${TARGET}/${TARGET}.db" \
  -b grch38 \
  -a SIRV_annotation \
  --whitelist "/mnt/e/talon_realm/${TARGET}/snowwhitelist" \
  --observed \
  --o "/mnt/e/talon_realm/${TARGET}/${TARGET}"
print_message "::: GTF Creation Done :::::" "$GREEN"
fi

# Move .gtf and .esp files to destination directory
mkdir -p /mnt/d/SGNEX/GTF_files/talon/${TARGET}
print_message "::: MOVING .gtf and abundance_filtered.tsv Files... :::::" "$PURPLE"
find "/mnt/e/talon_realm/${TARGET}/" -name "*.gtf" -exec mv {} "/mnt/d/SGNEX/GTF_files/talon/${TARGET}/${TARGET}.gtf" \;
find "/mnt/e/talon_realm/${TARGET}/" -name "*abundance_filtered.tsv" -exec mv {} "/mnt/d/SGNEX/GTF_files/talon/${TARGET}/${TARGET}.tsv" \;
print_message "::: Files Moved :::::" "$GREEN"

