#!/bin/bash 

COUNT=${1:-}
LENGTH=${2:-9000}
LENGTHSD=${3:-7000}
ACCURACY=${4:-0.85}

awk 'BEGIN {OFS="\t"} {$2=$2*$COUNT;$3=$3*$COUNT}1' ~/pbsim3-3.0.4/sample/sample.transcript > ~/pbsim3-3.0.4/sample/sample.transcript_$COUNT

 pbsim --strategy trans --method errhmm \
 --errhmm ~/pbsim3-3.0.4/data/ERRHMM-RSII.model \
 --transcript ~/pbsim3-3.0.4/sample/sample.transcript_$COUNT \
 --prefix /mnt/d/SGNEX/fq/sd_$COUNT_$LENGTH-$LENGTHSD_$ACCURACY \
   --length-mean $LENGTH \
  --length-sd  $LENGTHSD \
  --accuracy-mean $ACCURACY 