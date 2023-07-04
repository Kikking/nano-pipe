library(pheatmap)
library(readr)
library(tidyverse)
library(ggplot2)
library(ggthemes)
library(tximeta)
library(SummarizedExperiment)
library(egg)
library(DESeq2)
library(apeglm)
library(pcaExplorer)
library(readxl)
library(RColorBrewer)
library(gridExtra)
library(cowplot)
suppressMessages(library(org.Hs.eg.db))
suppressMessages(library(clusterProfiler))
library(AnnotationHub)
library(ggnewscale)
library(pathview)

#----------------FUNCTIONS---------------------------------------

sym_maker <- function (res){
  res$gene<- sub("[.].*", "", res$gene)
  symbols <- mapIds(org.Hs.eg.db, keys = res$gene,
                    column = c('SYMBOL'), keytype = 'ENSEMBL')
  symbols <- symbols[!is.na(symbols)]
  symbols <- symbols[match(res$gene, names(symbols))]
  res$gene <- symbols
  keep <- !is.na(res$gene)
  f_table <<- res[keep,] 
  return(f_table)
}

vol_plotter <- function(res, p=NA, l2 = NA){
  if (!is.na(p)){
    res <- res%>%filter(-log10(padj)> p)
  }
  if (!is.na(l2) & l2 > 0){
    res <- res%>%filter(!log2FoldChange > l2)
  } else if(!is.na(l2) & l2 < 0){
    res <- res%>%filter(!log2FoldChange < l2)
  }
  
  res$diffexpressed <- "NO"
  res$diffexpressed[res$log2FoldChange > 1 & res$padj < 0.05] <- "UP"
  res$diffexpressed[res$log2FoldChange < -1 & res$padj < 0.05] <- "DOWN"
  
  if (res$type[1]== "BC"){ type = "Bronchial"}
  else if (res$type[1]== "NC"){type = "Nasal"  }
  res %>%
    as_tibble()%>%
    ggplot() +
    geom_point(aes(x = log2FoldChange, y = -log10(padj),col=diffexpressed)) +
    ggtitle(paste0("Stimulated ",type," Cells")) +
    xlab("log2 fold change") + 
    ylab("-log10 adjusted p-value") +
    theme_bw()+
    scale_colour_manual(values= c("#CC6633","#333333","#3399CC"))+
    scale_x_continuous(limits = c(-5, 12))+
    scale_y_continuous(expand = c(0,0)) +
    theme(legend.position = "",
          plot.title = element_text(size = rel(1.5), hjust = 0.5),
          axis.title = element_text(size = rel(1.25))) 
}

ass_plotter <- function(res, p= NA, l2= NA){
  
  if (!is.na(p)){
    up <- res%>%filter(-log10(padj)> p)%>%rownames_to_column(var="gene")
  }
  if (!is.na(l2) & l2 > 0){
    up <- res%>%filter(log2FoldChange > l2)%>%rownames_to_column(var="gene")
  } else if(!is.na(l2) & l2 < 0){
    up <- res%>%filter(log2FoldChange < l2)%>%rownames_to_column(var="gene")
  }
  up_list <- as.list(up$gene)
  print(paste0("Number of Genes selected: ",length(up_list)))
  view(up)
  
  if (names(res[7])== "BC"){ gse <- ddsBC}
  else if (names(res[7])== "NC"){gse <- ddsNC  }
  
  ass <- assay(gse, "abundance")%>%
    as.data.frame()%>%
    rownames_to_column(var="gene")
  
  upgenes <- data.frame()
  for (i in up_list){
    uprow<- ass %>%
      filter(gene == i)
    upgenes <- rbind(upgenes,uprow)
  }
  view(upgenes)
  upgenes%>%
    pivot_longer(!gene, names_to = "sample", values_to = "counts")%>%
    ggplot(aes(x = gene, y = counts,fill= sample))+
    geom_bar(stat= "identity",position="dodge", color= "black")+
    
    theme_fivethirtyeight()+
    scale_fill_manual("",values = c("pink","red","light green","green"))+
    theme(axis.text.x = element_blank())
}

