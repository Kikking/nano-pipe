

git clone https://github.com/lh3/minimap2
cd minimap2 && make

./minimap2 -ax map-ont ref.fa ont.fq.gz > aln.sam  # Oxford Nanopore genomic reads

for sample in barcode{01..06} unclassified
do minimap2 -ax splice -uf -k14 --junc-bed  $bed $genome $fq/$sample.fq.gz | samtools view -b | samtools sort > $sample.sorted.bam
samtools index $sample.sorted.bam $sample.sorted.bai
done

-d save index
-a align 
-x create index
-c cigar string
-uf unstranded force (considers forward transcript only)
splice   orientation unknown

--splice-flank=no for SIRV annotation 
-k14 k-mer 14

 1-What param to use? a,x, splice  
 2-What referencer file? tick
 3-Should I trim first? probably
 4-SIRV annotations? later
 5-BED file annotations for each cell line?? NO

 Can you please tell me from where can I get the splice junction annotation file for human.
 ou can download a GTF file from Ensembl.



