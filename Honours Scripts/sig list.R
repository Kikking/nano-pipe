Virus_NC <- egoNC[1:8]
Virus_BC <- egoBC[Virus_NC$ID,]



a <- ""
for (i in Virus_NC$geneID){
  b <- str_split(i, "/")
  for(x in b){
    
    a <- append(a, x) 
  }
}
a <- a[!duplicated(a)]
VNC <- bitr(a, fromType="SYMBOL", toType="ENSEMBL", OrgDb="org.Hs.eg.db")



a <- ""
for (i in Virus_BC$geneID){
  b <- str_split(i, "/")
  for(x in b){
    
    a <- append(a, x) 
  }
}
a <- a[!duplicated(a)]
VBC <- bitr(a, fromType="SYMBOL", toType="ENSEMBL", OrgDb="org.Hs.eg.db")
VBC <- VBC$SYMBOL
VNC <- VNC$SYMBOL
VBC <- VBC[!duplicated(VBC)]
VNC <- VNC[!duplicated(VNC)]
unique_VNC <- subset(VNC, !(VNC %in% VBC))
unique_VBC <- subset(VBC, !(VBC %in% VNC))
VNC[VNC == "PROX1"]
VBC[VBC == "DDX58"]

cnetplot(unique_VNC,
         categorySize="pvalue",
         showCategory = 5,
         foldChange= unique_VNC,
         vertex.label.font=6)
