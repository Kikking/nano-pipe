#!/bin/bash
ID=$1


echo "splitting FASTA..."
bash ~/nano-pipe/ID/ISOSAR/fasta-splitter.sh $ID

# Directory containing split sequences
split_dir=/mnt/d/ISOSAR_files/${ID}/fasta_split/
# Directory to store individual outputs
output_dir=/mnt/d/ISOSAR_files/${ID}/iupred/
# Create the output directory
mkdir -p "$output_dir"

# Loop through each sequence file and run the script
for seq_file in "$split_dir"/*.fasta; do
    # Extract the base name of the file (without path and extension)
    base_name=$(basename "$seq_file" .fasta)
    python3 /mnt/d/ISOSAR_software/iupred2a/iupred2a.py -a \
 -d /mnt/d/ISOSAR_software/iupred2a/ \
 $seq_file \
 long > $output_dir/$base_name.txt
done

