#!/bin/bash

STAR --runThreadN 8 \
--runMode genomeGenerate \
--genomeDir /mnt/e/refData/star_index/ \
--genomeFastaFiles /mnt/e/refData/hg38_sequins_SIRV_ERCCs_longSIRVs.fa \
--sjdbGTFfile /mnt/e/refdata/hg38_sequins_SIRV_ERCCs_longSIRVs_v5_reformatted.gtf