#!/bin/bash
#Each SGNex folder in nano_fast5 will have all reads for that sample. 

for i in nano_fast5;
do
guppy_basecaller -i /mnt/d/SGNEX/p5/A_d_r1r3.pod5 -s ~/mnt/d/SGNEX/guppy_fq -x cuda:all --flowcell FLO-MIN106 --kit SQK-DCS108  -q 0 -r --num_callers 8 --cpu_threads_per_caller 1 




