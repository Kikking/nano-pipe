#!/bin/bash
ID=$1
mkdir /mnt/d/ISOSAR_files/${ID}/iupred

python3 /mnt/d/ISOSAR_software/iupred2a/iupred2a.py -d /mnt/d/ISOSAR_software/iupred2a/ \
 /mnt/d/ISOSAR_files/${ID}/isoformSwitchAnalyzeR_isoform_AA.fasta \
 long > /mnt/d/ISOSAR_files/${ID}/iupred/iupredout.txt