library("UpSetR")
a<-read.table("scSNV_matrix.txt")
pdf("Intersection_Upset.pdf")
b<-a[,2:(length(a[1,])-1)]
b<-ifelse(b>=1, 1, 0 )
b<-as.data.frame(b)
names<-read.table("Site.list")
colnames(b)<-names$V1
b$depth=a[,length(a)]

upset(b,keep.order=T,order.by="freq",boxplot.summary=c("depth"))
dev.off()

