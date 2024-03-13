#!/bin/bash

REF_GENOME=/mnt/d/refData/lrgasp_grch38_sirvs.fasta
REF_ANNO=/mnt/d/refData/lrgasp_gencode_v38_sirvs.gtf
REF_TRANSCRIPTOME=/mnt/d/refData/gencode.v44.transcripts.fa
MODEL=/mnt/e/nanosim_training/training/training
EXPRESSION=/mnt/e/nanosim_training/training/expression_abundance.tsv
simulator.py transcriptome -rt $REF_TRANSCRIPTOME -rg $REF_GENOME -e $EXPRESSION -c $MODEL -b guppy -r cDNA_1D --fastq -t 8

"""
optional arguments:
  -h, --help            show this help message and exit
  -rt REF_T, --ref_t REF_T
                        Input reference transcriptome
  -rg REF_G, --ref_g REF_G
                        Input reference genome, required if intron retention
                        simulation is on
  -e EXP, --exp EXP     Expression profile in the specified format as
                        described in README
  -c MODEL_PREFIX, --model_prefix MODEL_PREFIX
                        Location and prefix of error profiles generated from
                        characterization step (Default = training)
  -o OUTPUT, --output OUTPUT
                        Output location and prefix for simulated reads
                        (Default = simulated)
  -n NUMBER, --number NUMBER
                        Number of reads to be simulated (Default = 20000)
  -max MAX_LEN, --max_len MAX_LEN
                        The maximum length for simulated reads (Default =
                        Infinity)
  -min MIN_LEN, --min_len MIN_LEN
                        The minimum length for simulated reads (Default = 50)
  --seed SEED           Manually seeds the pseudo-random number generator
  -k KMERBIAS, --KmerBias KMERBIAS
                        Minimum homopolymer length to simulate homopolymer contraction and
                        expansion events in, a typical k is 6
  -b {albacore,guppy}, --basecaller {albacore,guppy}
                        Simulate homopolymers with respect to chosen  
                        basecaller: albacore or guppy
  -r {dRNA,cDNA_1D,cDNA_1D2}, --read_type {dRNA,cDNA_1D,cDNA_1D2}
                        Simulate homopolymers with respect to chosen read
                        type: dRNA, cDNA_1D or cDNA_1D2
  -s STRANDNESS, --strandness STRANDNESS
                        Proportion of sense sequences. Overrides the value
                        profiled in characterization stage. Should be between
                        0 and 1
  --no_model_ir         Ignore simulating intron retention events
  --perfect             Ignore profiles and simulate perfect reads
  --polya POLYA         Simulate polyA tails for given list of transcripts
  --fastq               Output fastq files instead of fasta files
  -t NUM_THREADS, --num_threads NUM_THREADS
                        Number of threads for simulation (Default = 1)
  --uracil              Converts the thymine (T) bases to uracil (U) in the
                        output fasta format
"""