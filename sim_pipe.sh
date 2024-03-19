#!/bin/bash
ID_LOG="ALL_ID.log"
MAP_LOG="MAPPING.log"
#!/bin/bash

# Function to perform ID tasks
ALL_ID() {
    # Define the file path
    filepath="/mnt/d/SGNEX/mini_bam/${NAME}.bam"

    # Check if the file exists
    if [ -f "$filepath" ]; then
    tput setaf 2 
        echo "File ${NAME}.bam exists. Proceeding..."
    tput sgr0
        # STRINGTIE
        STRING_PATH=/mnt/d/SGNEX/GTF_files/stringtie/${NAME}/${NAME}.gtf
        if [ -f "$STRING_PATH" ]; then
            tput setaf 3 
            echo "STRING file ${NAME}.gtf exists. Skipping..."
            tput sgr0
        else
            time bash ~/nano-pipe/ID/string.sh "$NAME"
            bash ~/nano-pipe/template.sh "$NAME" STRINGTIE
        fi
        # ISOQUANT
        ISOQUANT_PATH=/mnt/d/SGNEX/GTF_files/isoquant/${NAME}/${NAME}.gtf
        if [ -f "$ISOQUANT_PATH" ]; then
            tput setaf 3 
            echo "isoQUANT file ${NAME}.gtf exists. Skipping..."
            tput sgr0
        else
            time bash ~/nano-pipe/ID/isoqscript.sh "$NAME"
            bash ~/nano-pipe/template.sh "$NAME" ISOQUANT
        fi
        # BAMBU
        BAMBU_PATH=/mnt/d/SGNEX/GTF_files/bambu/${NAME}/extended_annotations.gtf
        if [ -f "$BAMBU_PATH" ]; then
            tput setaf 3 
            echo "BAMBU file ${NAME} exists. Skipping..."
            tput sgr0
        else
            time Rscript ~/nano-pipe/ID/bambush.R "$NAME"
            bash ~/nano-pipe/template.sh "$NAME" BAMBU
        fi
    else
    tput setaf 1
        echo "File $filepath does not exist. Writing to log file $ID_LOG..."
        echo "File $filepath does not exist." >> "$ID_LOG"
    tput sgr0
    fi
}

# Function to perform Mapping tasks
MAPPING() {
    # Define the file path
    filepath="/mnt/d/SGNEX/fq/${NAME}.fastq"

    # Check if the file exists
    if [ -f "$filepath" ]; then
        tput setaf 2 
        echo "File ${NAME}.fastq exists. Proceeding..."
        tput sgr0
        MAP_PATH="/mnt/d/SGNEX/mini_bam/${NAME}.bam"
        if [ -f "$MAP_PATH" ]; then
            tput setaf 3 
            echo "MINIMAP2 file ${NAME} exists. Skipping..."
            tput sgr0
        else
            time bash ~/nano-pipe/Mapping/minisam.sh "$NAME"
    else
    tput setaf 1
        echo "File $filepath does not exist. Writing to log file $MAP_LOG..."
        echo "File $filepath does not exist." >> "$MAP_LOG"
    tput sgr0
    fi
}

# Read the CSV file line by line
sed 1d "/mnt/e/pbsim_data/first_run.txt" | while IFS=$'\t' read -r COUNT LENGTH LENGTHSD ACCURACY; do
    # Process each field (value)

    echo "Count: $COUNT"
    bash ~/nano-pipe/ID/datasim/pbsimmer.sh -C ${COUNT}
    echo "------"
    NAME=sd_${COUNT}_9000-2000_0.85
    sleep 5
    MAPPING
    ALL_ID

    echo "Length: $LENGTH"
    bash ~/nano-pipe/ID/datasim/pbsimmer.sh -L ${LENGTH}
    echo "------"
    NAME=sd_1_${LENGTH}-2000_0.85
    sleep 5
    MAPPING
    ALL_ID

    echo "Accuracy: $ACCURACY"
    bash ~/nano-pipe/ID/datasim/pbsimmer.sh -A ${ACCURACY}
    echo "------"
    NAME=sd_1_9000-2000_${ACCURACY}
    sleep 5
    MAPPING
    ALL_ID
   

done