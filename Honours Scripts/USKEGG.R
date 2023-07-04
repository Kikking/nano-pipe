seT <- seT[,seT$Stimulation=="unstimulated"]

coldataUS <- coldata[c(1:2 , 5:6),]
seUS <- seT
gseUS <- summarizeToGene(seUS)
gseUS$Cell_Line <- as.factor(gseUS$Cell_Line)



ddsUS <- DESeqDataSet(gseUS, design = ~Cell_Line )
ddsUS <- DESeq(ddsUS)
resultsNames(ddsUS)
resUS <- lfcShrink(ddsUS, coef = "Cell_Line_HNEC_vs_HBEC", type = "apeglm")

resUS <- resUS%>%   data.frame() %>%
  rownames_to_column(var="gene")
resUS <- sym_maker(resUS)
allOE_genes <- as.character(resUS$gene)
sigUN <- dplyr::filter(resUS, padj < 0.05 & log2FoldChange >1 & !is.na(padj))
sigUN_genes <- as.character(sigUN$gene)
sigUB <- dplyr::filter(resUS, padj < 0.05 & log2FoldChange < -1 & !is.na(padj))
sigUB_genes <- as.character(sigUB$gene)

egoUN <- enrichGO(gene = sigUN_genes, 
                  universe = allOE_genes,
                  keyType = "SYMBOL",
                  OrgDb = org.Hs.eg.db, 
                  ont = "BP", 
                  pAdjustMethod = "BH", 
                  qvalueCutoff = 0.05, 
                  readable = TRUE)

egoUB <- enrichGO(gene = sigUB_genes, 
                  universe = allOE_genes,
                  keyType = "SYMBOL",
                  OrgDb = org.Hs.eg.db, 
                  ont = "BP", 
                  pAdjustMethod = "BH", 
                  qvalueCutoff = 0.05, 
                  readable = TRUE)
view(egoUB)
unstimNC <- egoUN[order(egoUN$Count, decreasing = TRUE),]
unstimNC <- unstimNC[c(10,11,16,17,18,19,20,22,23),]
unstimNC$Description <- factor(unstimNC$Description, levels=unique(unstimNC$Description))
ggplot(unstimNC, aes(x = Count, y = Description))+
  geom_col()


unstimBC <- egoUB[order(egoUB$Count, decreasing = TRUE),]
unstimBC <- unstimBC[c(1:10),]
unstimBC$Description <- factor(unstimBC$Description, levels=unique(unstimBC$Description))
view(unstimNC$Description)
ggplot(unstimNC, aes(x = Count, y = Description))+
  geom_col()
barplot(unstimNC, showCategory=10) 
egoUS <- enrichplot::pairwise_termsim(egoUS)
view(egoUB)
view(egoUN)
sigUN_genes <- as.character(sigUN$gene)
USNC<- bitr(sigUN_genes, fromType="SYMBOL",
            toType=("ENTREZID"), OrgDb="org.Hs.eg.db")
USBC<- bitr(sigUB_genes, fromType="SYMBOL",
            toType=("ENTREZID"), OrgDb="org.Hs.eg.db")
kk <- enrichKEGG(gene = USNC$ENTREZID,  organism= "hsa",
                 pvalueCutoff = 1,
                 qvalueCutoff = 1)
kk<- enrichplot::pairwise_termsim(kk)
view(kk)


kkUB <- enrichKEGG(gene = USBC$ENTREZID,  organism= "hsa",
                   pvalueCutoff = 1,
                   qvalueCutoff = 1)
kkUB<- enrichplot::pairwise_termsim(kkUB)
hsa_prot <- pathview(gene.data  = USNC$ENTREZID,
                     pathway.id = "hsa04141",
                     species    = "hsa",
                     kegg.native = FALSE)
knitr::include_graphics("hsa04141.pathview.png")

resS
resUS <- resUS$log2FoldChange
names(resUS) <- resUS$entrez
view(sigUN)
