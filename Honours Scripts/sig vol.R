shrunk_resNC <- shrunk_resNC%>% as.data.frame()%>%filter(!is.na(padj))%>%rownames_to_column("gene")
shrunk_resNC$gene<- sub("[.].*", "", shrunk_resNC$gene)
shrunk_resNC$SYMBOL <- bitr(shrunk_resNC$gene, fromType="ENSEMBL", toType="SYMBOL", OrgDb="org.Hs.eg.db")

sig_gene <- resNC[FV_var$gene,]
sig_gene <- sig_gene%>% as.data.frame()%>%filter(!is.na(padj))%>%rownames_to_column("gene")
sig_gene$gene<- sub("[.].*", "", sig_gene$gene)
shrunk_resNC$SYMBOL <- bitr(shrunk_resNC$gene, fromType="ENSEMBL", toType="SYMBOL", OrgDb="org.Hs.eg.db", drop = FALSE)
merge(sig_gene, shrunk_resNC, by= "gene")
vol_plotter(sig_gene)
if (sig_gene$gene %in% sig)
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
  
  if (names(res[8])== "BC"){ type = "Bronchial"}
  else if (names(res[8])== "NC"){type = "Nasal"  }
  res %>% 
    data.frame() %>%
    rownames_to_column(var="gene")%>%
    as_tibble()%>%
    ggplot() +
    geom_point(aes(x = log2FoldChange, y = -log10(padj),col=diffexpressed)) +
    ggtitle(paste0("Stimulated ",type," Cells")) +
    xlab("log2 fold change") + 
    ylab("-log10 adjusted p-value") +
    theme_bw()+
    scale_colour_manual(values= c("#CC6633","#333333","#3399CC"))+
    scale_y_continuous(expand = c(0,0)) +
    theme(legend.position = "",
          plot.title = element_text(size = rel(1.5), hjust = 0.5),
          axis.title = element_text(size = rel(1.25))) 
}





ens <- rownames(shrunk_resNC)

library(org.Hs.eg.db)
symbols <- mapIds(org.Hs.eg.db, keys = shrunk_resNC$gene,
                  column = c('SYMBOL'), keytype = 'ENSEMBL')
symbols <- symbols[!is.na(symbols)]
symbols <- symbols[match(shrunk_resNC$gene, names(symbols))]
shrunk_resNC$gene <- symbols
keep <- !is.na(shrunk_resNC$gene)
mod_NC <- shrunk_resNC[keep,]


mod_NC$sig <- "NO"
sig_gene <- sig_gene$SYMBOL$SYMBOL
mod_NC$sig[mod_NC$gene==sig_gene] <- "UP"
for (x in mod_NC$gene){
for (i in sig_gene){
  
    if ( x == i){
      mod_NC$sig[x] <- "UP"
    }
  }
}
