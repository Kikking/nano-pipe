coldataS <- coldata[c(3:4 , 7:8),]
seS <- tximeta(coldataS)
gseS <- summarizeToGene(seS)
gseS$Cell_Line <- as.factor(gseS$Cell_Line)

ddsS <- DESeqDataSet(gseS, design = ~Cell_Line )
ddsS <- DESeq(ddsS)
resultsNames(ddsS)
resS <- lfcShrink(ddsS, coef = "Cell_Line_HNEC_vs_HBEC", type = "apeglm")
resS$type<- "BC"
resS <- resS%>%   data.frame() %>%
  rownames_to_column(var="gene")
resS <- sym_maker(resS)
allOE_genes <- as.character(resS$gene)



#egoS <- enrichGO(gene = sigUN_genes, 
                  #universe = allOE_genes,
                 # keyType = "SYMBOL",
                 # OrgDb = org.Hs.eg.db, 
                 # ont = "BP", 
                 # pAdjustMethod = "BH", 
                 # qvalueCutoff = 0.05, 
                  #readable = TRUE)

#egoUS <- enrichplot::pairwise_termsim(egoUS)

sigSN <- dplyr::filter(resS, padj < 0.05 & log2FoldChange >1 & !is.na(padj))
sigSN_genes <- as.character(sigSN$gene)
SNC<- bitr(sigSN_genes, fromType="SYMBOL",
            toType=("ENTREZID"), OrgDb="org.Hs.eg.db")
kkSN <- enrichKEGG(gene = SNC$ENTREZID,  organism= "human", pvalueCutoff = 0.01)
kkSN<- enrichplot::pairwise_termsim(kkSN)
view(kkSN)

sigSB <- dplyr::filter(resS, padj < 0.05 & log2FoldChange < -1 & !is.na(padj))
sigSB_genes <- as.character(sigSB$gene)
SBC<- bitr(sigSB_genes, fromType="SYMBOL",
            toType=("ENTREZID"), OrgDb="org.Hs.eg.db")
kkSB <- enrichKEGG(gene = SBC$ENTREZID,  organism= "human", pvalueCutoff = 0.01)
kkSB<- enrichplot::pairwise_termsim(kkSB)
view(kkSB)
