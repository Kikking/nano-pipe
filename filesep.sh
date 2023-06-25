#!/bin/bash

#eXTRACT FILES FOR LONGQC
CELL_LINE=$1
find $HOME/mount/nanopore_data -type f -iname  *"$CELL_LINE"*"DNA"*".fastq.gz" -exec cp {} ~/mount/"$CELL_LINE"_QC \;