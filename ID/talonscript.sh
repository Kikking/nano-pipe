#!/bin/bash 
CONFIG_FILE=/mnt/e/talon_config1.csv
DB_FILE=/mnt/e/tdb2.db
talon --f $CONFIG_FILE --db $DB_FILE --build hg38 --nsg --o talon_test 

"""
optional arguments:
  -h, --help            show this help message and exit  
  --f CONFIG_FILE       Dataset config file: dataset name, sample description,
                        platform, sam file (comma-delimited)  
  --db FILE,            TALON database. Created using
                        talon_initialize_database
  --cb                  Use cell barcode tags to determine dataset. Useful for
                        single-cell data. Requires 3-entry config file.
  --build STRING,       Genome build (i.e. hg38) to use. Must be in the
                        database.
  --threads THREADS, -t THREADS
                        Number of threads to run program with.
  --cov MIN_COVERAGE, -c MIN_COVERAGE
                        Minimum alignment coverage in order to use a SAM
                        entry. Default = 0.9
  --identity MIN_IDENTITY, -i MIN_IDENTITY
                        Minimum alignment identity in order to use a SAM
                        entry. Default = 0.8
  --nsg, --create_novel_spliced_genes
                        Make novel genes with the intergenic novelty label for
                        transcripts that don't share splice junctions with any
                        other models
  --tmpDir
                        Path to directory for tmp files. Default = `talon_tmp/`
  --o OUTPREFIX         Prefix for output files
  """
