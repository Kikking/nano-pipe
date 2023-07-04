




#PRODUCE egoNC and egoBC
allOE_genes <- as.character(resBC$gene)

sigOE <- dplyr::filter(resBC, padj < 0.05 & abs(log2FoldChange) >1 & !is.na(padj))
sigOE_genes <- as.character(sigOE$gene)

egoBC <- enrichGO(gene = sigOE_genes, 
                universe = allOE_genes,
                keyType = "SYMBOL",
                OrgDb = org.Hs.eg.db, 
                ont = "BP", 
                pAdjustMethod = "BH", 
                qvalueCutoff = 0.05, 
                readable = TRUE)

egoBC <- enrichplot::pairwise_termsim(egoBC)





 #NASAL





allOE_genesNC <- as.character(resNC$gene)
sigOENC <- dplyr::filter(resNC, padj < 0.05, abs(log2FoldChange) >1)
sigOE_genesNC <- as.character(sigOENC$gene)

egoNC <- enrichGO(gene = sigOE_genesNC, 
                universe = allOE_genesNC,
                keyType = "SYMBOL",
                OrgDb = org.Hs.eg.db, 
                ont = "BP", 
                pAdjustMethod = "BH", 
                qvalueCutoff = 0.05, 
                readable = TRUE)

egoNC <- enrichplot::pairwise_termsim(egoNC)

Virus_NC <- egoNC[c(1:13, 15:17,20)]#VIRAL CLUSTER
Virus_NC <- Virus_NC[order(Virus_NC$Count, decreasing = FALSE),]
Virus_NC$Description <- factor(Virus_NC$Description, levels=unique(Virus_NC$Description))
Virus_BC <- egoBC[Virus_NC$ID,] 
Virus_BC$Description <- factor(Virus_BC$Description, levels=unique(Virus_BC$Description))


prot_BC <- egoBC[c(1:5,8,13,16:20),]#PROT CLUSTER
prot_BC  <- prot_BC[order(prot_BC$Count, decreasing = FALSE),]
prot_BC$Description <- factor(prot_BC$Description, levels=unique(prot_BC$Description))
prot_NC <- egoNC[prot_BC$ID,]
prot_NC$Description <- factor(prot_NC$Description, levels=prot_BC$Description)



SIGNC <- gene_lister(Virus_NC)



SIGBC <- gene_lister(Virus_BC)


uSIGNC <- subset(SIGNC, !(SIGNC %in% SIGBC))
uSIGBC <- subset(SIGBC, !(SIGBC %in% SIGNC))
SIG <- subset(SIGNC, !(SIGNC %in% uSIGNC))


TOPNC <- head(resNC[order(resNC$log2FoldChange, decreasing = TRUE),], 20)
TOPBC <- head(resBC[order(resBC$log2FoldChange, decreasing = TRUE),], 20)
BOTBC <- head(resBC[order(resBC$log2FoldChange, decreasing = FALSE),], 20)
BOTNC <- head(resNC[order(resNC$log2FoldChange, decreasing = FALSE),], 20)



prot <- gene_lister(prot_BC)

ify_NC <- egoNC[egoNC$ID=="GO:0034341"]


ify <- gene_lister(ify_NC)
ify_NC <- resNC %>% filter(gene %in% ify ) 
ify_BC <- resBC %>% filter(gene %in% ify ) 

dwnBC <- dplyr::filter(resBC, log2FoldChange < -1 & padj <0.05)
upBC<- dplyr::filter(resBC, log2FoldChange > 1 & padj <0.05)
dwnNC <- dplyr::filter(resNC, log2FoldChange < -1 & padj <0.05)
upNC<- dplyr::filter(resNC, log2FoldChange > 1 & padj <0.05)

diffNC <- subset(upNC, upNC$gene %in% dwnBC$gene)
diffBC <- subset(upBC, upBC$gene %in% dwnNC$gene)

#++++++++++++++++++++++++++++++++++++___KEGG___++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


NCID<- bitr(sigOE_genesNC, fromType="SYMBOL",
            toType=("ENTREZID"), OrgDb="org.Hs.eg.db")
