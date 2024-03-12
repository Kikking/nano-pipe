#!/bin/bash 
REF_GENOME=
REF_ANNO=
REF_TRANSCRIPTOME=
read_analysis.py transcriptome -i READ -rg $REF_GENOME -rt $REF_TRANSCRIPTOME -annot $REF_ANNO -a minimap2 -t 8 -q

"""
optional arguments:
  -h, --help            show this help message and exit
  -i READ, --read READ  Input read for training
  -rg REF_G, --ref_g REF_G
                        Reference genome
  -rt REF_T, --ref_t REF_T
                        Reference Transcriptome
  -annot ANNOTATION, --annotation ANNOTATION
                        Annotation file in ensemble GTF/GFF formats, required for intron
                        retention detection
  -a {minimap2,LAST}, --aligner {minimap2,LAST}
                        The aligner to be used: minimap2 or LAST (Default = minimap2)
  -ga G_ALNM, --g_alnm G_ALNM
                        Genome alignment file in SAM/BAM format (optional)
  -ta T_ALNM, --t_alnm T_ALNM
                        Transcriptome alignment file in SAM/BAM format (optional)
  -o OUTPUT, --output OUTPUT
                        The location and prefix of outputting profiles (Default = training)
  --no_model_fit        Disable model fitting step
  --no_intron_retention
                        Disable Intron Retention analysis
  -t NUM_THREADS, --num_threads NUM_THREADS
                        Number of threads for alignment and model fitting (Default = 1)
  -c, --chimeric        Detect chimeric and split reads (Default = False)
  -q, --quantification  Perform abundance quantification (Default = False)
  -n, --normalize       Normalize by transcript length
  """