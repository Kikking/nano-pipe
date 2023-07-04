library(tidyverse)
library(ggplot2)
library(ggthemes)


Salmon_Logs <-  rename(Salmon_Logs, "sample"="Column1")
Salmon_Logs$replicate <- c("Replicate 1", "Replicate 2","Replicate 1", "Replicate 2","Replicate 1", "Replicate 2","Replicate 1", "Replicate 2")
Salmon_Logs$type <- c("Unstimulated BC","Unstimulated BC","Stimulated BC", "Stimulated BC",
                      "Unstimulated NC", "Unstimulated NC", "Stimulated NC","Stimulated NC")
view(Salmon_Logs)
class(Salmon_Logs$Rate) <- "numeric"
#%Mapping Rate

Salmon_Logs%>%
  mutate( Orphan = ((Orphan/Total)*100))%>%
  mutate(Rate = Rate - Orphan)%>%
  pivot_longer(c(Orphan , Rate),
               names_to = "variable", values_to = "v_values")%>%
 # filter(!variable == "Total" & !variable == "Decoy" & !variable =="Dovetail" & !variable == "Score")%>%
ggplot( aes(x = replicate, y = v_values, fill= variable))+
  geom_bar( position = "fill",stat= "identity", 
           width = 0.8,
           colour = "black")+
  facet_wrap(~type)+
  ylab("Mapping Rate (%)")+
  xlab("Sample")+ 
  ggtitle("Mapping Rate per Sample")+
  #scale_y_continuous(expand=c(0,0),breaks = seq(0, 100, by=10), limits=c(0,100)) +
  #scale_fill_manual(" ", values = c("Replicate 1" = "#e6857e", "Replicate 2" = "#7eaaed"))+
  theme_classic()+
  theme(axis.text.x= element_text( colour="black", size="10"),
        axis.text.y= element_text( colour="black", size="10"),
        text = element_text(size = 16),
        plot.title = element_text(hjust = 0.5))

#Proportion of Fragments Discarded


 Salmon_Logs %>%
  pivot_longer((!sample & !Rate & !Orphan & !...1 &!replicate &!type),
               names_to = "variable", values_to = "v_values")%>%
  filter(!variable == "Total")%>%
ggplot( aes(x = replicate , y = v_values,  fill= variable)) + 
  geom_bar(position = "fill", stat = "identity", colour = "black")+
  facet_wrap(~type)+
  theme_fivethirtyeight()+
  ggtitle("Proportion of Fragments Discarded")+
  scale_y_continuous(labels = label_number( scale = 100))+
  scale_fill_discrete(labels=c('Decoy Mapped', 'Dovetail Mapped', 'Poor Alignment Score'))+
  theme(axis.text.x= element_text( colour="black", size="10"),
        axis.text.y= element_text( colour="black", size="10"),
        legend.title = element_blank(),
        legend.text = element_text(colour = "black"),
        text = element_text(size = 16),
        plot.title = element_text(hjust = 0.5))

