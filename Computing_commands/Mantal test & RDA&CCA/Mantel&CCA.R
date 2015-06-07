# vegan module load
library("vegan", lib.loc="~/R/win-library//3.1")

# Read OTU and map table from txt file
otu=read.table("Averaged_OTU_Table_73419even.txt", header=TRUE, row.names=1, sep="\t")
#map=read.table("AlphaDiversity_Avg_Map3.txt", header=TRUE, row.names=1, sep="\t")


#set RDP identifying OTUs later
rdp=otu[,ncol(otu)]

otu=otu[,-ncol(otu)]

#making Bray-Curtis dist matrix from otu table
otu.dist.bc=vegdist(t(otu), method="bray")
print(otu.dist.bc)

#standardize data
map.s=decostand(map, method="standardize")

#make dist matrix for environmental table
map.dist.ec=vegdist(map.s, method="euclidean", na.rm=TRUE)

#make a mantel test
test.m=mantel(otu.dist.bc, map.dist.ec, method="pearson", permutations=999)
test.m

summary(test.m)
plot(test.m)

#perform a bioen
test.b=bioenv(otu.dist.bc, map.s, method="spearman")

#build a CCA ordination, using Environmental factors
ord.ca=cca(t(otu), map.s)
plot(ord.ca)

# Score only display
scores(ord.ca, choices=c(1,2))
ord.scores=scores(ord.ca, choices=c(1,2))

# calculation of internal structure
str(ord.ca)

#extract axis scores (1,2) from CA plot
sites.sc=ord.scores$sites
sites.sc

# correlation between axis 1,2 & environmental factors
e=envfit(ord.ca,map.s)
e
