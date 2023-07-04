
tpm_plotter <- function(sig){
  sig <- toupper(sig)
  
  keggBC <- subset(abBC, abBC$gene %in% sig)
  uBC <- keggBC[c(1,2:3,6)]
  uBC$counts <- rowMeans(uBC[2:3], na.rm=TRUE)
  uBC$SD <- apply(uBC[2:3],1, sd )
  uBC$state <- "Aunstim"
  uBC <- uBC[c(1,4:7)]
  
  sBC <- keggBC[c(1,4:5,6)]
  sBC$counts <- rowMeans(sBC[2:3], na.rm=TRUE)
  sBC$SD <- apply(sBC[2:3],1, sd )
  sBC$state <- "stim"
  sBC <- sBC[c(1,4:7)]
  BC <- rbind(sBC, uBC)
  
  keggNC <- subset(abNC, abNC$gene %in% sig)
  uNC <- keggNC[c(1,2:3,6)]
  uNC$counts <- rowMeans(uNC[2:3], na.rm=TRUE)
  uNC$SD <- apply(uNC[2:3],1, sd )
  uNC$state <- "Aunstim"
  uNC <- uNC[c(1,4:7)]
  
  sNC <- keggNC[c(1,4:5,6)]
  sNC$counts <- rowMeans(sNC[2:3], na.rm=TRUE)
  sNC$SD <- apply(sNC[2:3],1, sd )
  sNC$state <- "stim"
  sNC <- sNC[c(1,4:7)]
  NC <- rbind(sNC, uNC)
  
  final <- rbind(BC,NC)
 # final$state <- factor(final$state, levels=unique(final$state))
  
 
  ggplot(final,aes(x= type, y= counts , fill = gene))+
    geom_bar(stat= "identity",position= "dodge", colour = "black",size = 1.2)+
    facet_grid(~state, labeller =as_labeller(stim_state))+
    theme_classic()+
    geom_errorbar(aes(ymin=counts- SD, ymax=counts+SD),size = 1.2, width=.2,
                  position=position_dodge(.9))+
    #ggtitle(sig) +
    xlab("") + 
    scale_x_discrete(labels=c("BC" = "BEC", "NC" = "NEC"))+
    ylab("Counts (TPM)") +
    scale_fill_manual(values= puror_scheme[2:4])+
    theme(axis.text.x = element_text(size= rel(2), vjust = 0.5, color= "black"),
                                plot.title = element_text(size = rel(1.5), hjust = 0.5,face = "bold"),
                                axis.text.y=element_text( color= "black",size= rel(2)),
                                axis.title.y = element_text ( color= "black", face = "bold",size= rel(1.5)),
                                legend.title = element_blank(),
                                legend.text = element_text( color= "black", face = "bold",size= rel(1.1)),
                                axis.line.y = element_line(size = 3, colour = "white", linetype=2),
                                panel.grid.major = element_line(colour = "black"),
                                strip.background = element_rect(fill= "white",
                                                                color="black", size=1, linetype="solid"), 
                                strip.text = element_text(
                                  size = 16.5, color = "black", face = "bold"),
                                panel.grid.major.x = element_blank())
    #scale_y_continuous(expand= c(0,0),limits=c(0,maxxc))+
 
}
stim_state <-  c(
  `Aunstim` = "Unstimulated",
  `stim` = "Stimulated"
)
tpm_plotter(sig )
sig <- "HSPA5"
sig <- c("ddit3", "ppp1r15a", "xbp1")
bp_theme <- theme(axis.text.x = element_text(size= rel(2), vjust = 0.5, color= "black"),
                  plot.title = element_text(size = rel(1.5), hjust = 0.5,face = "bold"),
                  axis.text.y=element_text( color= "black",size= rel(2)),
                  axis.title.y = element_text ( color= "black", face = "bold",size= rel(1.5)),
                  axis.title.x = element_text( color= "black",size= rel(1.5)),
                  
                  legend.title = element_text( color= "black", face = "bold",vjust = 2.2,size= rel(1.8)),
                  legend.text = element_text( color= "black",size= rel(1.8)),
                  legend.key = element_blank(),
                  strip.background = element_rect(fill= "white",
                                                  color="black", size=1, linetype="solid"), 
                  strip.text = element_text(
                    size = 16.5, color = "black", face = "bold"),
                  #legend.text = element_text( color= "black", face = "bold",size= rel(1.1)),
                  #axis.line.y = element_line(size = 3, colour = "white", linetype=2),
                  #panel.grid.major = element_line(colour = "black"),
                  panel.grid.major.x = element_blank())
theme(axis.text.x = element_text(size= rel(1.25), vjust = 0.5, hjust=1, color= "black", face = "bold"),
      plot.title = element_text(size = rel(1.5), hjust = 0.5,face = "bold"),
      axis.text.y=element_text( color= "black", face = "bold",size= rel(1.1)),
      axis.title.y = element_text( color= "black", face = "bold",vjust = 3),
      legend.title = element_blank(),
      legend.text = element_text( color= "black", face = "bold",size= rel(1.1)),
      axis.line.y = element_line(size = 3, colour = "white", linetype=2),
      panel.grid.major = element_line(colour = "black"),
      panel.grid.major.x = element_blank())

