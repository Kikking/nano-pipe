#!/bin/bash

# Function to split FASTA file into smaller files by number of sequences
    ID=$1

    input_file=/mnt/d/ISOSAR_files/${ID}/isoformSwitchAnalyzeR_isoform_AA.fasta
    sequences_per_file=1
    output_prefix=/mnt/d/ISOSAR_files/${ID}/fasta_split/split

    # Initialize counters
    sequence_count=0
    file_count=1

    # Create the first output file
    current_output="${output_prefix}_${file_count}.fasta"
    touch $current_output

    # Read each line from the input file
    while IFS= read -r line; do
    echo "READING"
        # Check if the line is a header (starts with '>')
        if [[ $line =~ ^\> ]]; then
            ((sequence_count++))
            echo "PASSED > check"
            # Check if we need to start a new file
            if [ $sequence_count -gt $sequences_per_file ]; then
                ((file_count++))
                echo "PASED MAKING NEW FILE CHECK"
                sequence_count=1
                current_output="${output_prefix}_${file_count}.fasta"
                touch $current_output
            fi
        fi

        # Write the line to the current output file
        echo "$line" >> $current_output
    done < "$input_file"

