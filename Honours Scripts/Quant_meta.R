library(readr)
library(tidyverse)
library(ggplot2)
library(ggthemes)
library(tximeta)
library(SummarizedExperiment)
library(egg)
library(DESeq2)
library(apeglm)

salmon_quants <- file.path("E:/Keenan/res/salmon_quants")
dirs <- list.files(salmon_quants)
quant_files <- list.files(salmon_quants ,pattern="quant.sf",recursive = TRUE,full.names = TRUE)
#names(quant_files) <- dirs
view(quant_files)
coldata <- quant_files
se <- tximeta(coldata)


se_ab <- assay(se, "abundance")
type <- c("Unstimulated BC1","Unstimulated BC2","Stimulated BC1", "Stimulated BC2",
             "Unstimulated NC1", "Unstimulated NC2", "Stimulated NC1","Stimulated NC2")
se_ab <- as.data.frame(se_ab)
colnames(se_ab) <- type

to_string <- as_labeller(c(`Stimulated BC1` = "Replicate 1", `Stimulated BC2` = "Replicate 2"))

se_ab%>%
  mutate(log2(se_ab))%>%
  pivot_longer(colnames(se_ab))%>%
  filter(name == "Stimulated BC1" | name =="Stimulated BC2")%>%
   ggplot(aes(x = value))+
  facet_grid(rows = vars(name),  labeller = to_string)+
     geom_histogram(binwidth = 1, colour= "black", size = 0.7, fill = "light grey")+
     theme_bw()+
     scale_y_continuous(expand=c(0,0),breaks = seq(0, 15000, by=3000), limits=c(0,15000)) +
     scale_x_continuous( breaks= seq(-15, 15, by = 5), limits = c(-15, 15))+
     ggtitle('Stimulated BC')+
     ylab("Count")+
     xlab("Log2(TPM)")+
     theme(axis.text.x= element_text( colour="black", size= 12),
           axis.text.y= element_text( colour="black", size=10),
           axis.title.y =  element_text( colour="black", size= 16, face= 'bold'),
           axis.title.x =  element_text( colour="black", size= 14, face= 'bold'),
           text = element_text(colour = "black", size = 12, face = "bold"),
           plot.title = element_text(hjust = 0.5, face = "bold", size = 20),
           strip.background = element_rect(
             color="black", size=1, linetype="solid"), 
           strip.text = element_text(
             size = 13, color = "black", face = "bold"),
           panel.grid.major = element_blank(),
           panel.grid.minor = element_blank(),
           panel.spacing = unit(1.5, "lines"))+
  geom_boxplot()+
  scale_y_continuous( breaks= seq(-15, 15, by = 5), limits = c(-15, 15))+

  theme_classic() +
  xlab("Log2(TPM)")+
  theme(axis.text.y=element_blank(),
        axis.ticks.y=element_blank())
 


histo <- se_ab%>%
  mutate(log2(se_ab))%>%
  pivot_longer(colnames(se_ab))%>%
  filter(name == "Stimulated BC1" )%>%
  ggplot(aes(x = value))+
  facet_grid(rows = vars(name),  labeller = to_string)+
  geom_histogram(binwidth = 1, size = 0.7, fill = "light grey")+
  theme_classic()+
  scale_y_continuous(expand=c(0,3000),breaks = seq(0, 15000, by=3000), limits=c(0,15000)) +
  scale_x_continuous( breaks= seq(-15, 15, by = 5), limits = c(-15, 15))+
  ggtitle('Stimulated BC')+
  ylab("Count")+
  theme(axis.text.x= element_text( colour="black", size= 12),
        axis.text.y= element_text( colour="black", size=10),
        axis.title.y =  element_text( colour="black", size= 16, face= 'bold'),
        axis.title.x =  element_blank(),
        text = element_text(colour = "black", size = 12, face = "bold"),
        plot.title = element_text(hjust = 0.5, face = "bold", size = 20),
        strip.background = element_rect(
          color="black", size=1, linetype="solid"), 
        strip.text = element_text(
          size = 13, color = "black", face = "bold"),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        axis.line.x = element_blank())

boxo <- se_ab%>%
  mutate(log2(se_ab))%>%
  pivot_longer(colnames(se_ab))%>%
  filter(name == "Stimulated BC1" )%>%
  ggplot(aes(x="", y = value))+
  geom_boxplot()+
  scale_y_continuous( breaks= seq(-15, 15, by = 5), limits = c(-15, 15))+
  coord_flip()+
theme_classic() +
  ylab("Log2(TPM)")+
  xlab("")+
  theme(axis.text.y=element_blank(),
        axis.ticks.y=element_blank())


egg::ggarrange(histo, boxo, heights = 2:1)






se <- tximeta(coldata, Sample_Data)
Sample_Data$files <- coldata
coldata <- Sample_Data
coldata$names <- coldata$Run_Accession
se <- tximeta(coldata)

gse <- summarizeToGene(se)

gse$Cell_Line <- as.factor(gse$Cell_Line)
gse$Stimulation <- as.factor(gse$Stimulation)
levels(gse$Stimulation) <- c("stim", "unstim")



#BRONCHIAL DEA
keep <- gse$Cell_Line == "HBEC"
gseBC <- gse[keep,]
nrow(gseBC)


ddsBC <- DESeqDataSet(gseBC, design = ~Stimulation )
ddsBC <- DESeq(ddsBC)
resBC <- results(ddsBC)

#NASAL DEA
keep <- gse$Cell_Line == "HNEC"
gseNC <- gse[keep,]
nrow(gseNC)


ddsNC <- DESeqDataSet(gseNC, design = ~Stimulation )
ddsNC <- DESeq(ddsNC)
resNC <- results(ddsNC)
