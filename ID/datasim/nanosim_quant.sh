#!/bin/bash 

REF_GENOME=/mnt/d/refData/lrgasp_grch38_sirvs.fasta
REF_ANNO=/mnt/d/refData/lrgasp_gencode_v38_sirvs.gtf
REF_TRANSCRIPTOME=/mnt/d/refData/gencode.v44.transcripts.fa.gz
MODEL=/mnt/e/nanosim_training/human_NA12878_cDNA_Bham1_guppy
READ=/mnt/d/SGNEX/fq/Hc_d_r3r2.fastq


read_analysis.py quantify -e trans -i $READ -rt $REF_TRANSCRIPTOME -o nanosim_quant -t 8

"""
optional arguments:
  -h, --help            show this help message and exit
  -e E                  Select from (trans, meta)
  -i READ, --read READ  Input reads for quantification
  -rt REF_T, --ref_t REF_T
                        Reference Transcriptome
  -gl GENOME_LIST, --genome_list GENOME_LIST
                        Reference metagenome list, tsv file, the first column is species/strain
                        name, the second column is the reference genome fasta/fastq file
                        directory, the third column is optional, if provided, it contains the
                        expected abundance (sum up to 100)
  -ga G_ALNM, --g_alnm G_ALNM
                        Genome alignment file in sam format, the header of each species should
                        match the metagenome list provided above (optional)
  -ta T_ALNM, --t_alnm T_ALNM
                        Transcriptome alignment file in sam format(optional)
  -o OUTPUT, --output OUTPUT
                        The location and prefix of outputting profile (Default = expression)
  -t NUM_THREADS, --num_threads NUM_THREADS
                        Number of threads for alignment (Default = 1)
  -n, --normalize       Normalize by transcript length
  """