library(devtools)
#install_github("GoekeLab/bambu")
library(bambu)
library(circlize)
library(ComplexHeatmap)
setwd("D:")
fa.file <- "lrgasp_grch38_sirvs.fasta"
gtf.file <- "lrgasp_gencode_v38_sirvs.gtf"
#annotations <- prepareAnnotations(gtf.file) # This function creates a reference annotation object which is used for transcript discovery and quantification in Bambu.
#saveRDS(annotations, "annotations.rds" )
annotations <- readRDS("annotations.rds")
samples.bam <- list.files("/minidata", pattern = ".bam$", full.names = TRUE)
A549_r2r1.bam <- samples.bam[25:26]
A549_cust.bam

temp <- data.frame(col.names = c("sample_name","cell","protocol","replicate", "run"))
temp$name <- "one"

bam_list <- function(x){
  QC_table <- data.frame()
  temp <- data.frame("sample_name")
  temp_sample_list <- samples.bam[x]
  
  
  for (sample in temp_sample_list){
    
   
      
      temp$sample_name <- sample
      
      temp$cell <-  ifelse(grepl("A549", temp$sample_name), "A549", 
                           ifelse(grepl("MCF7", temp$sample_name), "MCF7",
                                  ifelse(grepl("K562", temp$sample_name), "K546",
                                         ifelse(grepl("HepG2", temp$sample_name), "HepG2",
                                                ifelse(grepl("Hct116", temp$sample_name), "Hct116",
                                                       NA)))))
      
      temp$protocol <-  ifelse(grepl("_cDNA_", temp$sample_name), "cDNA", 
                               ifelse(grepl("_cDNAStranded_", temp$sample_name), "cDNAStranded",
                                      ifelse(grepl("_directcDNA_", temp$sample_name), "directcDNA",
                                             "directcDNA - 2023")))
      
      temp$replicate <-  ifelse(grepl("_replicate1_", temp$sample_name), "rep1", 
                                ifelse(grepl("_replicate2_", temp$sample_name), "rep2",
                                       ifelse(grepl("_replicate3_", temp$sample_name), "rep3",
                                              ifelse(grepl("_replicate4_", temp$sample_name), "rep4",
                                                     ifelse(grepl("_replicate5_", temp$sample_name), "rep5",
                                                            ifelse(grepl("_replicate6_", temp$sample_name), "rep6"))))))
      
      
      temp$run <-  ifelse(grepl("_run1.", temp$sample_name), "run1", 
                          ifelse(grepl("_run2.", temp$sample_name), "run2", 
                                 ifelse(grepl("_run3.", temp$sample_name), "run3", 
                                        ifelse(grepl("_run4.", temp$sample_name), "run4", 
                                               ifelse(grepl("_run5.", temp$sample_name), "run5", 
                                                      ifelse(grepl("_run6.", temp$sample_name), "run6"))))))
      
                                              
                                              
      
                                              
      QC_table <- bind_rows(QC_table, temp)
      
    }
  
  return(QC_table)
}

A549_r2r1.bam <- bam_list(25:26)

se.A549_r2r1 <- bambu(reads = A549_r2r1.bam, annotations = annotations, genome = fa.file)
save(se.A549_r2r1, file= "")

plotBambu(se.A549_r2r1, type = "annotation", gene_id = "ENSG00000150782.12")
rowData(se.A549_r2r1)$GENEID
plotBambu(se.A549_r2r1, type = "pca") 
writeBambuOutput(se.A549_r2r1, path = "D:/bambu/",all =F)
