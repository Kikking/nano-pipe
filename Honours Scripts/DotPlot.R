exp_plotter <- function(res, p= NA, l2= NA){
  
  if (!is.na(p)){
    up <- res%>%filter(-log10(padj)> p)%>%rownames_to_column(var="gene")
  }
  if (!is.na(l2) & l2 > 0){
    up <- res%>%filter(log2FoldChange > l2)%>%rownames_to_column(var="gene")
  } else if(!is.na(l2) & l2 < 0){
    up <- res%>%filter(log2FoldChange < l2)%>%rownames_to_column(var="gene")
  }
  up <- FV_var
  up_list <- up$gene)
  print(paste0("Number of Genes selected: ",length(up_list)))
  view(up)
  

 gse <- ddsNC
  
  assNC <- assay(gse, "abundance")%>%
    as.data.frame()%>%
    rownames_to_column(var="gene")
  
  
  nclist <- assNC[FV_var$gene,]
  upgenes <- data.frame()
  for (i in up_list){
    uprow<- assNC %>%
      filter(gene == i)
    upgenesNC <- rbind(upgenes,uprow)
  }
  #--------------------------------------------------
  
  
  filt_FV <- FV_var[order(FV_var[,'baseMean.y']), ]
  gse <- ddsNC
  
  assNC <- assay(gse)%>%
    as.data.frame()%>%mutate(type = "NC")%>%
    rownames_to_column(var="gene")
  
  assNC$gene<- sub("[.].*", "", assNC$gene)
  FV_NC <- merge(FV_var, assNC, by= 'gene')
  
  FV_NC <- select(FV_NC,gene,type, SYMBOL, `SRR6365603`, `SRR6365604`, `SRR6365605`, `SRR6365606`)
  FV_NC <- FV_NC%>%
    pivot_longer(!gene & !SYMBOL & !type, names_to = "sample", values_to = "counts")
  
   gse <- ddsBC
  assBC <- assay(gse)%>%
    as.data.frame()%>%mutate(type = "BC")%>%
    rownames_to_column(var="gene")
   
  assBC$gene<- sub("[.].*", "", assBC$gene)
  FV_BC <- merge(FV_var, assBC, by= 'gene')
  FV_BC <- select(FV_BC,gene, type,SYMBOL, SRR6365588, SRR6365589 ,SRR6365590, SRR6365591)
  FV_BC <- FV_BC%>%
    pivot_longer(!gene & !SYMBOL & !type, names_to = "sample", values_to = "counts")

  FV_dot <- rbind(FV_NC, FV_BC)
  FV_dot <- FV_dot[order(FV_dot$SYMBOL), ]
  CXCL <- FV_dot[1:48,]
  IFIT2_3 <- FV_dot[49:64,]
  rest <- FV_dot[65:136,]
  IFIT2_3 %>%
   ggplot(aes(x= SYMBOL, y=counts, colour= sample))+
    geom_point()+
    facet_grid(~type)+
    theme_bw()+
    theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))
  
  
  
  #----------------------------------------------------
  
  view(upgenes)
  upgenes%>%
    pivot_longer(!gene, names_to = "sample", values_to = "counts")%>%
    ggplot(aes(x = gene, y = counts,fill= sample))+
    geom_bar(stat= "identity",position="dodge", color= "black")+
    
    theme_fivethirtyeight()+
    scale_fill_manual("",values = c("pink","red","light green","green"))+
    theme(axis.text.x = element_blank())
}
resFV <- select(FV_var, gene, SYMBOL)
ass_plotter(FV_var)