pca_plotter <- function(dds){
  
  vsd<- vst(dds, blind = TRUE)
  sampleDists <- dist(t(assay(vsd)))
  
  plotPCA(vsd, intgroup = c("Stimulation"))
  pcaData <- plotPCA(vsd, intgroup = c("Stimulation", "Cell_Line"), returnData = TRUE)
  percentVar <- round(100 * attr(pcaData, "percentVar"))
  ggplot(pcaData, aes(x = PC1, y = PC2, color = Stimulation)) +
    geom_point(size =3) +
    xlab(paste0("PC1: ", percentVar[1], "% variance")) +
    ylab(paste0("PC2: ", percentVar[2], "% variance")) +
    coord_fixed() +
    #ggtitle("PCA with VST data")+
    theme_bw()+
    theme( plot.title = element_text(size = rel(1.5), hjust = 0.5))+
    labs(color=("Cell State"), shape = ("Cell Type"))+
    scale_color_manual(labels= c("Unstimulated", "Stimulated"), values =c("green", "blue"))
}

pval_plotter <- function(res){
  if (names(res[7])== "BC"){ type = "Bronchial"}
  else if (names(res[7])== "NC"){type = "Nasal"  }
  res %>% 
    data.frame() %>%
    filter(baseMean > 1)%>%
    ggplot() +
    geom_histogram(aes(x = pvalue), breaks = seq(0, 1, 0.05),
                   color = "black", size= 1,fill = "grey50") +
    scale_y_continuous(expand = expansion(c(0, 0.05) ),limits = c(0, 4500)) +
    labs(x ="P-Value", y = "Count", title= paste0("P-Value Distribution for Stimulated ", type, " Cells") )+
    geom_histogram(aes(x = padj), breaks = seq(0, 1, 0.05),
                   color = "black",size = 1, fill = "blue",alpha=0.2) +
    theme_bw(base_size = 12)+
    theme( plot.title = element_text(size = rel(1.5), hjust = 0.5))
}

sig_plotter <- function(res, p=0.05, l2=1, bm = 100){
  if (res$type[1]== "BC"){ type = "Bronchial"}
  else if (res$type[1]== "NC"){type = "Nasal"  }
  dwn <- sum(res$padj< p & res$log2FoldChange < -l2 & res$baseMean > bm, na.rm =TRUE)
  up<- sum(res$padj< p & res$log2FoldChange > l2 & res$baseMean > bm, na.rm =TRUE)
  t<- sum(res$padj< p & abs(res$log2FoldChange) > l2 & res$baseMean > bm ,na.rm =TRUE)
  row_name <- c("", "Upregulated", "Downregulated", "Total")
  row_val <- c(type, up, dwn, t)
  sig_table <- data.frame( " "= c("", "Upregulated", "Downregulated", "Total")," "= c(type, up, dwn, t) )
  return(sig_table)
}

GO_plotter <- function(BC, NC){
  p1 <- ggplot(BC, aes(x=toupper( Description), y= Count)) +
    geom_col(fill='purple', color= "black", size=1, ) + 
    theme_bw()+
    coord_flip() + 
    scale_y_reverse(name= "Bronchial",limits= c(80,0),breaks = seq(0, 80, 20), expand= c(0,0) ) + 
    theme(panel.spacing.x = unit(0, "mm"),
          plot.margin = unit(c(5.5, 0, 5.5, 5.5), "pt"),
          panel.border = element_rect(color= "black",linetype = "solid",size= 1.2),
          axis.text.y=element_text( color= "black", face = "bold"), 
          axis.title.y=element_blank())
  
  p2 <- ggplot(NC, aes(x=Description, y= Count)) + 
    geom_col(fill='blue', color= "black", size= 1) + 
    coord_flip() +
    theme_bw() +
    scale_y_continuous(name = "Nasal",limits= c(0,80), breaks = seq(0, 80, 20) ,
                       expand= c(0,0)) +
    theme(axis.title.y=element_blank(), 
          axis.text.y=element_blank(),
          axis.line.y = element_blank(),
          
          plot.margin = unit(c(5.5, 5.5, 5.5, -3.5), "pt"), 
          panel.border = element_rect(color= "black",linetype = "solid", size= 1.2),
          panel.spacing.x = unit(0, "mm"))
  
  
  grid.arrange(cbind(ggplotGrob(p1), ggplotGrob(p2), size = "last"))
}

gene_lister <- function(go){
  a <- ""
  for (i in go$geneID){
    b <- str_split(i, "/")
    for(x in b){
      
      a <- append(a, x) 
    }
  }
  a <<- a[!duplicated(a)]
}

