# Error Calculation for Mock Community
## Rationale
We sequenced a mock community of *Deinococcus*, *Burkholeria*, *Bacillus*, *Pseudomonas*, *Flavobacterium*, and *Escherichia*. We did so in order to be able to tell what our error rate is and the amount of contamination that might be normal for our samples. Only the mothur pipeline has a method for calculating an error rate based on the Mock community sequencing. This becomes problematic because we do not use the mothur pipeline, but a custom UPARSE pipeline. Since how mothur and UPARSE define OTUs is fundamentally different, it is difficult to discern at what point in the UPARSE pipeline to calculate the error rate of the process. We have decided to calculate error rate in 3 ways.

### Mothur Pipeline Error Rate
Run the raw data through the mothur pipeline, with the exception of using the UPARSE merger instead of the mothur merger, and also not removing the lineages Archaea-Eukaryota-Mitochondria-Chloroplasts-Other. [MiSeq_SOP](http://www.mothur.org/wiki/MiSeq_SOP) ~ 4.9% error rate

Mothur analysis workflow below
```
summary.seqs(fasta=Mock.fasta)
screen.seqs(fasta=current, maxambig=0, maxlength=253)
unique.seqs(fasta=current)
count.seqs(name=Mock.good.names)
pcr.seqs(fasta=silva.bacteria.fasta, start=11894, end=25319, keepdots=F, processors=8)
Rename the pcred silva to silva.v4.fasta
align.seqs(fasta=Mock.good.unique.fasta, reference=silva.v4.fasta)
summary.seqs()
		Start	End	NBases	Ambigs	Polymer	NumSeqs
Minimum:	1	1253	2	0	1	1
2.5%-tile:	1968	11550	252	0	4	1811
25%-tile:	1968	11550	253	0	4	18104
Median: 	1968	11550	253	0	4	36207
75%-tile:	1968	11550	253	0	6	54310
97.5%-tile:	1968	11550	253	0	6	70602
Maximum:	13424	13425	253	0	33	72412
Mean:	1968.6	11549.9	252.956	0	4.69171
# of Seqs:	72412

screen.seqs(start=1968, end=11550, maxhomop=6)
summary.seqs()
		Start	End	NBases	Ambigs	Polymer	NumSeqs
Minimum:	1964	11550	250	0	3	1
2.5%-tile:	1968	11550	253	0	4	1768
25%-tile:	1968	11550	253	0	4	17674
Median: 	1968	11550	253	0	4	35348
75%-tile:	1968	11550	253	0	6	53021
97.5%-tile:	1968	11550	253	0	6	68927
Maximum:	1968	11553	253	0	6	70694
Mean:	1968	11550	252.975	0	4.6199
# of Seqs:	70694

filter.seqs(vertical=T, trump=.)
unique.seqs()
pre.cluster(diffs=2)
count.seqs(fasta=current)
chimera.uchime(fasta=current, count=Mock.good.unique.good.filter.unique.precluster.count_table, dereplicate=t)
remove.seqs(fasta=Mock.good.unique.good.filter.unique.precluster.fasta, accnos=Mock.good.unique.good.filter.unique.precluster.denovo.uchime.accnos)
seq.error(fasta=Mock.good.unique.good.filter.unique.precluster.fasta, reference=Mock_Com_16S_Curated.txt, aligned=F)
```
R Code
```r
setwd("/Users/JSorensen/mothur/Mock_Analysis/")
s <- read.table(file="Mock.good.unique.good.filter.unique.precluster.pick.error.summary", header=T)
ct <- read.table(file="Mock.good.unique.good.filter.unique.precluster.count_table", header=T)
rownames(s) <- s[,1]
rownames(ct) <- ct[,1]
no.chim <- s$numparents==1
s.good <- s[no.chim,]
query <- rownames(s.good)
ct.good <- ct[as.character(query),]
s.good[,1]==ct.good[,1]
sum(ct.good$total * s.good$mismatches)/sum(ct.good$total * s.good$total)
```


### No Crap Error Rate
 Using the UPARSE pipeline, remove any reads from the **merged set** that match 100% to one of the craptaminant OTUs. Resulted in file containing **253257 reads**. Use the resulting sequences to calculate an error rate. ~1.4% error rate.



Mothur Code
```
unique.seqs(fasta=no_crap_Mock_formatted.fa)
seq.error(fasta=no_crap_Mock_formatted.unique.fa, reference=Mock_Com_16S_Curated.txt, aligned=F)
```

R Code
```r
setwd("/Users/JSorensen/mothur/")
s <- read.table(file="no_crap_Mock_formatted.unique.ODB.error.summary", header=T)
ct <- read.table(file="no_crap_Mock_formatted.count_table", header=T)
rownames(s) <- s[,1]
rownames(ct) <- ct[,1]
no.chim <- s$numparents==1
s.good <- s[no.chim,]
query <- rownames(s.good)
ct.good <- ct[as.character(query),]
s.good[,1]==ct.good[,1]
sum(ct.good$total * s.good$mismatches)/sum(ct.good$total * s.good$total)
```

### UPARSE mapped reads Error Rate
Using the UPARSE pipeline, only use sequences from the **denoised dataset** that map to the to non-chimeric OTUs. Resulted in **4365 unique sequences**, representing 187,323 total reads. Led to a ~.6% error rate

UPARSE Code
```bash
/mnt/research/rdp/public/thirdParty/usearch8.1.1831_i86linux64 -usearch_global ../../Shade_WorkingSpace/Centralia_MockCom/denoised.fq -db ../../Shade_WorkingSpace/Centralia_MockCom/mock_denoised_NoChimeraRef_otus.fa -strand plus -id 0.97 -uc map_denoised.uc -otutabout Mock_OTU_table.txt -matched Mapped_Seqs.fasta
module load fastx
fasta_formatter -i Mapped_Seqs.fasta -w 0 -o Mapped_Seqs_Formatted.fasta
cut -d ";" -f 1 Mapped_Seqs_Formatted.fasta > Mapped_ShortNames.fasta
grep ">" Mapped_ShortNames.fasta > Mapped_ShortNames.count
```

Mothur Code
```
seq.error(fasta=Mapped_ShortNames_ODB.fasta, reference= Mock_Com_16S_Curated.txt, aligned=F)
```
RCode
```R
setwd("/Users/JSorensen/mothur/Mock_Analysis_UPARSEMappedReads/")
s <- read.table(file="Mapped_ShortNames_ODB.error.summary", header=T)### read in the result file from seq.error in mothur
ct <- read.table(file="Mapped_ShortNames.count",sep=";", header=F)### read in the fasta headers from the denoised reads from UPARSE that mapped to our OTUs
rownames(s) <- s[,1]
rownames(ct) <- ct[,1]
no.chim <- s$numparents==1## Getting rid of any potential chimeric sequences
s.good <- s[no.chim,]
query <- rownames(s.good)
ct.good <- ct[as.character(query),]
s.good[,1]==ct.good[,1]
sum(ct.good$V2 * s.good$mismatches)/sum(ct.good$V2 * s.good$total)
```

### Conclusions
Mothur pipeline provides the highest error rate of all methods (~4%). Interestingly, the "no crap" error rate was ~ 2X greater than the "mapped reads" error rate.
