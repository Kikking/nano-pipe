#!/bash/bin

PORECHOPPED=/home/kikking/pore_test_swap
MAPPED=/mnt/d/minidata_bam/sorted_A549_IFNB_nanopore.bam
REFERENCE=/mnt/d/refData/lrgasp_grch38_sirvs.mmi

racon -m 8 -x -6 -g -8 -w 500 -t 8 $PORECHOPPED $MAPPED $REFERENCE > /mnt/d/rac/IFN/rac_"${PORECHOPPED##*/}".fasta