dot_plotter <- function(sig){
  
  FV_BC <- subset(assBC, assBC$gene %in% sig)
  
  FV_NC <- subset(assNC, assNC$gene %in% sig)
  FV_NC <- FV_NC%>%
    pivot_longer(!gene & !type, names_to = "sample", values_to = "counts")
  
  
  
  FV_BC <- FV_BC%>%
    pivot_longer(!gene & !type, names_to = "sample", values_to = "counts")
  
  
  FV_dot <- rbind(FV_NC, FV_BC)
  
  FV_dot %>%
    ggplot(aes(x= gene, y=counts, colour= sample))+
    geom_point()+
    facet_grid(~type)+
    theme_bw()+
    theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))
}

ab_plotter <- function(FV, sig){
  
  FV_dot<- subset(FV, FV$gene %in% sig)
  FV_dot <- FV_dot%>%
    pivot_longer(!gene & !type, names_to = "sample", values_to = "counts")
  
  FV_dot %>%
    ggplot(aes(x= gene, y=counts, colour= sample))+
    geom_point()+
    theme_bw()+
    theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))
}

vol_plotter2 <- function(res, p=NA, l2 = NA, sig = NULL){
  if (!is.na(p)){
    res <- res%>%filter(-log10(padj)> p)
  }
  if (!is.na(l2) & l2 > 0){
    res <- res%>%filter(log2FoldChange > l2)
  } else if(!is.na(l2) & l2 < 0){
    res <- res%>%filter(log2FoldChange < l2)
  }
  
  res$diffexpressed <- "NO"
  res$diffexpressed[res$log2FoldChange > 1 & res$padj < 0.05] <- "UP"
  res$diffexpressed[res$log2FoldChange < -1 & res$padj < 0.05] <- "DOWN"
  res$diffexpressed[res$gene %in% sig] <- "SIG"
  
  if (res$type[1]== "BC"){ type = "Bronchial"}
  else if (res$type[1]== "NC"){type = "Nasal"  }
  res %>%
    as_tibble()%>%
    ggplot(aes(x = log2FoldChange, y = -log10(padj))) +
    geom_point(aes( colour = diffexpressed)) +
    ggtitle(paste0("Stimulated ",type," Cells")) +
    xlab("log2 fold change") + 
    ylab("-log10 adjusted p-value") +
    theme_bw()+
    scale_colour_manual(values= c("#CC6633","#333333", "red","#3399CC"))+
    scale_x_continuous(limits = c(-5, 12))+
    scale_y_continuous(expand = c(0,0)) +
    theme(legend.position = "",
          plot.title = element_text(size = rel(1.5), hjust = 0.5),
          axis.title = element_text(size = rel(1.25)))  
  #geom_label_repel(data = sig_NC, # Add labels last to appear as the top layer  
  #aes(label = gene),
  #force = 2,
  # nudge_y = 1)
}

