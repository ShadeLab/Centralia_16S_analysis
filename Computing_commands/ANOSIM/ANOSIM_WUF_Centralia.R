#load the vegan library
library(vegan)

#read in distance table
data=read.table("WUF_Ceneven73419.txt", header=TRUE, row.names=1)

#read in mapping file
map=read.table("map.txt", header=TRUE)

#designate a vector of activity categories
activity=as.vector(map[,"Activity"])

#designate active and recovered sites
act=activity=="ActiveVent"
rec=activity=="Recovered"
ref=activity=="Reference"
wam=activity=="Warm"

#reduce the dataset and categories vector to only include active and recovered sites
data.AR=data[(act+rec)==1,(act+rec)==1]
activity.AR=activity[((act+rec)==1)]

data.AR1=data[(act+ref)==1,(act+ref)==1]
activity.AR1=activity[((act+ref)==1)]

data.AR2=data[(act+wam)==1,(act+wam)==1]
activity.AR2=activity[((act+wam)==1)]

data.AR3=data[(ref+rec)==1,(ref+rec)==1]
activity.AR3=activity[((ref+rec)==1)]

data.AR4=data[(wam+rec)==1,(wam+rec)==1]
activity.AR3=activity[((wam+rec)==1)]

data.AR5=data[(ref+wam)==1,(ref+wam)==1]
activity.AR3=activity[((ref+wam)==1)]

#tell R that the dataset is a distance object
data.AR.dist=as.dist(data.AR)

data.AR.dist1=as.dist(data.AR1)

data.AR.dist2=as.dist(data.AR2)

data.AR.dist3=as.dist(data.AR3)

data.AR.dist4=as.dist(data.AR4)

data.AR.dist5=as.dist(data.AR5)

#perform an ANOSIM between active and recovered sites
a=anosim(data.AR.dist, grouping=activity.AR)

b=anosim(data.AR.dist1, grouping=activity.AR1)
c=anosim(data.AR.dist2, grouping=activity.AR2)
d=anosim(data.AR.dist3, grouping=activity.AR3)
e=anosim(data.AR.dist4, grouping=activity.AR)
f=anosim(data.AR.dist5, grouping=activity.AR)

#results
a
b
c
d
e
f

summary(a)
summary(b)
summary(c)
summary(d)
summary(e)
summary(f)
