#@/bin/bash
log_file="error.log"

for NAME in $@
do 
# Define the file path
filepath="/mnt/d/SGNEX/mini_bam/${NAME}.bam"

# Check if the file exists
if [ -f "$filepath" ]; then
    echo "File ${NAME} exists. Proceeding..."
    #STRINGTIE
    time bash ~/nano-pipe/ID/string.sh $NAME
    bash ~/nano-pipe/template.sh $NAME STRINGTIE
    #ISOQUANT
    time bash ~/nano-pipe/ID/isoqscript.sh $NAME
    bash ~/nano-pipe/template.sh $NAME ISOQUANT
    #BAMBU
    time Rscript ~/nano-pipe/ID/bambush.R $NAME
    bash ~/nano-pipe/template.sh $NAME BAMBU
else
    echo "File $filepath does not exist. Writing to log file $log_file..."
    echo "File $filepath does not exist." >> "$log_file"
fi
done