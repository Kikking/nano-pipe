#!/bin/bash
#MODEL=/mnt/d/ISOSAR_software/signalp6_fast/signalp-6-package/models/
ID=$1

mkdir /mnt/d/ISOSAR_files/${ID}/sigP/

signalp6 \
--fastafile /mnt/d/ISOSAR_files/${ID}/isoformSwitchAnalyzeR_isoform_AA.fasta \
--organism eukarya \
--output_dir /mnt/d/ISOSAR_files/${ID}/sigP/ \
--format txt --mode fast 