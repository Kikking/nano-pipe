# nano-pipe

# Fix SIRV GTF
Problem: /mnt/e/refData/hg38_sequins_SIRV_ERCCs_longSIRVs.fa has duplicate transcripts:

            gene 1
              transcript 1
                   exon 1
                   exon 2
                   exon 3
              transcript 1
                   exon 4
                   exon 5
                   exon 6


1. Filter out all genes and transcript features: 
   
       cat test.gtf | awk '$3!="gene" && $3!="transcript"{print}' > filteredtest.gtf


2. Using GFFutils, create a .db and rebuild transcript and gene features by setting: 
   
       disable_infer_genes=False, disable_infer_transcripts=False  


3. Convert the db back into a gtf file using the function from the gFFutils script in nano-pipe


4. Remove [] and '' from feature IDs:

       cat output_test1.gtf | awk ' {gsub(/[\047\[\]]/,"",$10);gsub(/[\047\[\]]/,"",$12);gsub(/[\047\[\]]/,"",$14)}' > SIRV_edited.gtf


To create unique exon IDs (didnt use, but might need):
    
       awk 'BEGIN {counter = 0} $3=="exon" {gsub(/"|;/,"",$14);gsub(/"|;/,"",$12);$14="\""$12"-"$14"\";";$12="\""$12"\";"}1' test.gtf > mod.gtf
