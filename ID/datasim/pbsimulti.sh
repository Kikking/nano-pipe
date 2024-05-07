#!/bin/bash

# Define colors
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
BLUE=$(tput setaf 4)
RESET=$(tput sgr0)

# Initialize variables
LENGTHSD=7000
SAMPLE_DIR="sample_1001.transcripts_dir"
INPUT_FILE=$1

# Function to run pbsim command with retry logic
run_pbsim() {
    local sample_file="$1"
    local id="$2"

    # Retry parameters
    local max_retries=3
    local retry=0

    while [ "$retry" -lt "$max_retries" ]; do
        if pbsim --strategy trans --method errhmm \
            --errhmm ~/pbsim3-3.0.4/data/ERRHMM-ONT.model \
            --transcript "${sample_file}_${COUNT}" \
            --prefix "/mnt/e/pbsimulti/sd3_${COUNT}_${LENGTH}-${LENGTHSD}_${ACCURACY}_${id}"  \
            --length-min $LENGTH \
            --length-max $(($LENGTH+100)) \
            --accuracy-mean $ACCURACY 

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
while read -r COUNT LENGTH ACCURACY _; do
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
    find /mnt/e/pbsimulti/ -type f -name "*.fastq" -exec cat {} + > /mnt/d/SGNEX/fq/sd3_${COUNT}_${LENGTH}-${LENGTHSD}_${ACCURACY}.fastq

    # Clean up temporary directory
    echo "${BLUE}:::: Cleaning ::::${RESET}"
    rm /mnt/e/pbsimulti/*

    # Print key
    echo "sd3_${COUNT}_${LENGTH}-${LENGTHSD}_${ACCURACY}" >> ~/SIM_KEYS.txt
    echo "${GREEN}Key: sd3_${COUNT}_${LENGTH}-${LENGTHSD}_${ACCURACY}${RESET}"

done < "$INPUT_FILE"