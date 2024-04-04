#!/bin/bash 

COUNT=10
LENGTH=9000
LENGTHSD=2000
ACCURACY=0.85
ID=0

while getopts L:A:C:S:ID: flag
do
    case "${flag}" in
        L) LENGTH=${OPTARG};;
        A) ACCURACY=${OPTARG};;
        C) COUNT=${OPTARG};;
        S) SAMPLE_DIR=${OPTARG};;
        ID) ID=${OPTARG};;
    esac
done



for SAMPLE_FILE in $(ls ~/pbsim3-3.0.4/sample/$SAMPLE_DIR/*); do
ID=$((ID+1))

awk -v count="$COUNT" 'BEGIN {OFS="\t"} {$2=($2*count);$3=($3*count)}1' ${SAMPLE_FILE} > ${SAMPLE_FILE}_"$COUNT"

 pbsim --strategy trans --method errhmm \
 --errhmm ~/pbsim3-3.0.4/data/ERRHMM-RSII.model \
 --transcript ${SAMPLE_FILE}_$COUNT \
 --prefix "/mnt/e/pbsimulti/sd_${COUNT}_${LENGTH}-${LENGTHSD}_${ACCURACY}_${ID}"  \
 --length-mean $LENGTH \
 --length-sd $LENGTHSD \
 --accuracy-mean $ACCURACY 
 done