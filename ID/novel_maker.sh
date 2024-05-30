#!/bin/bash

#to remove novel IDs
#shuf sample_1001.transcripts | head -n -200 | awk '{print $1}' > novel_trans

transcript_list=$1
gtf_file="/mnt/e/refData/current/gencode45_chrIS_SIRV.gtf"


# Convert the transcript list to a format suitable for grep
# This will create a pattern like: transcript_id "ENST00000642060.*"|transcript_id "ENST00000373850.*"|...
grep_pattern=$(awk '{print "transcript_id \""$1".*\""}' $transcript_list | tr '\n' '|')
grep_pattern=${grep_pattern%?}  # Remove the trailing '|'

# Use grep to filter out the matching lines and save to a temporary file
grep -Ev "$grep_pattern" $gtf_file > genconde45_novel.gtf 