fold_plotter <- function(res, sig){
  
  res$base <- "= 100"
  res$base[res$baseMean > 100] <- "> 100"
  res$base[res$baseMean < 100] <- "< 100"
  
  test <- res%>%
    filter(gene %in% sig)
  
  test <- test[order(test$log2FoldChange, decreasing = TRUE),]
  test$gene <- as.character(test$gene)
  
  test$gene <- factor(test$gene, levels=unique(test$gene))
  
  ggplot(test,aes(x= gene, y = log2FoldChange, fill = base))+
    geom_col() +
    theme_bw()+
    theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))
}
fold_plotter3 <- function( sig){
  FV_BC <- subset(resBC, resBC$gene %in% sig)
  
  FV_NC <- subset(resNC, resNC$gene %in% sig)
  
  
  
  
  
  
  FV_dot <- rbind(FV_NC, FV_BC)
  
  test <- res%>%
    filter(gene %in% sig)
  
  test <- test[order(test$log2FoldChange, decreasing = TRUE),]
  test$gene <- as.character(test$gene)
  
  test$gene <- factor(test$gene, levels=unique(test$gene))
  
  ggplot(test,aes(x= gene, y = log2FoldChange, fill = base))+
    geom_col() +
    theme_bw()+
    theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))
}
fold_plotter2 <- function( sig){
  
  
  keggBC <- subset(resBC, resBC$gene %in% sig)
  keggNC <- subset(resNC, resNC$gene %in% sig)
  
  kegg <- merge(keggBC, keggNC, by = c("gene"))
  
  kegg <- kegg[order(kegg$log2FoldChange.x, decreasing = TRUE),]
  
  kegg$gene <- as.character(kegg$gene)
  view(kegg)
  kegg$gene <- factor(kegg$gene, levels=unique(kegg$gene))
  ggplot(kegg)+
    geom_col(aes(x= gene, y= log2FoldChange.x),colour = "black",size = 1.2, fill = "red")+
    geom_col(aes(x = gene, y = log2FoldChange.y),fill = "blue",colour = "black",size = 1.2, alpha=0.5)+
    theme_bw()+
    scale_y_continuous(expand= c(0,0),  breaks = seq(-3, 8, 1))+
    theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))
  
}
kegg_lister <- function(k, ID){
  kegg <- k[k$ID == ID]
  kegg <- gene_lister(kegg)
  kegg <- bitr(kegg, fromType="ENTREZID",
               toType=("SYMBOL"), OrgDb="org.Hs.eg.db")
  return(kegg)
}
fpm_plotter <- function(sig){
  
  keggBC <- subset(fBC, fBC$gene %in% sig)
  keggNC <- subset(fNC, fNC$gene %in% sig)
  
  
  
  keggBC <- keggBC %>% pivot_longer(!gene & !type, names_to = "sample", values_to = "counts")
  keggNC <-keggNC %>% pivot_longer(!gene & !type, names_to = "sample", values_to = "counts")
  
  kegg <- rbind(keggBC, keggNC)
  
  ggplot(kegg)+
    geom_col(aes(x= sample, y= counts, fill = type),colour = "black",size = 1.2)+
    theme_bw()+
    scale_y_continuous(expand= c(0,0))+
    theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))
  
}
#---------------FUNCTIONS----------------------------------------

salmon_quants <- file.path("E:/Keenan/res/salmon_quants")
quant_files <- list.files(salmon_quants ,pattern="quant.sf",recursive = TRUE,full.names = TRUE)
Sample_Data <- read_excel("Sample Data.xlsx")
coldata <- Sample_Data
coldata$names <- coldata$Run_Accession
coldata$files <- quant_files


seT <- tximeta(coldata)
gseT <- summarizeToGene(seT)
gseT$Stimulation <- as.factor(gseT$Stimulation)
levels(gseT$Stimulation) <- c("stimulated", "unstimulated")
gseT$Stimulation <- relevel(gseT$Stimulation, "unstimulated")

coldataBC <- coldata[1:4,]
seBC <- tximeta(coldataBC)
gseBC <- summarizeToGene(seBC)
gseBC$Stimulation <- as.factor(gseBC$Stimulation)
levels(gseBC$Stimulation) <- c("stimulated", "unstimulated")
gseBC$Stimulation <- relevel(gseBC$Stimulation, "unstimulated")

coldataNC <- coldata[5:8,]
seNC <- tximeta(coldataNC)
gseNC <- summarizeToGene(seNC)
gseNC$Stimulation <- as.factor(gseNC$Stimulation)
levels(gseNC$Stimulation) <- c("stimulated", "unstimulated")
gseNC$Stimulation <- relevel(gseNC$Stimulation, "unstimulated")

ddsBC <- DESeqDataSet(gseBC, design = ~Stimulation )
ddsBC <- DESeq(ddsBC) 
resBC <- lfcShrink(ddsBC, coef =  "Stimulation_stimulated_vs_unstimulated", type = "apeglm")
resBC$type<- "BC"
resBC <- resBC%>%   data.frame() %>%
  rownames_to_column(var="gene")
resBC <- sym_maker(resBC)
 #f_table is output for sym_maker

ddsNC <- DESeqDataSet(gseNC, design = ~Stimulation )
ddsNC <- DESeq(ddsNC)
resNC <- lfcShrink(ddsNC, coef = "Stimulation_stimulated_vs_unstimulated", type = "apeglm")
resNC$type<- "NC"
resNC <- resNC%>%   data.frame() %>%
  rownames_to_column(var="gene")
resNC <- sym_maker(resNC)
 #f_table is output for sym_maker

ddsT <- DESeqDataSet(gseT, design = ~Cell_Line + Stimulation)
ddsT <- DESeq(ddsT)                
resT <- results(ddsT)



