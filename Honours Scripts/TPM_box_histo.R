se_ab%>%
  mutate(log2(se_ab))%>%
  pivot_longer(colnames(se_ab))%>%
  filter(name == "Stimulated BC1" | name =="Stimulated BC2")%>%
  ggplot((aes(x = value)))+
  facet_grid(rows = vars(name),  labeller = to_string)+
  geom_density(size = 2, colour= "black", size = 0.7, fill = "light grey")+
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
  
  geom_boxplot(colour = "black", fill = "blue")
scale_x_continuous( breaks= seq(-15, 15, by = 5), limits = c(-15, 15))+
  