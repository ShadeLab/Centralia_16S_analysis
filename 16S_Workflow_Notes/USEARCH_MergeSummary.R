data=read.table("MergeResults_17nov15.txt", header=TRUE, sep="\t")

library(ggplot2)

#NOTE:  position_jitter is used to avoid jittering on the "y" axis, which would construe the data.
#ANOTHER NOTE:  outliers are plotted TWICE!  Once with the boxplot default, and once with the jitter.  The outliers are identified in RED.
p=ggplot(data, aes(y=as.numeric(Value), x=Descriptor))+
  
  #add points layer
  geom_boxplot(aes(y=as.numeric(Value), x=Descriptor,color=Descriptor), outlier.colour="red")+
  
  geom_point(aes(y=as.numeric(Value), x=Descriptor), position=position_jitter(w=0.25, h=0))+
  
  #set facet with 4 columns, make x-axes appropriate for each variable
  facet_wrap(~Descriptor, ncol=4, scales=c("free"))+
  
  #omit the legend for the size of the points
  scale_color_discrete(guide=FALSE)+
  
  theme(axis.text.x = element_blank())
