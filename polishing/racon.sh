#!/bash/bin

PORECHOPPED=/mnt/d/raw_IFN/A549_IFNB_nanopore.fastq.gz
MAPPED=/mnt/d/minidata_sam/map_A549_IFNB_nanopore.fastq.gz.sam
REFERENCE=/mnt/d/refData/lrgasp_grch38_sirvs.fasta

racon -m 8 -x -6 -g -8 -w 500 -t 8 $PORECHOPPED $MAPPED $REFERENCE > /mnt/d/rac/IFN/rac_"${PORECHOPPED##*/}".fasta