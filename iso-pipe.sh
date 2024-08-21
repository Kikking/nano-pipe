#!/bin/bash

# Define file paths
INPUT_FILE="$1" #input list of SIM_KEYS names
QUICK="${2:-f}" #just runs stringtie, isoquant and flair
NOVEL="${3:-f}" #runs either in normal mode or novel mode
QUANT="${4:-f}" #runs oarfish and kallisto on top of normal pipe

# Define log file paths
ID_LOG="ALL_ID.log"
MAP_LOG="MAPPING.log"
QUANT_LOG="QUANT.log"

# Source Conda
source ~/miniconda3/etc/profile.d/conda.sh
eval "$(conda shell.bash hook)"

# Define Conda environments for each tool
ENV_FLAIR="flair"
ENV_TALON="talon"
ENV_ESPRESSO="ESPRESSO"
ENV_ISOQUANT="isoquant"

# Define text formatting variables
RED=$(tput setaf 1)       # Red text for error messages
YELLOW=$(tput setaf 3)    # Yellow text for warning messages
GREEN=$(tput setaf 2)     # Green text for success messages
RESET=$(tput sgr0)        # Reset text formatting

# Check if novel stuff is present when running in novel mode
if [ "$NOVEL" == "novel" ]; then
    OUT="novel/"
else
    OUT=""
fi

# Function to activate Conda environment
activate_env() {
    local env_name="$1"
    conda activate "$env_name"
    if [ $? -ne 0 ]; then
        log_message "Failed to activate Conda environment: $env_name" "$RED"
        exit 1
    fi
}

# Function for logging messages with color
log_message() {
    local message="$1"
    local color="$2"
    echo -e "${color}${message}${RESET}"
}

# Function to perform ID tasks
QUICK_ID() {
    local NAME="$SAMPLE"
    local BAM_FILE="/mnt/d/SGNEX/mini_bam/${NAME}.bam"

    if [ -f "$BAM_FILE" ]; then
        log_message "File ${NAME}.bam exists. Proceeding..." "$GREEN"

        # STRINGTIE
        STRING_PATH="/mnt/d/SGNEX/GTF_files/stringtie/${OUT}${NAME}/${NAME}.gtf"
        if [ ! -f "$STRING_PATH" ]; then
            log_message "Running STRINGTIE for $NAME..." "$YELLOW"
            time bash ~/nano-pipe/ID/string.sh "$NAME" "$NOVEL"
            bash ~/nano-pipe/template.sh "$NAME" STRINGTIE
        else
            log_message "STRING file ${NAME}.gtf exists. Skipping..." "$YELLOW"
        fi

        # ISOQUANT
        ISOQUANT_PATH="/mnt/d/SGNEX/GTF_files/isoquant/${OUT}${NAME}/${NAME}.gtf"
        if [ ! -f "$ISOQUANT_PATH" ]; then
            log_message "Running isoQUANT for $NAME..." "$YELLOW"
            activate_env "$ENV_ISOQUANT"
            time bash ~/nano-pipe/ID/isoqscript.sh "$NAME" "$NOVEL"
            bash ~/nano-pipe/template.sh "$NAME" ISOQUANT
        else
            log_message "isoQUANT file ${NAME}.gtf exists. Skipping..." "$YELLOW"
        fi
    else
        log_message "File ${BAM_FILE} does not exist. Writing to log file ${ID_LOG}..." "$RED"
        echo "File ${BAM_FILE} does not exist." >> "$ID_LOG"
    fi

    # FLAIR
   # FLAIR_PATH="/mnt/d/SGNEX/GTF_files/flair/${OUT}${NAME}/${NAME}.isoforms.gtf"
   # if [ ! -f "$FLAIR_PATH" ]; then
    #    log_message "Running Flair for $NAME..." "$YELLOW"
    #    activate_env "$ENV_FLAIR"
      #  time bash ~/nano-pipe/ID/flairscript.sh "$NAME" "$NOVEL"
   # else
   #     log_message "Flair output file exists. Skipping Flair..." "$YELLOW"
   # fi
}

