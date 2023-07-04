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

kegg_osteo <- kegg_lister(kk, "hsa04380")

kegg_nfkb <- kegg_lister(kk,"hsa04064" )
prot_kegg <- kegg_lister(kkB, "hsa04141")
kegg_ppar <- kegg_lister(kk, "hsa03320")
kegg_necropt <- kegg_lister(kk, "hsa04217")
kegg_osteo <- kegg_lister(kk, "hsa04380")
kegg_cyto <- kegg_lister(kk, "hsa04060")

prot_kegg_NC <- kegg_lister(kk, "hsa04141")

upkn <- subset(prot_kegg_NC, !(prot_kegg_NC$SYMBOL %in% prot_kegg$SYMBOL))
fpm_plotter("NFE2L2")
UPR_plotter <- function(sig){
  x <- 0
  for (i in sig){
    x= x + 1
  keggBC <- subset(fBC, fBC$gene %in% i)
  keggNC <- subset(fNC, fNC$gene %in% i)
  
  
  
  keggBC <- keggBC %>% pivot_longer(!gene & !type, names_to = "sample", values_to = "counts")
  keggNC <-keggNC %>% pivot_longer(!gene & !type, names_to = "sample", values_to = "counts")
  
  kegg <- rbind(keggBC, keggNC)
  
 x <-  ggplot(kegg)+
    geom_col(aes(x= sample, y= counts, fill = type),colour = "black",size = 1.2)+
    theme_bw()+
    scale_y_continuous(expand= c(0,0))+
    theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))
  
  }
  grid.arrange(cbind(ggplotGrob(sig[1]), ggplotGrob(sig[2]), size = "last"))
  
}

fold_plotter2(prot_kegg$SYMBOL)


