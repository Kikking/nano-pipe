library(bambu)

# Capture command-line arguments
args <- commandArgs(trailingOnly = TRUE)
sample <- args[1]

fa.file <- "//wsl.localhost/Ubuntu-22.04/home/kikking/long_realm/ref/GRCh38.p14_chr1S_SIRV.fa"
gtf.file <- "/mnt/e/refData/current/gencode45_chrIS_SIRV.gtf"

annotations <- readRDS("/mnt/e/refData/current/gencode45_chrIS_SIRV_annotations.rds")

# Create file path
filepath <- paste0("/mnt/d/SGNEX/mini_bam/", sample, ".bam")
print(filepath)

# Run bambu
se <- bambu(reads = filepath, annotations = annotations, genome = fa.file, lowMemory = FALSE, quant = TRUE, trackReads = FALSE, discovery = TRUE)

# Write output
writeBambuOutput(se, paste0("/mnt/d/SGNEX/GTF_files/bambu/", sub(".bam", "", sub("/mnt/d/SGNEX/mini_bam/", "", sample))))
