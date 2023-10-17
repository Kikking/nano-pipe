#!/bash/bin

FILE=$1 #f or d (file or directory)
TARGET=$2
REFERENCE=/mnt/d/refData/lrgasp_grch38_sirvs.fasta

#For running Racon on individual files
if [ $FILE=="f" ]
then 
    PORECHOPPED=/mnt/c/Users/User/Desktop/darter/"${TARGET##*/}"
    MAPPED=/mnt/c/Users/User/Desktop/darter/minidata_sam/map_"${TARGET##*/}".sam
    racon -m 8 -x -6 -g -8 -w 500 -t 8 $PORECHOPPED $MAPPED $REFERENCE > /mnt/c/Users/User/Desktop/darter/rac/rac_"${TARGET##*/}".fasta
fi

#For running Racon on directories
if [ $FILE=="d" ]
then
    for SAMPLE in $TARGET/*
    do 
        
        PORECHOPPED="${SAMPLE##*/}"
        MAPPED=/mnt/c/Users/User/Desktop/darter/minidata_sam/map_"${SAMPLE%.*}".sam

        echo "#########################################################################"
        echo  $PORECHOPPED 
        echo  $MAPPED
        echo "#########################################################################"

    
        racon -m 8 -x -6 -g -8 -w 500 -t 8 $PORECHOPPED $MAPPED $REFERENCE > /mnt/c/Users/User/Desktop/darter/rac/rac_"${SAMPLE##*/}".fasta
    done
fi 
