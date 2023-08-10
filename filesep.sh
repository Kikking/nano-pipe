#!/bin/bash

#eXTRACT FILES FOR LONGQC
CELL_LINE=$1

mkdir ~/mount/"$CELL_LINE"_QC
find $HOME/mount/nanopore_data/ -type f -iname  *"$CELL_LINE"*"DNA"*".fastq.gz" -exec cp {} ~/mount/"$CELL_LINE"_QC/ \;

#find $HOME/mount/nanopore_data -type f -iname  *"A549"*"DNA"*".fastq.gz" -exec cp {} $HOME/mount/test1_A549_QC \;