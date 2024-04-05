#!/bin/bash

# Define colors
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
BLUE=$(tput setaf 4)
RESET=$(tput sgr0)

# Initialize variables
COUNT=10
LENGTH=9000
LENGTHSD=2000
ACCURACY=0.85
ID=0

# Parse command-line arguments
while getopts "L:A:C:S:ID:" flag; do
    case "${flag}" in
        L) LENGTH=${OPTARG} ;;
        A) ACCURACY=${OPTARG} ;;
        C) COUNT=${OPTARG} ;;
        S) SAMPLE_DIR=${OPTARG} ;;
        ID) ID=${OPTARG} ;;
    esac
done

# Function to run pbsim command with retry logic
run_pbsim() {
    local sample_file="$1"
    local id="$2"

    # Retry parameters
    local max_retries=3
    local retry=0

    while [ "$retry" -lt "$max_retries" ]; do
        if pbsim --strategy trans --method errhmm \
            --errhmm ~/pbsim3-3.0.4/data/ERRHMM-RSII.model \
            --transcript "${sample_file}_${COUNT}" \
            --prefix "/mnt/e/pbsimulti/sd_${COUNT}_${LENGTH}-${LENGTHSD}_${ACCURACY}_${id}"  \
            --length-mean "$LENGTH" \
            --length-sd "$LENGTHSD" \
            --accuracy-mean "$ACCURACY"
        then
            echo "${GREEN}PBSIM command successful${RESET}"
            return 0
        else
            echo "${RED}PBSIM command failed with segmentation fault${RESET}"
            echo "${BLUE}Retrying...${RESET}"
            ((retry++))
        fi
    done

    echo "${RED}PBSIM command failed after $max_retries retries${RESET}"
    return 1
}

# Main loop to process sample files
for SAMPLE_FILE in ~/pbsim3-3.0.4/sample/"$SAMPLE_DIR"/*; do
    ID=$((ID+1))

    #Multiply count values by set count value
    awk -v count="$COUNT" 'BEGIN {OFS="\t"} {$2=($2*count);$3=($3*count)}1' ${SAMPLE_FILE} > ${SAMPLE_FILE}_"$COUNT"

    # Run pbsim command with retry logic
    if ! run_pbsim ${SAMPLE_FILE} "${ID}"; then
        echo "${RED}Error: PBSIM command failed for $SAMPLE_FILE${RESET}"
        exit 1
    fi

    # Clean up temporary files
    echo "${BLUE}Removing ${SAMPLE_FILE}_${COUNT}${RESET}"
    rm "${SAMPLE_FILE}_${COUNT}"
done

# Merge fastq files
echo "${BLUE}:::: Merging ::::${RESET}"
find /mnt/e/pbsimulti/ -type f -name "*.fastq" -exec cat {} + > /mnt/d/SGNEX/fq/sd_${COUNT}_${LENGTH}-${LENGTHSD}_${ACCURACY}_M.fastq

# Clean up temporary directory
echo "${BLUE}:::: Cleaning ::::${RESET}"
rm /mnt/e/pbsimulti/*

# Print key
echo "${GREEN}Key: sd_${COUNT}_${LENGTH}-${LENGTHSD}_${ACCURACY}_M${RESET}"
