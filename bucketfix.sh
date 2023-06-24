#!/bin/bash

# 1.  Mount $BUCKET_NAME at $MOUNT_PT
# 2.  Run this script
MOUNT_PT=${1:-HOME/mnt}
BUCKET_NAME=$2
DEL_OUTFILE=${3:-y}    # Set to y or n

echo "Reading objects in $BUCKET_NAME"
OUTFILE=dir_names.txt
gsutil ls -r gs://$BUCKET_NAME/** | while read BUCKET_OBJ
do   
    dirname "$BUCKET_OBJ"
done | sort -u > $OUTFILE
echo "Processing directories found"
cat $OUTFILE | while read DIR_NAME
do
    LOCAL_DIR=`echo "$DIR_NAME" | sed "s=gs://$BUCKET_NAME/==" | sed "s=gs://$BUCKET_NAME=="`
    #echo $LOCAL_DIR
    TARG_DIR="$MOUNT_PT/$LOCAL_DIR"
    if ! [ -d "$TARG_DIR" ]
    then
        echo "Creating $TARG_DIR"
        mkdir -p "$TARG_DIR"
    fi
done
if [ $DEL_OUTFILE = "y" ]
then
    rm $OUTFILE
fi
echo "Process complete"