#!/bin/bash

RANGE1=$1
RANGE2=$2
TAG=$3

cd ~/pbsim3-3.0.4/sample/

# Takes seq IDs and FASTA sequences and puts them into two separate columns. Adds two middle columns with forward and reverse values.
awk 'BEGIN{srand()} /^>/ {if (seq) {print seqid "\t" int(1 + rand() * 100) "\tPlaceholder2\t" seq}; seqid = $1; seq = ""; next} {seq = seq $0} END{print seqid "\t" int(1 + rand() * 100) "\tPlaceholder2\t" seq}' Homo_sapiens.GRCh38.cdna.all.fa > len_temp

# Filter for longer reads
awk -v range1="$RANGE1" -v range2="$RANGE2" 'BEGIN{OFS="\t"} { if (length($4) > range1 && length($4) < range2) print}' len_temp > sample_filt_temp

shuf -n 1000 sample_filt_temp > sample_1000_temp

# Remove ">" from seq IDs
sed 's/>//' sample_1000_temp > sample_1000.transcript_temp

# To Normally Distribute count Values:

# Number of lines in the input file
num_lines=$(wc -l < sample_1000.transcript_temp)

# Generate random values and fit them to a normal distribution between 1 and 10
awk -v n="$num_lines" 'BEGIN{srand()} {for_mean = 5; for_stddev = 2;
for (i = 1; i <= n; i++) {value = int(for_mean + for_stddev * sqrt(-2 * log(rand())) * cos(2 * 3.14159 * rand()));
if (value < 1) value = 1; if (value > 10) value = 10; $2 = value; $3 = 0}}1' sample_1000.transcript_temp > ${TAG}_sample_1000.transcript_temp

# Convert spaces to tabs
awk '{gsub(/ /,"\t")}1' ${TAG}_sample_1000.transcript_temp > ${TAG}_sample_1000.transcript

rm *_temp


