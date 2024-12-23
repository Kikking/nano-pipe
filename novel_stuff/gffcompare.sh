#~!/bin/bash 
NAME=$1 
TOOL=$2

stripped="${NAME#sd}"
TAG="${stripped%%_*}"

TRUE_GTF=/home/kikking/novel_realm/true/TRUE_${TAG}_gencode45_chrIS_SIRV.gtf
NOVEL_GTF="/mnt/d/SGNEX/GTF_files/${TOOL}/novel/${NAME}/${NAME}.filt.gtf"

mkdir /mnt/d/SGNEX/gffcmp/${TOOL}/novel/${NAME}/
~/gffcompare/gffcompare -r $TRUE_GTF -o /mnt/d/SGNEX/gffcmp/${TOOL}/novel/${NAME}/${NAME} $NOVEL_GTF

