#!/bin/bash 

COUNT=10
LENGTH=9000
LENGTHSD=2000
ACCURACY=0.85

while getopts L:A:C:S:ID: flag
do
    case "${flag}" in
        L) LENGTH=${OPTARG};;
        A) ACCURACY=${OPTARG};;
        C) COUNT=${OPTARG};;
        S) SAMPLE_FILE=${OPTARG};;
        ID) ID=${OPTARG};;
    esac
done

awk -v count="$COUNT" 'BEGIN {OFS="\t"} {$2=($2*count)}1' ~/pbsim3-3.0.4/sample/${SAMPLE_FILE} > ~/pbsim3-3.0.4/sample/${SAMPLE_FILE}_"$COUNT"

 pbsim --strategy trans --method errhmm \
 --errhmm ~/pbsim3-3.0.4/data/ERRHMM-ONT.model \
 --transcript ~/pbsim3-3.0.4/sample/${SAMPLE_FILE}_$COUNT \
 --prefix "/mnt/d/SGNEX/fq/sd_${COUNT}_${LENGTH}-${LENGTHSD}_${ACCURACY}_${ID}"  \
 --length-mean $LENGTH \
 --length-sd $LENGTHSD \
 --accuracy-mean $ACCURACY 