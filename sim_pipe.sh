#!/bin/bash

ID_LOG="ALL_ID.log"
MAP_LOG="MAPPING.log"

COUNT=10
LENGTH=9000
LENGTHSD=2000
ACCURACY=0.85

# Define Conda environments for each tool
ENV_FLAIR="flair"
ENV_TALON="talon"
ENV_ESPRESSO="ESPRESSO"
ENV_ISOQUANT="isoquant"

# Function to activate Conda environment
activate_env() {
    local env_name="$1"
    source activate "$env_name"
}

# Function to log messages with color
log_message() {
    local message="$1"
    local color="$2"
    echo -e "${color}${message}$(tput sgr0)"
}

# Function to perform ID tasks
ALL_ID() {
    local NAME="sd_${COUNT}_${LENGTH}-${LENGTHSD}_${ACCURACY}"
    local BAM_FILE="/mnt/d/SGNEX/mini_bam/${NAME}.bam"

    if [ -f "$BAM_FILE" ]; then
        log_message "File ${NAME}.bam exists. Proceeding..." "$(tput setaf 2)"

        # STRINGTIE
        STRING_PATH="/mnt/d/SGNEX/GTF_files/stringtie/${NAME}/${NAME}.gtf"
        if [ ! -f "$STRING_PATH" ]; then
            log_message "Running STRINGTIE for $NAME..." "$(tput setaf 3)"
            time bash ~/nano-pipe/ID/string.sh "$NAME"
            bash ~/nano-pipe/template.sh "$NAME" STRINGTIE
        else
            log_message "STRING file ${NAME}.gtf exists. Skipping..." "$(tput setaf 3)"
        fi

        # ISOQUANT
        ISOQUANT_PATH="/mnt/d/SGNEX/GTF_files/isoquant/${NAME}/${NAME}.gtf"
        if [ ! -f "$ISOQUANT_PATH" ]; then
            log_message "Running isoQUANT for $NAME..." "$(tput setaf 3)"
            activate_env "$ENV_ISOQUANT"
            time bash ~/nano-pipe/ID/isoqscript.sh "$NAME"
            bash ~/nano-pipe/template.sh "$NAME" ISOQUANT
        else
            log_message "isoQUANT file ${NAME}.gtf exists. Skipping..." "$(tput setaf 3)"
        fi

        # BAMBU
        BAMBU_PATH="/mnt/d/SGNEX/GTF_files/bambu/${NAME}/extended_annotations.gtf"
        if [ ! -f "$BAMBU_PATH" ]; then
            log_message "Running BAMBU for $NAME..." "$(tput setaf 3)"
            time Rscript ~/nano-pipe/ID/bambush.R "$NAME"
            bash ~/nano-pipe/template.sh "$NAME" BAMBU
        else
            log_message "BAMBU file ${NAME} exists. Skipping..." "$(tput setaf 3)"
        fi

        # TALON
        TALON_PATH="/mnt/d/SGNEX/GTF_files/talon/${NAME}/${NAME}.gtf"
        if [ ! -f "$TALON_PATH" ]; then
            log_message "Running TALON for $NAME..." "$(tput setaf 3)"
            activate_env "$ENV_TALON"
            time bash ~/nano-pipe/ID/talonscript.sh "$NAME"
        else
            log_message "TALON output file exists. Skipping TALON..." "$(tput setaf 3)"
        fi

        # ESPRESSO
      #  ESPRESSO_PATH="/mnt/d/SGNEX/GTF_files/espresso/${NAME}/${NAME}.gtf"
      #  if [ ! -f "$ESPRESSO_PATH" ]; then
      #      log_message "Running ESPRESSO for $NAME..." "$(tput setaf 3)"
       #     activate_env "$ENV_ESPRESSO"
       #     time bash ~/nano-pipe/ID/espressoscript.sh "$NAME"
      #  else
         #   log_message "Espresso output files exist. Skipping Espresso..." "$(tput setaf 3)"
        #fi

        # FLAIR
        FLAIR_PATH="/mnt/d/SGNEX/GTF_files/flair/${NAME}/${NAME}.gtf"
        if [ ! -f "$FLAIR_PATH" ]; then
            log_message "Running Flair for $NAME..." "$(tput setaf 3)"
            activate_env "$ENV_FLAIR"
            time bash ~/nano-pipe/ID/flairscript.sh "$NAME"
        else
            log_message "Flair output file exists. Skipping Flair..." "$(tput setaf 3)"
        fi

    else
        log_message "File ${BAM_FILE} does not exist. Writing to log file ${ID_LOG}..." "$(tput setaf 1)"
        echo "File ${BAM_FILE} does not exist." >> "$ID_LOG"
    fi
}

# Function to perform Mapping tasks
MAPPING() {
    local NAME="sd_${COUNT}_${LENGTH}-${LENGTHSD}_${ACCURACY}"
    local FASTQ_FILE="/mnt/d/SGNEX/fq/${NAME}.fastq"
    local MAP_PATH="/mnt/d/SGNEX/mini_bam/${NAME}.bam"

    if [ -f "$FASTQ_FILE" ]; then
        log_message "File ${FASTQ_FILE} exists. Proceeding..." "$(tput setaf 2)"

        if [ ! -f "$MAP_PATH" ]; then
            log_message "Running MINIMAP2 for $NAME..." "$(tput setaf 3)"
            time bash ~/nano-pipe/Mapping/minisam.sh "$NAME"
        else
            log_message "MINIMAP2 file ${NAME} exists. Skipping..." "$(tput setaf 3)"
        fi

    else
        log_message "File ${FASTQ_FILE} does not exist. Writing to log file ${MAP_LOG}..." "$(tput setaf 1)"
        echo "File ${FASTQ_FILE} does not exist." >> "$MAP_LOG"
    fi
}

# Read the CSV file line by line
sed 1d "${PARAMETER_FILE}" | while IFS=$'\t' read -r COUNT LENGTH LENGTHSD ACCURACY; do
    # Process each field (value)
    if [ "$COUNT" -ne 0 ]; then
        log_message "Count: $COUNT" "$(tput setaf 5)"
        bash ~/nano-pipe/ID/datasim/pbsimmer.sh -S "${SAMPLE_FILE}" -C "${COUNT}"
        echo "------"
        NAME="sd_${COUNT}_9000-2000_0.85"
        sleep 5
        MAPPING
        ALL_ID
    else
        log_message "SKIPPING Count: $COUNT" "$(tput setaf 6)"
    fi
    
    if [ "$LENGTH" -ne 0 ]; then
        log_message "Length: $LENGTH" "$(tput setaf 5)"
        bash ~/nano-pipe/ID/datasim/pbsimmer.sh -S "${SAMPLE_FILE}" -L "${LENGTH}"
        echo "------"
        NAME="sd_10_${LENGTH}-2000_0.85"
        sleep 5
        MAPPING
        ALL_ID
    else
        log_message "SKIPPING Length: $LENGTH" "$(tput setaf 6)"
    fi

    if [ "$ACCURACY" != 0 ]; then
        log_message "Accuracy: $ACCURACY" "$(tput setaf 5)"
        bash ~/nano-pipe/ID/datasim/pbsimmer.sh -A "${ACCURACY}" -S "${SAMPLE_FILE}"
        echo "------"
        NAME="sd_10_9000-2000_${ACCURACY}"
        sleep 5
        MAPPING
        ALL_ID
    else
        log_message "SKIPPING Accuracy: $ACCURACY" "$(tput setaf 6)"
    fi
done
