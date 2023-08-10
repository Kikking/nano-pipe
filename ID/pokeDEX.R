#!/usr/bin/env Rscript

if (!require("BiocManager", quietly = TRUE))
    install.packages("BiocManager")

BiocManager::install("DEXSeq")
library(DEXSeq)

