#!/bin/bash

# Define colors
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
BLUE=$(tput setaf 4)
RESET=$(tput sgr0)

# Initialize variables
TAG="sd4"
LENGTHSD=2000
SAMPLE_FILE="~/pbsim3-3.0.4/sample/sample_1001.transcripts"
INPUT_FILE=$1

run_pbsim() {
    local sample_file="$1"
    local id="$2"

    # Retry parameters
    local max_retries=3
    local retry=0

    while [ "$retry" -lt "$max_retries" ]; do
        if pbsim --strategy trans --method errhmm \
            --errhmm ~/pbsim3-3.0.4/data/ERRHMM-ONT.model \
            --transcript "${SAMPLE_FILE}_${COUNT}" \
            --prefix "/mnt/d/SGNEX/fq/${TAG}_${COUNT}_${LENGTH}-${LENGTHSD}_${ACCURACY}"  \
            --length-mean $LENGTH \
            --length-min $(($LENGTH-100)) \
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

while read -r COUNT LENGTH ACCURACY _; do
        #Multiply count values by set count value
        awk -v count="$COUNT" 'BEGIN {OFS="\t"} {$2=($2*count)}1' ${SAMPLE_FILE} > ${SAMPLE_FILE}_"$COUNT"

        # Run pbsim command with retry logic
        if ! run_pbsim ${SAMPLE_FILE} ; then
            echo "${RED}Error: PBSIM command failed for $SAMPLE_FILE${RESET}"
            exit 1
        fi
    done

    # Print key
    echo "${TAG}_${COUNT}_${LENGTH}-${LENGTHSD}_${ACCURACY}" >> ~/SIM_KEYS.txt
    echo "${BLUE}Key: ${TAG}_${COUNT}_${LENGTH}-${LENGTHSD}_${ACCURACY}${RESET}"

done < "$INPUT_FILE"