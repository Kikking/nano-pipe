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
        echo "File ${NAME}.bam exists. Proceeding..."
        # STRINGTIE
        time bash ~/nano-pipe/ID/string.sh "$NAME"
        bash ~/nano-pipe/template.sh "$NAME" STRINGTIE
        # ISOQUANT
        time bash ~/nano-pipe/ID/isoqscript.sh "$NAME"
        bash ~/nano-pipe/template.sh "$NAME" ISOQUANT
        # BAMBU
        time Rscript ~/nano-pipe/ID/bambush.R "$NAME"
        bash ~/nano-pipe/template.sh "$NAME" BAMBU
    else
        echo "File $filepath does not exist. Writing to log file $ID_LOG..."
        echo "File $filepath does not exist." >> "$ID_LOG"
    fi
}

# Function to perform Mapping tasks
MAPPING() {
    # Define the file path
    filepath="/mnt/d/SGNEX/fq/${NAME}.fq"

    # Check if the file exists
    if [ -f "$filepath" ]; then
        echo "File ${NAME}.fq exists. Proceeding..."
        time bash ~/nano-pipe/Mapping/minisam.sh "$NAME"
    else
        echo "File $filepath does not exist. Writing to log file $MAPPING_LOG..."
        echo "File $filepath does not exist." >> "$MAPPING_LOG"
    fi
}

# Read the CSV file line by line
sed 1d "/mnt/e/pbsim_data/first_run.txt" | while IFS=$'\t' read -r COUNT LENGTH LENGTHSD ACCURACY; do
    # Process each field (value)

    echo "Count: $COUNT"
    NAME="sd_${COUNT}_9000-2000_0.85"
    MAPPING
    ALL_ID

    echo "Length: $LENGTH"
    NAME="sd_10_${LENGTH}-2000_0.85"
    MAPPING
    ALL_ID

    echo "Accuracy: $ACCURACY"
    NAME="sd_10_9000-2000_${ACCURACY}"
    MAPPING
    ALL_ID
   

done
