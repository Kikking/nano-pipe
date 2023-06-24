#!/bin/bash
#Each SGNex folder in nano_fast5 will have all reads for that sample. 

for i in nano_fast5;
do
guppy_basecaller -i ~/mount/gcp/nano_untar/mnt/projectsInstanceStore1/chenying/ena_upload/fast5/SGNex_A549_directcDNA_replicate1_run3 -s ~/mount/guppy_fastq2 --flowcell FLO-MIN106 --kit SQK-DCS108  -q 0 -r --num_callers 8 --cpu_threads_per_caller 1 

done



