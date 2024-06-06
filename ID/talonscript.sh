#!/bin/bash
SIRV_REF=/home/kikking/long_realm/ref/GRCh38.p14_chr1S_SIRV.fa
SIRV_ANNO=/home/kikking/long_realm/ref/gencode45_chrIS_SIRV.gtf
NAME="$1"
NOVEL=${2-f}

if [ $NOVEL == "novel" ];then
echo "________NOVEL BEGIN___________"

stripped="${NAME#sd}"
TAG="${stripped%%_*}"
ANNO="/home/kikking/novel_realm/novel/NOVEL_${TAG}_gencode45_chrIS_SIRV.gtf"
OUT=talon/novel

else 
echo "________NORMAL BEGIN___________"
ANNO=$SIRV_ANNO
OUT=talon
fi

# Define tput color codes
RED=$(tput setaf 1)      # Red color for errors
GREEN=$(tput setaf 2)    # Green color for success
PURPLE=$(tput setaf 5)   # Purple color for progress
RESET=$(tput sgr0)       # Reset color

if [ -z "$NAME" ]; then
    echo "${RED}Error: Please provide a NAME argument.${RESET}"
    exit 1
fi

mkdir -p "/mnt/e/talon_realm/${NAME}"

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

if ! file_exists "/mnt/e/talon_realm/${NAME}/${NAME}.sam"; then
print_message "::: SAMMING... :::::" "$PURPLE"
samtools view -h "/mnt/d/SGNEX/mini_bam/${NAME}.bam" > "/mnt/e/talon_realm/${NAME}/${NAME}.sam"
print_message "::: SAMMING Done :::::" "$GREEN"
fi
# Create CSV Config File
print_message "::: Creating CSV Config File... :::::" "$PURPLE"
echo "${NAME},single_run,ONT,/mnt/e/talon_realm/${NAME}/${NAME}_labeled.sam" > "/mnt/e/talon_realm/${NAME}/${NAME}.csv"
print_message "::: Created ${NAME}.csv :::::" "$GREEN"

# Label reads
print_message "::: LABELLING... :::::" "$PURPLE"
talon_label_reads \
  --f "/mnt/e/talon_realm/${NAME}/${NAME}.sam" \
  --g "$SIRV_REF" \
  --t 10 \
  --o "/mnt/e/talon_realm/${NAME}/${NAME}"
print_message "::: LABELLING Done :::::" "$GREEN"

# Initialize database
if ! file_exists "/mnt/e/talon_realm/${NAME}/${NAME}.db"; then 
print_message "::: INITIALISING DATABASE... :::::" "$PURPLE"
talon_initialize_database \
  --f "$ANNO" \
  --g grch38 \
  --a SIRV_annotation \
  --o "/mnt/e/talon_realm/${NAME}/${NAME}" > /dev/null
print_message "::: DATABASE Initialised :::::" "$GREEN"
fi

# Identify isoforms
if ! file_exists "/mnt/e/talon_realm/${NAME}/${NAME}_talon_read_annot.tsv"; then 
print_message "::: IDENTIFYING ISOFORMS... :::::" "$PURPLE"
talon \
  --f "/mnt/e/talon_realm/${NAME}/${NAME}.csv" \
  --db "/mnt/e/talon_realm/${NAME}/${NAME}.db" \
  --build grch38 \
  --threads 10 \
  --o "/mnt/e/talon_realm/${NAME}/${NAME}" > /dev/null
print_message "::: ISOFORMS Identified :::::" "$GREEN"
fi

# Filter transcripts
print_message "::: FILTERING... :::::" "$PURPLE"
talon_filter_transcripts \
  --db "/mnt/e/talon_realm/${NAME}/${NAME}.db" \
  -a SIRV_annotation \
  --o "/mnt/e/talon_realm/${NAME}/snowwhitelist"
print_message "::: FILTERING Done :::::" "$GREEN"

# Quantify abundance
if ! file_exists "/mnt/e/talon_realm/${NAME}/${NAME}_talon_abundance_filtered.tsv"; then 
print_message "::: QUANTIFYING... :::::" "$PURPLE"
talon_abundance \
  --db "/mnt/e/talon_realm/${NAME}/${NAME}.db" \
  -a SIRV_annotation \
  --whitelist "/mnt/e/talon_realm/${NAME}/snowwhitelist" \
  -b grch38 \
  --o "/mnt/e/talon_realm/${NAME}/${NAME}"
print_message "::: QUANTIFICATION Done :::::" "$GREEN"
fi

# Create GTF
if ! file_exists "/mnt/e/talon_realm/${NAME}/${NAME}_talon_observedOnly.gtf"; then 
print_message "::: GTFing... :::::" "$PURPLE"
talon_create_GTF \
  --db "/mnt/e/talon_realm/${NAME}/${NAME}.db" \
  -b grch38 \
  -a SIRV_annotation \
  --whitelist "/mnt/e/talon_realm/${NAME}/snowwhitelist" \
  --observed \
  --o "/mnt/e/talon_realm/${NAME}/${NAME}"
print_message "::: GTF Creation Done :::::" "$GREEN"
fi

# Move .gtf and .esp files to destination directory
mkdir -p /mnt/d/SGNEX/GTF_files/talon/${NAME}
print_message "::: MOVING .gtf and abundance_filtered.tsv Files... :::::" "$PURPLE"
find "/mnt/e/talon_realm/${NAME}/" -name "*.gtf" -exec mv {} "/mnt/d/SGNEX/GTF_files/${OUT}/${NAME}/${NAME}.gtf" \;
find "/mnt/e/talon_realm/${NAME}/" -name "*abundance_filtered.tsv" -exec mv {} "/mnt/d/SGNEX/GTF_files/${OUT}/${NAME}/${NAME}.tsv" \;
print_message "::: Files Moved :::::" "$GREEN"