ALL_ID() {
    local NAME="$SAMPLE"
    local BAM_FILE="/mnt/d/SGNEX/mini_bam/${NAME}.bam"

    if [ -f "$BAM_FILE" ]; then
        log_message "File ${NAME}.bam exists. Proceeding..." "$GREEN"

        # STRINGTIE
        STRING_PATH="/mnt/d/SGNEX/GTF_files/stringtie/${OUT}${NAME}/${NAME}.gtf"
        if [ ! -f "$STRING_PATH" ]; then
            log_message "Running STRINGTIE for $NAME..." "$YELLOW"
            time bash ~/nano-pipe/ID/string.sh "$NAME" "$NOVEL"
            bash ~/nano-pipe/template.sh "$NAME" STRINGTIE
        else
            log_message "STRING file ${NAME}.gtf exists. Skipping..." "$YELLOW"
        fi

        # ISOQUANT
        ISOQUANT_PATH="/mnt/d/SGNEX/GTF_files/isoquant/${OUT}${NAME}/${NAME}.gtf"
        if [ ! -f "$ISOQUANT_PATH" ]; then
            log_message "Running isoQUANT for $NAME..." "$YELLOW"
            activate_env "$ENV_ISOQUANT"
            time bash ~/nano-pipe/ID/isoqscript.sh "$NAME" "$NOVEL"
            bash ~/nano-pipe/template.sh "$NAME" ISOQUANT
        else
            log_message "isoQUANT file ${NAME}.gtf exists. Skipping..." "$YELLOW"
        fi

        # BAMBU
        BAMBU_PATH="/mnt/d/SGNEX/GTF_files/bambu/${NAME}/extended_annotations.gtf"
        if [ ! -f "$BAMBU_PATH" ]; then
            log_message "Running BAMBU for $NAME..." "$YELLOW"
            conda deactivate
            time Rscript ~/nano-pipe/ID/bambush.R "$NAME" "$NOVEL"
            bash ~/nano-pipe/template.sh "$NAME" BAMBU
        else
            log_message "BAMBU file ${NAME} exists. Skipping..." "$YELLOW"
        fi

        # TALON
        TALON_PATH="/mnt/d/SGNEX/GTF_files/talon/${OUT}${NAME}/${NAME}.gtf"
        if [ ! -f "$TALON_PATH" ]; then
            log_message "Running TALON for $NAME..." "$YELLOW"
            activate_env "$ENV_TALON"
            time bash ~/nano-pipe/ID/talonscript.sh "$NAME" "$NOVEL"
        else
            log_message "TALON output file exists. Skipping TALON..." "$YELLOW"
        fi
          #ESPRESSO
        ESPRESSO_PATH="/mnt/d/SGNEX/GTF_files/espresso/${NAME}/${NAME}.gtf"
        if [ ! -f "$ESPRESSO_PATH" ]; then
            log_message "Running ESPRESSO for $NAME..." "${YELLOW}"
            activate_env "$ENV_ESPRESSO"
            time bash ~/nano-pipe/ID/espressoscript.sh "$NAME" > /dev/null
        else
            log_message "Espresso output files exist. Skipping Espresso..." "${YELLOW}"
        fi

        # FLAIR
        FLAIR_PATH="/mnt/d/SGNEX/GTF_files/flair/${OUT}${NAME}/${NAME}.gtf"
        if [ ! -f "$FLAIR_PATH" ]; then
            log_message "Running Flair for $NAME..." "$YELLOW"
            activate_env "$ENV_FLAIR"
            time bash ~/nano-pipe/ID/flairscript.sh "$NAME" "$NOVEL"
        else
            log_message "Flair output file exists. Skipping Flair..." "$YELLOW"
        fi

    else
        log_message "File ${BAM_FILE} does not exist. Writing to log file ${ID_LOG}..." "$RED"
        echo "File ${BAM_FILE} does not exist." >> "$ID_LOG"
    fi
}

# Function to perform Mapping tasks
MAPPING() {
    local NAME="$SAMPLE"
    local FASTQ_FILE="/mnt/d/SGNEX/fq/${NAME}.fastq"
    local MAP_PATH="/mnt/d/SGNEX/mini_bam/${NAME}.bam"

    if [ -f "$FASTQ_FILE" ]; then
        log_message "File ${FASTQ_FILE} exists. Proceeding..." "$GREEN"

        if [ ! -f "$MAP_PATH" ]; then
            log_message "Running MINIMAP2 for $NAME..." "$YELLOW"
            time bash ~/nano-pipe/Mapping/minisam.sh "$NAME"
        else
            log_message "MINIMAP2 file ${NAME} exists. Skipping..." "$YELLOW"
        fi

    else
        log_message "File ${FASTQ_FILE} does not exist. Writing to log file ${MAP_LOG}..." "$RED"
        echo "File ${FASTQ_FILE} does not exist." >> "$MAP_LOG"
    fi
}

# Function to perform Quantification tasks with lr-kallisto
LR_KALLISTO() {
    local NAME="$SAMPLE"
    local FASTQ_FILE="/mnt/d/SGNEX/fq/${NAME}.fastq"
    local KALLISTO_PATH="/mnt/d/SGNEX/quant/kallisto/${NAME}/abundance.tsv"

    if [ -f "$FASTQ_FILE" ]; then
        log_message "File ${FASTQ_FILE} exists. Proceeding..." "$GREEN"

        if [ ! -f "$KALLISTO_PATH" ]; then
            log_message "Running lr_kallisto for $NAME..." "$YELLOW"
            time bash ~/nano-pipe/Quant/lr_kallisto.sh "$NAME"
        else
            log_message "lr_kallisto quant file ${NAME}.quant exists. Skipping..." "$YELLOW"
        fi

    else
        log_message "File ${FASTQ_FILE} does not exist. Writing to log file ${QUANT_LOG}..." "$RED"
        echo "File ${FASTQ_FILE} does not exist." >> "$QUANT_LOG"
    fi
}

# Function to perform Quantification tasks with oarfish
OARFISH() {
    local NAME="$SAMPLE"
    local FASTQ_FILE="/mnt/d/SGNEX/fq/${NAME}.fastq"
    local OARFISH_PATH="/mnt/d/SGNEX/quant/oarfish/${NAME}/${NAME}.quant"

    if [ -f "$FASTQ_FILE" ]; then
        log_message "File ${FASTQ_FILE} exists. Proceeding..." "$GREEN"

        if [ ! -f "$OARFISH_PATH" ]; then
            log_message "Running oarfish for $NAME..." "$YELLOW"
            time bash ~/nano-pipe/Quant/oarfish.sh "$NAME"
        else
            log_message "oarfish quant file ${NAME}.quant exists. Skipping..." "$YELLOW"
        fi

    else
        log_message "File ${FASTQ_FILE} does not exist. Writing to log file ${QUANT_LOG}..." "$RED"
        echo "File ${FASTQ_FILE} does not exist." >> "$QUANT_LOG"
    fi
}

# Call the functions
while read -r SAMPLE _; do

    MAPPING

    if [ "$QUICK" == "q" ]; then
        
        QUICK_ID 
         if [ "$QUANT" == "quant" ]; then
            LR_KALLISTO
            OARFISH
        fi
    else
        ALL_ID
         if [ "$QUANT" == "quant" ]; then
            LR_KALLISTO
            OARFISH
        fi
    fi

   

done < "$INPUT_FILE"
