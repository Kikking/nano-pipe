

args <- commandArgs(trailingOnly = TRUE)
filepath <- args[1]

library(bambu)


fa.file <- "/mnt/e/refData/hg38_sequins_SIRV_ERCCs_longSIRVs.fa"

gtf.file <- "/mnt/e/refData/SIRV_edited.gtf"

annotations <- readRDS("/mnt/e/refData/SIRV_edited_annotations.rds")

### EDIT HERE ###


#################
se <- bambu(reads = paste0("/mnt/d/SGNEX/mini_bam/",filepath,".bam"), annotations = annotations, genome = fa.file, lowMemory  = FALSE, quant = T)
#writeToGTF(se, paste0("D:/SGNEX/GTF_files/bambu", sub(".bam", "", sub("D:/SGNEX/mini_bam", "", filepath)),".gtf"))
writeBambuOutput(se, paste0("/mnt/d/SGNEX/GTF_files/bambu/",filepath))

