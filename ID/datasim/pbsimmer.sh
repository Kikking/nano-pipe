#!/bin/bash 

COUNT="1"
LENGTH="9000"
LENGTHSD="2000"
ACCURACY="0.85"

while getopts L:A:C: flag
do
    case "${flag}" in
        L) LENGTH=${OPTARG};;
        A) ACCURACY=${OPTARG};;
        C) COUNT=${OPTARG};;
    esac
done

awk 'BEGIN {OFS="\t"} {$2=$2*$COUNT;$3=$3*$COUNT}1' ~/pbsim3-3.0.4/sample/sample.transcript > ~/pbsim3-3.0.4/sample/sample.transcript_$COUNT

 pbsim --strategy trans --method errhmm \
 --errhmm ~/pbsim3-3.0.4/data/ERRHMM-RSII.model \
 --transcript ~/pbsim3-3.0.4/sample/sample.transcript_$COUNT \
 --prefix /mnt/d/SGNEX/fq/sd_$COUNT_$LENGTH-$LENGTHSD_$ACCURACY \
   --length-mean $LENGTH \
  --length-sd  $LENGTHSD \
  --accuracy-mean $ACCURACY 