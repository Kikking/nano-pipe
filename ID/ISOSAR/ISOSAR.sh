#!/bin/bash

ID=$1

echo "!!!!!!!!!!!!!make sure in sigP env!!!!!!!!!!!"
echo "SIGP"
bash ~/nano-pipe/ID/ISOSAR/signalP.sh $ID
echo "IUPRED"
bash ~/nano-pipe/ID/ISOSAR/iupred.sh $ID
echo "PFAM"
bash ~/nano-pipe/ID/ISOSAR/pfam.sh $ID
