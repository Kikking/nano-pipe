#!/bin/bash
ID=$1

#Run ~/fix+perl.sh if this doesnt run

mkdir /mnt/d/ISOSAR_files/${ID}/pfam/


/home/kikking/PfamScan/pfam_scan.pl -fasta /mnt/d/ISOSAR_files/${ID}/isoformSwitchAnalyzeR_isoform_AA.fasta \
-outfile /mnt/d/ISOSAR_files/${ID}/pfam/pfamout.txt \
-dir /home/kikking/pfam_db \

