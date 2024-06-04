#!/bin/bash

SIRV_REF=/home/kikking/long_realm/ref/GRCh38.p14_chr1S_SIRV.fa
SIRV_ANNO=/home/kikking/long_realm/ref/gencode45_chrIS_SIRV.gtf

# Define color codes
RED=$(tput setaf 1)    # Red color for errors
GREEN=$(tput setaf 2)  # Green color for success
PURPLE=$(tput setaf 5) # Purple color for progress
RESET=$(tput sgr0)     # Reset color

TARGET="$1"
CLEAN="${2:-"clean"}"

# Function to echo colored messages
print_message() {
    local message="$1"
    local color="$2"
    echo "${color}${message}${RESET}"
}

# Generate TSV file
col1="/mnt/d/SGNEX/mini_bam/${TARGET}.bam"
col2="$TARGET"
echo -e "$col1\t$col2" > "/mnt/e/espresso_realm/${TARGET}.tsv"
print_message "::: Created ${TARGET}.tsv :::::" "$GREEN"

# Preprocessing
print_message "::: PREPROCESSING... :::::" "$PURPLE"
~/perl-5.38.2/perl ~/espresso/src/ESPRESSO_S.pl -L "/mnt/e/espresso_realm/${TARGET}.tsv" -F "$SIRV_REF" -A "$SIRV_ANNO" -O "/mnt/e/espresso_realm/${TARGET}"
print_message "::: PREPROCESSING Done :::::" "$GREEN"

# Correcting
print_message "::: CORRECTING... :::::" "$PURPLE"
~/perl-5.38.2/perl ~/espresso/src/ESPRESSO_C.pl -I "/mnt/e/espresso_realm/${TARGET}" -F "$SIRV_REF" -X 0
print_message "::: CORRECTING Done :::::" "$GREEN"

# Quantifying
print_message "::: QUANTIFYING... :::::" "$PURPLE"
~/perl-5.38.2/perl ~/espresso/src/ESPRESSO_Q.pl -A "$SIRV_ANNO" -L "/mnt/e/espresso_realm/${TARGET}/${TARGET}.tsv.updated"
print_message "::: QUANTIFYING Done :::::" "$GREEN"

# Move .gtf and .esp files to destination directory
mkdir -p /mnt/d/SGNEX/GTF_files/espresso/${TARGET}
print_message "::: MOVING .gtf and .esp Files... :::::" "$PURPLE"
find "/mnt/e/espresso_realm/${TARGET}/" -name "*.gtf" -exec mv {} "/mnt/d/SGNEX/GTF_files/espresso/${TARGET}/${TARGET}.gtf" \;
find "/mnt/e/espresso_realm/${TARGET}/" -name "*.esp" -exec mv {} "/mnt/d/SGNEX/GTF_files/espresso/${TARGET}/${TARGET}.esp" \;
print_message "::: Files Moved :::::" "$GREEN"

# Clean up based on CLEAN option
case "$CLEAN" in
    force)
        print_message "Removing /mnt/e/espresso_realm/${TARGET}" "$PURPLE"
        rm -r "/mnt/e/espresso_realm/${TARGET}"
        print_message "Cleanup Completed" "$GREEN"
        ;;
    clean)
        if [ -e "/mnt/d/SGNEX/GTF_files/espresso/${TARGET}/${TARGET}.gtf" ]; then
            print_message "Removing /mnt/e/espresso_realm/${TARGET}" "$PURPLE"
            rm -r "/mnt/e/espresso_realm/${TARGET}"
            print_message "Cleanup Completed" "$GREEN"
        else
            print_message "${RED}File /mnt/d/SGNEX/GTF_files/espresso/${TARGET}/${TARGET}.gtf does not exist. Keeping /mnt/e/espresso_realm/${TARGET}" "$RED"
        fi
        ;;
    keep)
        print_message "################ KEPT TMP FILES ##########################" "$PURPLE"
        ;;
    *)
        print_message "Error: Invalid clean option '$CLEAN'." "$RED"
        exit 1
        ;;
esac
