#!/bash/bin

PORECHOPPED=/mnt/c/Users/User/Desktop/darter/testSample.fq
MAPPED=/mnt/c/Users/User/Desktop/darter/minidata_sam/map_testSample.fq.sam
REFERENCE=/mnt/d/refData/lrgasp_grch38_sirvs.fasta

racon_wrapper -m 8 -x -6 -g -8 -w 500 -t 8 $PORECHOPPED $MAPPED $REFERENCE > /mnt/c/Users/User/Desktop/darter/rac/rac_"${PORECHOPPED##*/}".fasta