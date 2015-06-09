#read in mapping file w/ Centralia contextual data
data=read.table("Centralia_ContextualMap_09june15.txt", header=TRUE, sep="\t")

#remove data we don't want to plot Ars (NAs)
noplotting=c("Richness_SD", "PD_SD", "TimeSinceActivityStart", "TimeSinceRecovered", "OrganicMatter_360", "Iron_ppm", "As_ppm")
data=data[,is.element(colnames(data), noplotting)==FALSE]

#Load R packages
library(ggplot2)
library(reshape2)

#use "melt" from the reshape2 package to make a redundant table for plotting chemistry
data.long=melt(data, id.vars=c("SampleID", "Temperature", "Category", "Activity", "FireFront", "Elick", "Name2"))

#make a gradient color palette
GnYlOrRd=colorRampPalette(colors=c("green", "yellow", "orange","red"), bias=2)


#plot
p=ggplot(data.long, aes(y=as.numeric(Temperature), x=value))+
  
  #add points layer
  geom_point(aes(y=as.numeric(Temperature), x=value, shape=Category,size=1, color=as.numeric(Temperature)))+
  
  #set facet with 4 columns, make x-axes appropriate for each variable
  facet_wrap(~variable, ncol=4, scales="free_x")+ 
  
  #set gradient for temperature and add gradient colorbar
  scale_color_gradientn(colours=GnYlOrRd(20), guide="colorbar")+
  
  #omit the legend for the size of the points
  scale_size(guide=FALSE)+
  
  #define the axis labels
  labs(y="Temperature (Celsius)", x=" ")+
  
  #set a simple theme
  theme_bw()
