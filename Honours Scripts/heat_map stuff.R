dds = ddsBC

library("genefilter")
vsd <- vst(dds, blind = FALSE)
topVarGenes <- head(order(rowVars(assay(vsd)), decreasing = TRUE), 20)
sym_maker(vsd)


mat  <- assay(vsd)[ topVarGenes, ]
mat  <- mat - rowMeans(mat)
anno <- as.data.frame(colData(vsd)[, c("cell","dex")])
pheatmap(mat, annotation_col = anno)