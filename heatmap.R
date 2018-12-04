library("ggplot2")
library("reshape")
pdf("heatmap.pdf",height=12)
a<-read.table("scSNV_matrix.txt")
name<-read.table("Site.list")
d<-data.matrix(a[,2:length(a[1,]-1])
colnames(d)<-name$V1
d.m<-melt(d)
ggplot(d.m,aes(X2,X1))+geom_tile(aes(fill=log2(value+1)),colour="black")+scale_fill_gradient(low="white",high="steelblue") 

d.m$value<-ifelse(d.m$value> 0, "Yes","No")
ggplot(d.m,aes(X2,X1))+geom_tile(aes(fill=value),colour="black")+scale_fill_manual(values=c("white","steelblue"))  

dev.off()          

