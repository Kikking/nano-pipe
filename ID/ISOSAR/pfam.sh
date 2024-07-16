#!/bin/bash
ID=$1

#Run ~/fix+perl.sh if this doesnt run

mkdir /mnt/d/ISOSAR_files/${ID}/pfam/

echo "splitting FASTA..."
bash ~/nano-pipe/ID/ISOSAR/fasta_splitter.sh $ID

echo "Running PFAM"
counter=0
for file in /mnt/d/ISOSAR_files/${ID}/pfam_split/*; do
((counter++))
    echo "$counter"
    # Run pfam_scan.pl on current chunk file
/home/kikking/PfamScan/pfam_scan.pl -fasta $file \
-dir /home/kikking/pfam_db \
-out /mnt/d/ISOSAR_files/${ID}/pfam/${counter}.pfam_output.txt \
-cpu 10
    echo "Finished processing $file"
done


