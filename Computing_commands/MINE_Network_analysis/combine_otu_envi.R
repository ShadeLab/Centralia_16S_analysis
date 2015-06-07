env=read.table("Cen_Map_3.txt", header=TRUE, sep="\t", row.names=1)
library(vegan)

#standardize env2 (z-score) and transpose matrix
env2=decostand(env,method="standardize", MARGIN=2)
env2=t(env2)

#reduce the dataset by removing singleton OTUs and complete absences
data=read.table("AVGED_OTU_even73419_L6.txt", header=TRUE, sep="\t", row.names=1)
c=colSums(data)
data.pa=1*data>0
r=rowSums(data.pa)

data.nosigs=data[r>1,]

#append the environ data to the dataframe of otus (no sigs)
combined=rbind(data.nosigs,env2)

write.table(combined, "Cen_OTUs_nosigs_env_L6.txt", sep="\t", quote=FALSE)

