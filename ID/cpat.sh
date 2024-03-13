

cpat.py -x /mnt/d/SGNEX/cpata/Human_Hexamer.tsv --antisense -d /mnt/d/SGNEX/cpata/Human_logitModel.RData --top-orf=5 -g /mnt/d/SGNEX/isoformSwitchAnalyzeR_isoform_nt.fasta -o /mnt/d/SGNEX/cpata/output1
cd /mnt/d/SGNEX/CPC2_standalone-1.0.1
bin/CPC2.py -i /mnt/d/SGNEX/cpata/ifnb/isoformSwitchAnalyzeR_isoform_nt.fasta -o /mnt/d/SGNEX/cpata/ifnb/AvHIFN

awk 'BEGIN {n_seq=0;} /^>/ {if(n_seq%99==0){file=sprintf("myseq%d.fa",n_seq);} print >> file; n_seq++; next;} { print >> file; }' < sequences.fa

./interproscan.sh -appl Pfam -i /mnt/d/SGNEX/cpata/ifn/isoformSwitchAnalyzeR_isoform_AA_complete.fasta -b /mnt/d/SGNEX/cpata/A549.IFN_Pfam

