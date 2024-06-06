#!/bin/bash

TAG=$1

#to remove novel IDs
shuf /home/kikking/pbsim3-3.0.4/sample/${TAG}_sample_1000.transcript | head -n 200 | awk '{print $1}' > /home/kikking/novel_realm/novel/NOVEL_${TAG}_sample_1000.transcript_LIST

NOVEL_LIST="/home/kikking/novel_realm/novel/NOVEL_${TAG}_sample_1000.transcript_LIST"
GTF_FILE="/home/kikking/long_realm/ref/gencode45_chrIS_SIRV.gtf"


# Convert the transcript list to a format suitable for grep
# This will create a pattern like: transcript_id "ENST00000642060.*"|transcript_id "ENST00000373850.*"|...
grep_pattern=$(awk '{print "transcript_id \""$1".*\""}' $NOVEL_LIST | tr '\n' '|')
grep_pattern=${grep_pattern%?}  # Remove the trailing '|'

# Use grep to filter out the matching lines and save to a temporary file
grep -Ev "$grep_pattern" $GTF_FILE > /home/kikking/novel_realm/novel/NOVEL_${TAG}_gencode45_chrIS_SIRV.gtf







