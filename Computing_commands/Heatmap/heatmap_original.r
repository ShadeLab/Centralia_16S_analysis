
library("RColorBrewer")
library("RColorBrewer", lib.loc="~/R/win-library/3.1")
my_palette <- colorRampPalette(c("green", "black", "red"))(n = 299)


# Data table load
phylum=read.csv("AVGED_Subsampling_otu_table_even73419_L2.csv", sep=",")
phylum=read.csv("Phylum_AVG_MERGED.csv", sep=",")
phylum=read.csv("Firmicutes.csv", sep=",")
phylum=read.csv("WUF_Ceneven73419.txt", sep="\t")


# sort by phylogenetic_affiliation.
phylum <- phylum[order(phylum$Phylogenetic_affiliation),]

# prepare data
row.names(phylum) <- phylum$Phylogenetic_affiliation
phylum <- phylum[,2:19]

# prepare data matrix
phylum_matrix <- data.matrix(phylum)

# make heatmap
#phylum_heatmap <- heatmap(phylum_matrix, Rowv=NA, Colv=NA, col = heat.colors(256), scale="column", margins=c(5,10))
#phylum_heatmap <- heatmap(phylum_matrix, col=topo.colors(256), scale="row", key=TRUE, symkey=FALSE, density.info="none", trace="none", cexRow=0.5)

library("gplots")
library("gplots", lib.loc="~/R/win-library/3.1")
phylum_heatmap <- heatmap.2(phylum_matrix, Rowv=NA, col=topo.colors(128), scale="column", key=TRUE, symkey=TRUE, density.info="none", trace="none", cexRow=0.6, margins=c(10,20))
phylum_heatmap <- heatmap.2(phylum_matrix, col=my_palette, scale="row", key=TRUE, symkey=TRUE, density.info="none", trace="none", cexRow=0.4)