kk <- enrichKEGG(gene = NCID$ENTREZID,  organism= "human", pvalueCutoff = 0.01)
kk<- enrichplot::pairwise_termsim(kk)


BCID<- bitr(sigOE_genes, fromType="SYMBOL",
            toType=("ENTREZID"), OrgDb="org.Hs.eg.db")
kkB <- enrichKEGG(gene = BCID$ENTREZID,  organism= "human", pvalueCutoff = 0.01)
kkB<- enrichplot::pairwise_termsim(kkB)


hsa_prot <- pathview(gene.data  =NCID$ENTREZID,
                     pathway.id = "hsa04141",
                     species    = "hsa")
knitr::include_graphics("hsa04141.pathview.png")

hsa_cyt <- pathview(gene.data  =NCID$ENTREZID,
                     pathway.id = "hsa04060",
                     species    = "hsa")
knitr::include_graphics("hsa04060.pathview.png")

hsa_nfkb <- pathview(gene.data  =NCID$ENTREZID,
                    pathway.id = "hsa04064",
                    species    = "hsa")
knitr::include_graphics("hsa04064.pathview.png")




#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


barplot(egoBC2, showCategory= 10)
barplot(egoNC2, showCategory = 10)

emapplot(egoNC, showCategory = 20)
emapplot(kk)
#>>>>>>>>>>>>>>>>>>>>>>>>DOT PLOT>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
assNC <-  counts(ddsNC, normalized= T)%>%
  as.data.frame()%>%mutate(type = "NC")%>%
  rownames_to_column(var="gene")
assNC <- sym_maker(assNC)


fNC <- fpm(ddsNC, robust= TRUE)%>%
  as.data.frame()%>%mutate(type = "NC")%>%
  rownames_to_column(var="gene")
fNC <- sym_maker(fNC)

fBC <- fpm(ddsBC, robust= TRUE)%>%
  as.data.frame()%>%mutate(type = "BC")%>%
  rownames_to_column(var="gene")
fBC <- sym_maker(fBC)

assBC <- counts(ddsBC, normalized= TRUE)%>%
  as.data.frame()%>%mutate(type = "BC")%>%
  rownames_to_column(var="gene")
assBC <- sym_maker(assBC)


abNC <-  assay(ddsNC, "abundance")%>%
  
  as.data.frame()%>%mutate(type = "NC")%>%
  rownames_to_column(var="gene")
abNC <- sym_maker(abNC)



abBC <- assay(ddsBC, "abundance")%>%
  as.data.frame()%>%mutate(type = "BC")%>%
  rownames_to_column(var="gene")
abBC <- sym_maker(abBC)





FV_var <- FV %>%
  rowwise() %>%
  mutate(log_var = log2FoldChange.x - log2FoldChange.y)%>% 
  filter( log_var>4)%>% 
  arrange(log2FoldChange.x, decreasing = FALSE)

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




#>>>>>>>>>>>>>>>>>>>>>>>>DOT PLOT>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>



#<<<<<<<<<<<<<<<<<<<<<<<<VOL PLOT<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

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
sig_NC <- resNC %>% filter(gene %in% uSIGNC ) 
sig_BC <- resBC %>% filter(gene %in% uSIGBC)

vol_plotter2(resNC,sig= TOPBC$gene)


#<<<<<<<<<<<<<<<<<<<<<<<<VOL PLOT<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


#HEATMAP STUFF__________________________________________________________________



sig_NC <- resNC %>% filter(gene %in% SIG ) 
sig_BC <- resBC %>% filter(gene %in% SIG ) 
FV <- merge(sig_NC, sig_BC, by = c("gene"))
heat_plotter <- function(FV){
  mat<-  select(FV, gene, log2FoldChange.x, log2FoldChange.y)
  
  mat <- as.matrix(mat[, -1])
  rownames(mat) <- FV$gene
  
  pheatmap(mat, cluster_rows = FALSE,  scale= "none",
           color= brewer.pal(n= 9, name= "OrRd") )
}
FV20 <- FV_var[1:20,]
heat_plotter(FV_var)
?pheatmap
#___________________________________________________________________________________________


