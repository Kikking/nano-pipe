#!/bin/bash
for i in /content/mount/gcp/nano_untar/mnt/projectsInstanceStore1/chenying/ena_upload/fast5/SGNex_A549_directcDNA_replicate1_run3/*;
do

echo $i
bash run_caller.sh model.chkpt $i 2048 /content/mount/SA_fastar2;

done