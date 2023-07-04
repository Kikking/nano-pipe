






prot_BC <- egoBC[c(1:4,8,13,16:20),]
prot_BC  <- prot_BC[order(prot_BC$Count, decreasing = FALSE),]
prot_BC$Description <- factor(prot_BC$Description, levels=unique(prot_BC$Description))
prot_NC <- egoNC[prot_BC$ID,]
prot_NC$Description <- factor(prot_NC$Description, levels=prot_BC$Description)

view(egoBC$Description)

a <- ""
for (i in prot_BC$geneID){
  b <- str_split(i, "/")
  for(x in b){
    
    a <- append(a, x) 
  }}

prot <- a





p1 <- ggplot(prot_BC, aes(x=toupper( Description), y= Count)) +
  geom_col(fill='purple', color= "black", size=1, ) + 
  theme_bw()+
  coord_flip() + 
  scale_y_reverse(name= "Bronchial",limits= c(40,0),breaks = seq(0, 40, 10), expand= c(0,0) ) + 
  theme(panel.spacing.x = unit(0, "mm"),
        plot.margin = unit(c(5.5, 0, 5.5, 5.5), "pt"),
        panel.border = element_rect(color= "black",linetype = "solid",size= 1.2),
        axis.text.y=element_text( color= "black", face = "bold"), 
        axis.title.y=element_blank())

p2 <- ggplot(prot_NC, aes(x=Description, y= Count)) + 
  geom_col(fill='blue', color= "black", size= 1) + 
  coord_flip() +
  theme_bw() +
  scale_y_continuous(name = "Nasal",limits= c(0,40), breaks = seq(0, 40, 10) ,
                     expand= c(0,0)) +
  theme(axis.title.y=element_blank(), 
        axis.text.y=element_blank(),
        axis.line.y = element_blank(),
        axis.ticks.y=element_blank(),
        plot.margin = unit(c(5.5, 5.5, 5.5, -3.5), "pt"), 
        panel.border = element_rect(color= "black",linetype = "solid", size= 1.2),
        panel.spacing.x = unit(0, "mm"))


grid.arrange(cbind(ggplotGrob(p1), ggplotGrob(p2), size = "last"))
 