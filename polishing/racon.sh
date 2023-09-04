#!/bash/bin

PORECHOPPED=
MAPPED=
REFERENCE=

racon -m 8 -x -6 -g -8 -w 500 -t 8 $PORECHOPPED $MAPPED $REFERENCE > rac_"${PORECHOPPED##*/}".fasta