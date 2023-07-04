
fpm_plotter <- function(sig){
  
  keggBC <- subset(fBC, fBC$gene %in% sig)
  keggNC <- subset(fNC, fNC$gene %in% sig)
  
  
  
  keggBC <- keggBC %>% pivot_longer(!gene & !type, names_to = "sample", values_to = "counts")
  keggNC <-keggNC %>% pivot_longer(!gene & !type, names_to = "sample", values_to = "counts")
  
  kegg <- rbind(keggBC, keggNC)
  kegg$counts[1:2]
  final <- data.frame(type= c("BC", "BC", "NC","NC"),
    counts= c(mean(kegg$counts[1:2]), mean(kegg$counts[3:4]),
                               mean(kegg$counts[5:6]), mean(kegg$counts[7:8])), 
                     sd= c(sd(kegg$counts[1:2]), sd(kegg$counts[3:4]),
                           sd(kegg$counts[5:6]), sd(kegg$counts[7:8])),
    state= c("Unstimulated","Stimulated","Unstimulated","Stimulated"))
  final$state <- factor(final$state, levels=unique(final$state))
  maxxc <- max(final$counts)+0.15*max(final$counts)
  scheme = c("#919190", "#eb6f02","#919190", "#eb6f02")
  
  
  ggplot(final,aes(x= type, y= counts, fill = state))+
    geom_bar(stat= "identity",position= "dodge", colour = "black",size = 1.2)+
    theme_classic()+
    scale_fill_manual(values= scheme)+
    geom_errorbar(aes(ymin=counts- sd, ymax=counts+sd),size = 1.2, width=.2,
                  position=position_dodge(.9))+
    ggtitle(sig) +
    xlab("") + 
    ylab("Counts (FPKM)") +
    scale_y_continuous(expand= c(0,0),limits=c(0,maxxc))+
    theme(axis.text.x = element_text(size= rel(1.25), vjust = 0.5, hjust=1, color= "black", face = "bold"),
          plot.title = element_text(size = rel(1.5), hjust = 0.5,face = "bold"),
          axis.text.y=element_text( color= "black", face = "bold",size= rel(1.1)),
          axis.title.y = element_text( color= "black", face = "bold",vjust = 3),
          legend.title = element_blank(),
          legend.text = element_text( color= "black", face = "bold",size= rel(1.1)),
          axis.line.y = element_line(size = 3, colour = "white", linetype=2),
          panel.grid.major = element_line(colour = "black"),
          panel.grid.major.x = element_blank())
}

fpm_plotter("F2")

dot_plo 
  
   sig = prot_kegg$SYMBOL
  sig = c("DDIT3", "HSPA5", "ERO1B", "EIF2AK3", "PPP1R15A")
  keggBC <- subset(resBC, resBC$gene %in% sig)
  keggNC <- subset(resNC, resNC$gene %in% sig)
  
  kegg <- merge(keggBC, keggNC, by = c("gene"))
  
  kegg <- kegg[order(kegg$log2FoldChange.x, decreasing = TRUE),]
  kegg <- kegg[kegg$baseMean.x > 100,] & kegg$log2FoldChange.x > kegg$log2FoldChange.y & kegg$log2FoldChange.x < 7,]
  kegg$gene <- as.character(kegg$gene)
  
  kegg$gene <- factor(kegg$gene, levels=unique(kegg$gene))
  maxxc <- max(kegg$log2FoldChange.x)+0.15*max(kegg$log2FoldChange.x)
  scheme = c("grey50", "light blue")
  
  ggplot(kegg)+
    geom_col(aes(x= gene, y= log2FoldChange.x),size = 1.2, fill = scheme[2])+
    geom_col(aes(x = gene, y = log2FoldChange.y),fill = scheme[1],size = 1.2)+
    theme_classic()+
    ggtitle("UPR ENRICHMENT") +
    xlab("") + 
    ylab("Log2(Fold Change)")+
    scale_y_continuous(expand= c(0,0),limits=c(0,maxxc))+
    theme( axis.text.x = element_text(angle = 90,size= rel(1.25), vjust = 0.5, hjust=1, color= "black", face = "bold"),
                  plot.title = element_text(size = rel(1.5), hjust = 0.5,face = "bold"),
                  axis.text.y=element_text( color= "black", face = "bold",size= rel(1.1)),
                  axis.title.y = element_text( color= "black", face = "bold",vjust = 3),
                  axis.line.y = element_line(size = 3, colour = "white", linetype=2),
                  panel.grid.major = element_line(colour = "black"),
                  panel.grid.major.x = element_blank())
#PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP

  heat_plotter <- function(FV){
    mat<-  select(FV, gene, log2FoldChange.x, log2FoldChange.y)
    
    mat <- as.matrix(mat[, -1])
    rownames(mat) <- FV$gene
    
    pheatmap(mat, cluster_rows = FALSE,  scale= "none",
             color= brewer.pal(n= 9, name= "OrRd") )
  }
  heat_plotter(kegg)
  FV20 <- FV_var[1:20,]
  heat_plotter(FV_var)
  vol_plotter2(resBC, sig=prot_kegg$SYMBOL)
  vol_plotter2(resBC,sig= kegg$gene)
