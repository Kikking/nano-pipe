#!/bin/bash
ID=$1

split_dir=/mnt/d/ISOSAR_files/${ID}/fasta_split/
# Directory to store individual outputs
output_dir=/mnt/d/ISOSAR_files/${ID}/iupred/
# Create the output directory
mkdir -p "$output_dir"
mkdir -p "$split_dir"
echo "splitting FASTA..."
#!/bin/bash
in=/mnt/d/ISOSAR_files/${ID}/isoformSwitchAnalyzeR_isoform_AA_complete.fasta

awk '/^>/ {
    if (seq) print seq > seq_file;
    seq_name=substr($0, 2);
    gsub(/[^a-zA-Z0-9.]/, "_", seq_name);  # Replace non-alphanumeric characters except period with underscore
    seq_file="split_sequences/" seq_name ".fasta";
    seq="";
    next
}
{seq=seq"\n"$0}
END {
    if (seq) print seq > ${split_dir}/seq_file;
}' "$in"

echo "IUPREDING..."

for seq_file in "$split_dir"/*.fasta; do
    # Extract the sequence name (base name without extension)
    seq_name=$(basename "$seq_file" _.fasta)
    # Create a header for the output
    header=">${seq_name}\n# POS\tAMINO ACID\tIUPRED SCORE\tANCHOR SCORE\n"
    # Run IUPred2A on the sequence file and include the sequence name in the output
 python3 /mnt/d/ISOSAR_software/iupred2a/iupred2a.py -a \
 -d /mnt/d/ISOSAR_software/iupred2a/ $seq_file \
 long | awk -v header="$header" 'BEGIN {print header} {print}' \
 > "$output_dir/$seq_name.txt"   
