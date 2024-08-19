library(bambu)


  fa.file <- "//wsl.localhost/Ubuntu-22.04/home/kikking/long_realm/ref/GRCh38.p14_chr1S_SIRV.fa"
  #fa.file <- "E:/refData/lrgasp_grch38_sirvs.fasta"
  
  gtf.file <- "/mnt/e/refData/current/gencode45_chrIS_SIRV.gtf"
  #gtf.file <- "E:/refData/lrgasp_gencode_v38_sirvs.gtf"
  
  #annotations <- prepareAnnotations(gtf.file)
  #saveRDS(annotations, file = "E:/refData/current/gencode45_chrIS_SIRV_annotations.rds")
  annotations <- readRDS("/mnt/e/refData/current/gencode45_chrIS_SIRV_annotations.rds")
  #print(samples.bam <- list.files("D:/SGNEX/mini_bam", pattern = ".bam$", full.names = TRUE))
  
  ### EDIT HERE ###
  #sampleData <- bam_list(x=c(9,10,11) )
  
  #print(sampleData)
  #################
    filepath <- paste0("/mnt/d/SGNEX/mini_bam/",sample,".bam") 
    print(filepath)
    se <- bambu(reads = filepath, annotations = annotations, genome = fa.file, lowMemory  = FALSE, quant = T, trackReads = FALSE, discovery = TRUE)
    #writeToGTF(se, paste0("D:/SGNEX/GTF_files/bambu", sub(".bam", "", sub("D:/SGNEX/mini_bam", "", filepath)),".gtf"))
    writeBambuOutput(se, paste0("/mnt/d/SGNEX/GTF_files/bambu/",sub(".bam", "", sub("/mnt/d/SGNEX/mini_bam", "", sample))))
    
