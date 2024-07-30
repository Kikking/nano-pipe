library(bambu)

fa.file <-"//wsl.localhost/Ubuntu-22.04/home/kikking/long_realm/ref/GRCh38.p14_chr1S_SIRV.fa"
#fa.file <- "E:/refData/lrgasp_grch38_sirvs.fasta"

gtf.file <- "E:/refData/current/gencode45_chrIS_SIRV.gtf"
#gtf.file <- "E:/refData/lrgasp_gencode_v38_sirvs.gtf"

annotations <- prepareAnnotations(gtf.file)



A_bam <- c("D:/SGNEX/mini_bam/A_d_r5r3.bam",
           "D:/SGNEX/mini_bam/A_d_r3r2.bam",
           "D:/SGNEX/mini_bam/A_d_r3r1.bam",
           "D:/SGNEX/mini_bam/A_d_r2r1.bam",
           "D:/SGNEX/mini_bam/A_d_r1r3.bam")

K_bam <- c("D:/SGNEX/mini_bam/K_d_r2r2.bam",
          "D:/SGNEX/mini_bam/K_d_r2r1.bam",
          "D:/SGNEX/mini_bam/K_d_r1r2.bam")

H_bam <- c("D:/SGNEX/mini_bam/H_d_r4r2.bam",
           "D:/SGNEX/mini_bam/H_d_r4r1.bam",
           "D:/SGNEX/mini_bam/H_d_r1r1.bam",
           "D:/SGNEX/mini_bam/H_d_r1r2.bam")

Hc_bam <- c("D:/SGNEX/mini_bam/Hc_d_r5r1.bam",
            "D:/SGNEX/mini_bam/Hc_d_r4r1.bam",
            "D:/SGNEX/mini_bam/Hc_d_r3r2.bam")
all_list <- c(A_bam,K_bam,H_bam,Hc_bam)
se.ALL <- bambu(reads = all_list, annotations = annotations, genome = fa.file, discovery =F, lowMemory = F)
#writeBambuOutput(se.A, paste0("D:/SGNEX/GTF_files/bambu/A"))
fig <- plotBambu(se.ALL, type = "pca")


counts <- assay(se.ALL, "counts")
pca_result <- prcomp(counts[,-1], center=TRUE, scale.=TRUE)

pca_df <- as.data.frame(pca_result$x[, 1:2])
pca_df$Sample <- colnames(counts)

# Plot PCA using ggplot2 with labeled points
ggplot(pca_df, aes(x = PC1, y = PC2, label = Sample)) +
  geom_point(size = 3) +
  geom_text_repel() +
  labs(title = "PCA Plot", x = "Principal Component 1", y = "Principal Component 2") +
  theme_minimal()
