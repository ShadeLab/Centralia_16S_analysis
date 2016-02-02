# Mock community analysis
### Ashley Shade, Michigan State University
## 09 Nov 2015
### Problem:  OTU overinflation in Centralia 2014 16S amplicon dataset
* We have ~300,000 OTUs  this is >20X more than we expect
* Previously we used PANDAseq to merge paired end reads with a really high t threshold = 0.9, and then used an [open-reference](http://www.ncbi.nlm.nih.gov/pubmed/25177538) with QIIME's usearch61 to pick OTUs
* There is a [new paper by Edgar](http://bioinformatics.oxfordjournals.org/content/31/21/3476.full) showing that, even with our high t value in PANDAseq, there is a merging of random sequences and a lot of missing of many errors with PANDAseq (errors > 8), especially in among rare taxa.  This paper suggests using a UNOISE pipeline, implemented in usearch8.1 offers a very good alternative.
* the only drawback to this is that we cannot use the open-reference approach to pick OTUs, and will have to pick them de novo in usearch8.1
* ...unless we can do the quality filtering using UNOISE but then move the OTU picking to the QIIME environment
* another thought is that, given the very few OTUs that match the database, we could make a strong case that there is not much information lost in using the de novo approach, BUT then it will make it difficult for us to compare these OTUs with subsequent analyses, which we anticipate because we've already collected another field year's worth of soil.
*  approach:  we're going to use our mock community to ground-truth our merging/quality filtering and OTU picking.  

### Getting started
* Made a new subdirectory for working on HPCC:   `/WorkingSpace/Shade_MockCom`

```
#Copy the file and to working directory
cp ../../Shade/20141230_16Stag_Centralia/20141230_B_16S_PE/Mock_Cmty_TCCTCTGTCGAC_L001_R* .

#unzip copy
gunzip *gz
```

* load usearch
```
module load USEARCH/8.0.1623
```

* Here are the commands provided from the supplementary files of Egar and 2015   

```
#USEARCH/M:   
usearch -fastq_mergepairs fwd.fq -reverse rev.fq -fastqout merged.fq

#USEARCH/F:   
usearch -fastq_filter input.fq -fastq_maxee 1.0 -fastqout filtered.fq

#UNOISE:   
usearch -derep_fulllength reads.fastq -fastqout uniques.fastq -sizeout

usearch -cluster_fast uniques.fastq -centroids_fastq denoised.fq -id 0.9 -maxdiffs 5 \-abskew 10 -sizein -sizeout -sort size
```

## 10 Nov 2015
### Backing up:  Mock community information
* Here is the LabGuru link to Sang-Hoon's construction [notes](https://my.labguru.com/knowledge/projects/81/milestones/261/experiments/1791)
* Mock community contains 6 strains, combined in an even concentration of 100,000 16S copies per uL.

| Strain       | No. 16S copies        |
| ------------- |:-------------:|
| D. radiodurans    | 3 |
| B. thailandensis   | 4 |
| B. cereus   | 13 |
| P. syringae  | 5 |
| F. johnsoniae  | 6 |
| E. coli MG1655  | 8 |

* Data:  Illumina MiSeq 2x150 bp paired-end reads with ~50 bp overlap expected
* HPCC has installed: USEARCH/8.0.1623 - submitted a ticket to update to the latest version (v.8.1.1803 - which seems to have most of the quality filter/merging updates described in the above 2015 paper)

```
#Step 1:  merge paired-end reads

#note: using older version of usearch for now, until HPCC updates
#note maxee value set to 1.0, as default recommended in Edgar and Flyvbjerg 2015.  They recommend informing maxee by the Q value distribution.

[shadeash@dev-intel14 Shade_MockCom]$ usearch -fastq_mergepairs Mock_Cmty_TCCTCTGTCGAC_L001_R1_001.fastq -reverse Mock_Cmty_TCCTCTGTCGAC_L001_R2_001.fastq -fastaout Mock.fa -relabel @ -fastq_merge_maxee 1.0
usearch v8.0.1623_i86linux32, 4.0Gb RAM (264Gb total), 20 cores
(C) Copyright 2013-15 Robert C. Edgar, all rights reserved.
http://drive5.com/usearch

Licensed to: johnj@msu.edu

00:01  70Mb    0.1% Converting
WARNING: Max OMP threads 1

00:14  71Mb  100.0% 78.8% merged

Merged length min 150, lowq 253, median 253, mean 253.0, higq 253, max 284
     Merge length    Reads
-----------------  -------
    150 -     174       97  
    175 -     199       38  
    200 -     224       47  
    225 -     249       80  
    250 -     274   321665  ********************************
    275 -     299       19  

    338399  Pairs
    266811  Converted (78.8%)
    211830  Exact overlaps (62.60%)
     16171  Not aligned (4.78%)
     55050  Exp.errs. too high (max=1.0) (16.27%)
        85  Too many gaps (max=0) (0.03%)
       257  Gaps
    321706  Mismatches
     86887  Fwd errs
    234819  Rev errs
       282  Staggered

WARNING: Option -relabel ignored
```
* Pairs is the total number of read pairs input, and the Converted is the number of "good" merges from those.  The Not aligned, Exp errs too high, and Too many Gaps are the merges that were thrown out.  So, Good merges (Converted) + Bad merges (Not aligned, Exp. errors to high, Too many gaps) =100%  .. almost 99.88% here.  But, the difference is made up by the "Staggered" value - 282 reads.  After reading [this](http://drive5.com/usearch/manual/cmd_fastq_mergepairs.html), seems like staggered is the number of "good" merges that have not-perfect overlap on the forward and reverse ends.
* So: Good merges (Converted + Staggered) + Bad merges (Not alighted, Exp. err too high, too many gaps) = total pairs

* Generally considering these results, it seems that the majority of our reads merged to the length expected, 250-274 bp long.  Though merges outside of these range are noted, there are very few, and, to be conservative, we may want to remove them from the dataset by setting  `-fastq_minmergelen 250` and `-fastq_maxmergelen 274`.  We may also want to remove the "staggered" reads, which can be forced in the new version of usearch (using the `-fastq_nostagger` option).

* I want to test the influence of changing maxee on the merging, the paper uses up to maxee 25 for some tests.  The larger number decreases error sensitivity.

|maxee| Converted| Exp. errs. too high|
| ------------- |:-------------:| :-----:|
| 1| 266811 (78.8%)| 55050 (16.27%)|
|1.5|  290589 (85.9%)| 31272 (9.24%) |
|2| 304567 (90.0%)| 17294 (5.11%)|
|5| 320535 (97%)|  1326 (0.39%)|


* Majority merge length (250-264), Pairs, Exact overlaps, Not aligned, Too many gaps (max=0),  Gaps, Mismatches, Fwd errs, Rev errs, Staggered values are the same across different maxee values.  
* Sweet update!  HPCC *ALREADY* has updated usearch right freakin now.  Sweet sweet sweet.   

```
module load USEARCH/8.1.1803

[shadeash@dev-intel14 Shade_MockCom]$ usearch -fastq_mergepairs Mock_Cmty_TCCTCTGTCGAC_L001_R1_001.fastq -fastqout Mock.fastq -relabel @ \ -fastq_merge_maxee 1.0 -fastq_minmergelen 250 -fastq_maxmergelen 274 -fastq_nostagger

usearch v8.1.1803_i86linux32, 4.0Gb RAM (264Gb total), 20 cores
(C) Copyright 2013-15 Robert C. Edgar, all rights reserved.
http://drive5.com/usearch

Licensed to: billspat@msu.edu

00:00  71Mb    0.1% Converting
WARNING: Max OMP threads 1

00:04  71Mb  100.0% 77.9% merged
    338399  Pairs (338.4k)      
    263722  Merged (263.7k, 77.93%)
    214313  Alignments with zero diffs (63.33%)
     11077  Fwd tails Q <= 2 trimmed (3.27%)
     28693  Rev tails Q <= 2 trimmed (8.48%)
        43  Fwd too short (< 64) after tail trimming (0.01%)
      1194  Rev too short (< 64) after tail trimming (0.35%)
     17710  No alignment found (5.23%)
         0  Alignment too short (< 16) (0.00%)
       260  Merged too short (< 250)
        19  Merged too long (> 274)
     55175  Exp.errs. too high (max=1.0) (16.30%)
       276  Staggered pairs (0.08%) discarded
     46.77  Mean alignment length
    253.00  Mean merged read length
      0.11  Mean fwd expected errors
      0.34  Mean rev expected errors
      0.26  Mean merged expected errors
```

* I used FASTQC to assess the overall quality of the usearch merging   

```
#sanity check - check that the number of merged seqs matches expectations from usearch merge output table (above)

grep -c "@Mock" Mock.fastq
#263722

#load fastqc tools on HPCC
module load fastqc
#FastQC/0.11.3

fastqc Mock.fastq
```

* open new terminal, move fastqc output to desktop to view html summary

```
scp shadeash@hpcc.msu.edu:/mnt/research/ShadeLab/WorkingSpace/Shade_MockCom/Mock_fastqc.html .

open Mock_fastqc.html

#actually looks really great - all Q scores > 32, avg = 37
```

* moving on:  UNOISE algorithm
* using default of d=5, w=10; note that w may be fine-tuned for mock communities as per Edgar and Flyvbjerg 2015

```
#UNOISE  
#step 1:  make a database of all unique sequences
[shadeash@dev-intel14 Shade_MockCom]$ usearch -derep_fulllength Mock.fastq -fastqout uniques_Mock.fastq -sizeout

#output file:  uniques_Mock.fastq


#step 2:  cluster sequences that are likely derived from the same parent
[shadeash@dev-intel14 Shade_MockCom]$ usearch -cluster_fast uniques_Mock.fastq -centroids_fastq denoised.fq -id 0.9 -maxdiffs 5 -abskew 10 -sizein -sizeout -sort size
usearch v8.1.1803_i86linux32, 4.0Gb RAM (264Gb total), 20 cores
(C) Copyright 2013-15 Robert C. Edgar, all rights reserved.
http://drive5.com/usearch

Licensed to: billspat@msu.edu

00:00  82Mb  100.0% Reading uniques_Mock.fastq
00:00  48Mb Pass 1...
WARNING: Max OMP threads 1

74199 seqs (tot.size 263722), 74199 uniques, 55891 singletons (75.3%)
00:00  53Mb Min size 1, median 1, max 36521, avg 3.55
00:00  53Mb  100.0% Writing
00:00  57Mb done.           
00:00  57Mb Sort size... done.
00:16 127Mb  100.0% 33611 clusters, max size 62184, avg 7.8
00:16 127Mb  100.0% Writing centroids to denoised.fq       

      Seqs  74199 (74.2k)
  Clusters  33611 (33.6k)
  Max size  62184 (62.2k)
  Avg size  7.8
  Min size  1
Singletons  24715 (24.7k), 33.3% of seqs, 73.5% of clusters
   Max mem  127Mb
      Time  17.0s
Throughput  4364.6 seqs/sec.

#output file:  denoised.fq
```
* From the above data, there are 33,611 "clusters", when we should have only ~6.
* Removing singleton sequences results in 8,896 clusters
* We could fine-tune w to be smaller... changed w (abskew) from 10 to 1.

```
[shadeash@dev-intel14 Shade_MockCom]$ usearch -cluster_fast uniques_Mock.fastq -centroids_fastq denoised.fq -id 0.9 -maxdiffs 5 -abskew 1 -sizein -sizeout -sort size
usearch v8.1.1803_i86linux32, 4.0Gb RAM (264Gb total), 20 cores
(C) Copyright 2013-15 Robert C. Edgar, all rights reserved.
http://drive5.com/usearch

Licensed to: billspat@msu.edu

00:00  82Mb  100.0% Reading uniques_Mock.fastq
00:00  48Mb Pass 1...
WARNING: Max OMP threads 1

74199 seqs (tot.size 263722), 74199 uniques, 55891 singletons (75.3%)
00:01  53Mb Min size 1, median 1, max 36521, avg 3.55
00:01  53Mb  100.0% Writing
00:01  57Mb done.           
00:01  57Mb Sort size... done.
00:10  93Mb  100.0% 15120 clusters, max size 61999, avg 17.4
00:10  93Mb  100.0% Writing centroids to denoised.fq        

      Seqs  74199 (74.2k)
  Clusters  15120 (15.1k)
  Max size  61999 (62.0k)
  Avg size  17.4
  Min size  1
Singletons  6768, 9.1% of seqs, 44.8% of clusters
   Max mem  93Mb
      Time  9.00s
Throughput  8244.3 seqs/sec.
```
* Indeed, decreasing w also decreases mock community clusters... but tuning this parameter on the mock community is potentially unhelpful for full community OTU picking, as stated in the Edgar and Flyvbjerg 2015 piece.

* taking a step back:  it is strongly recommended that singleton sequences are removed. Where should this happen?  Probably before UNOISE steps to improve computational efficiency.  I used the suggested script from the usearch manual  (here)[http://drive5.com/usearch/manual/singletons.html]

```
[shadeash@dev-intel14 Shade_MockCom]$ usearch -sortbysize uniques_Mock.fastq -fastqout Mock_nosigs.fastq -minsize 2
usearch v8.1.1803_i86linux32, 4.0Gb RAM (264Gb total), 20 cores
(C) Copyright 2013-15 Robert C. Edgar, all rights reserved.
http://drive5.com/usearch

Licensed to: billspat@msu.edu

00:01  82Mb  100.0% Reading uniques_Mock.fastq
00:01  48Mb Getting sizes                     
00:01  49Mb Sorting 18308 sequences
00:01  49Mb  100.0% Writing output
```

* now, will continue with UNOISE step 2 -  to pre-cluster sequences that are likely derived from the same parent

```
[shadeash@dev-intel14 Shade_MockCom]$ usearch -cluster_fast uniques_Mock_nosigs.fastq -centroids_fastq denoised.fq -id 0.9 -maxdiffs 5 -abskew 10 -sizein -sizeout -sort size
usearch v8.1.1803_i86linux32, 4.0Gb RAM (264Gb total), 20 cores
(C) Copyright 2013-15 Robert C. Edgar, all rights reserved.
http://drive5.com/usearch

Licensed to: billspat@msu.edu

00:00  51Mb  100.0% Reading uniques_Mock_nosigs.fastq
00:00  17Mb Pass 1...
WARNING: Max OMP threads 1

18308 seqs (tot.size 207831), 18308 uniques, 0 singletons (0.0%)
00:00  19Mb Min size 2, median 2, max 36521, avg 11.35
00:00  19Mb  100.0% Writing
00:00  23Mb done.           
00:00  23Mb Sort size... done.
00:02  47Mb  100.0% 8898 clusters, max size 56854, avg 23.4
00:02  47Mb  100.0% Writing centroids to denoised.fq       

      Seqs  18308 (18.3k)
  Clusters  8898
  Max size  56854 (56.9k)
  Avg size  23.4
  Min size  2
Singletons  0, 0.0% of seqs, 0.0% of clusters
   Max mem  51Mb
      Time  2.00s
Throughput  9154.0 seqs/sec.

#output files:  denoised.fq
```
* from the above results, we now have ~9K pre-clusters, which is better but still not anywhere close to the ~6 we are ultimately expecting after OTU picking
* where in this pipeline should we check for chimeras?  usually, those are determined during/after OTU picking...which should come next

```
#step 3 - pick OTUs with UPARSE, includes chimera detection

[shadeash@dev-intel14 Shade_MockCom]$ usearch -cluster_otus denoised.fq -otus mock_denoised_otus.fa -relabel OTU_ -sizeout -uparseout results.txt
usearch v8.1.1803_i86linux32, 4.0Gb RAM (264Gb total), 20 cores
(C) Copyright 2013-15 Robert C. Edgar, all rights reserved.
http://drive5.com/usearch

Licensed to: billspat@msu.edu

00:05  52Mb  100.0% 1717 OTUs, 4497 chimeras (50.5%)
#output files: results.txt, mock_denoised_otus.fa
```

* interesting results - we have >1K OTUs (when we should have 6).  However, this is a lot better than what we were doing (previously)[https://github.com/ShadeLab/DataTimeNotes/blob/master/20150429_DataTime_OTUInflationIssues.md].  
* Many chimeras detected - 50%.  This would be really high for a non-mock community, but I'm not sure for this mock community.  
* For the mock community, we can also run an additional ref-uchime chimera detection, though I'm not sure that I would recommend this step for the full dataset because of the novel diversity that we expect.

## 11 Nov 2015
### Continuing with mock community and usearch tools for decreasing OTU inflation
* If we inspect the top of the results file from the otu clustering (uparse algorithm), we see that the top 6 OTUs have the most sequences, and after that we go from OTUs with >12938 sequences to OTUs with <1000 sequences:

```
[shadeash@dev-intel14 Shade_MockCom]$ more results.txt
Mock.16;size=56854;	otu	*	*	OTU_1
Mock.25;size=30282;	otu	70.8	*	OTU_1	OTU_2
Mock.11;size=28182;	otu	80.6	*	OTU_1	OTU_3
Mock.18;size=14434;	otu	76.7	*	OTU_1	OTU_4
Mock.37;size=14008;	otu	89.3	*	OTU_3	OTU_5
Mock.26;size=12938;	otu	87.7	*	OTU_3	OTU_6
Mock.337;size=876;	otu	85.4	*	OTU_6	OTU_7
Mock.182;size=700;	chimera	94.1	100.0	OTU_3(1-149)+OTU_1(150-253)
Mock.1506;size=644;	otu	92.5	*	OTU_7	OTU_8
Mock.1203;size=625;	otu	78.3	*	OTU_2	OTU_9
Mock.706;size=618;	match	97.2	*	OTU_5
Mock.492;size=594;	match	97.2	*	OTU_3
Mock.2004;size=582;	otu	95.3	*	OTU_8	OTU_10
Mock.172;size=579;	chimera	94.1	100.0	OTU_1(1-149)+OTU_3(150-253)
Mock.12;size=570;	match	97.2	*	OTU_6
Mock.1564;size=539;	match	97.2	*	OTU_3
Mock.746;size=400;	chimera	96.4	100.0	OTU_3(1-157)+OTU_5(158-253)
```

* Does this suggest that we should (conservately) omit any OTUs with <1000 sequences?  This is a huge jump from omitting singleton sequences only.
* will try the additional chimera detection using UCHIME with gold reference database, as suggested (here)[http://drive5.com/usearch/manual/uparse_cmds.html]
* another note with the above linked workflow - it suggests re-mapping all reads, including the singleton sequences- to the OTUs, despite that elsewhere it suggests that these reads are errors.
* the "gold" ref db (here)[http://drive5.com/uchime/uchime_download.html] is from 2011, but for our mock community of type strains, it is probably okay.  I would NOT use this ref db for anything other than a mock community of type strains (e.g., not for environmental data) because it is not up to date.  I found a newer "gold" db from (mothur)[http://www.mothur.org/wiki/Silva_reference_files], but the format is for the chimeraslayer algorithm and it is not in the same format as needed for the uchime algorithm (chimeraslayer format includes gaps, misc)
* Generally concerned that not all usearch documentation is updated with each new version - these docs seem to be from usearchv4.

```
module load USEARCH/8.1.1803

# Chimera filtering using reference database
[shadeash@dev-intel14 Shade_MockCom]$ usearch -uchime_ref mock_denoised_otus.fa -db gold.fa -strand plus -nonchimeras mock_denoised_NoChimeraRef_otus.fa
usearch v8.1.1803_i86linux32, 4.0Gb RAM (264Gb total), 20 cores
(C) Copyright 2013-15 Robert C. Edgar, all rights reserved.
http://drive5.com/usearch

Licensed to: billspat@msu.edu

00:00  40Mb  100.0% Reading mock_denoised_otus.fa
00:00  59Mb  100.0% Reading gold.fa              
00:00  26Mb  100.0% Masking        
00:01  26Mb  100.0% Word stats
00:01  26Mb  100.0% Alloc rows
00:03  83Mb  100.0% Build index

WARNING: Max OMP threads 1

00:08  96Mb  100.0% Search 84/1717 chimeras found (4.9%)
00:08  96Mb  100.0% Writing 1633 non-chimeras           
[shadeash@dev-intel14 Shade_MockCom]$

#output files: mock_denoised_NoChimeraRef_otus.fa
```
* Results:  This detected an additional 84 chimeras, but the rest were not flagged. Generally, I don't think this step will be helpful for the full-community analysis, but it is good to know that the uparse chimera detection finds the majority of the chimeras
* the rest of the OTUs  must be either 1.  OTUs comprised of sequences with LOTs of errors or 2. contaminants.  Will run a quick taxonomic assignment to determine whether contaminants are a problem.
* A note:  it looks like the usearch tools have a (reference-based OTU clustering)[http://www.drive5.com/usearch/manual/cmd_cluster_otus_utax.html] called `-cluster_otus_utax`.  We should consider using this step first as our reference-based otus, and then taking the remaining OTUs through de novo clustering, and then combining both sets for the ultimate database for consistent OTU definitions.  However, there seem to be some disagreement between utax and RDP classifier that we should investigate before committing to using utax...
* I downloaded the 250bp 16S utax db (here)[http://www.drive5.com/usearch/manual/utax_downloads.html]

```
usearch -utax mock_denoised_NoChimeraRef_otus.fa -db rdp_16s_trainset15_250.udb -strand both -taxconfs rdp_16s_short.tc -utaxout tax.txt -rdpout mock_denoised_NoChimeraRef_otus_utaxRDP

---Fatal error---
ReadStdioFile failed, attempted 18398164 bytes, read 14503693 bytes, errno=0
```
* Seem to need more memory than what is available on the development nodes, will have to submit a job to figure this out.
* I made a job called exampled.qsub , but it failed with the same error despite allocating 264 Gb memory. Not sure of the problem, but Will move on for now.  UTAX seems to be in beta version on the usearch website?
* Next:  OTU mapping

```
[shadeash@dev-intel10 Shade_MockCom]$  usearch -usearch_global Mock.fastq -db mock_denoised_NoChimeraRef_otus.fa -strand plus -id 0.97 -uc map.uc -otutabout Mock_OTU_table.txt
usearch v8.1.1803_i86linux32, 4.0Gb RAM (24.6Gb total), 8 cores
(C) Copyright 2013-15 Robert C. Edgar, all rights reserved.
http://drive5.com/usearch

Licensed to: billspat@msu.edu

00:00  40Mb  100.0% Reading mock_denoised_NoChimeraRef_otus.fa
00:00 6.7Mb  100.0% Masking                                   
00:00 7.6Mb  100.0% Word stats
00:00 7.6Mb  100.0% Alloc rows
00:00 9.1Mb  100.0% Build index

WARNING: Max OMP threads 1

00:20  44Mb  100.0% Searching, 83.3% matched
219757 / 263722 mapped to OTUs (83.3%)      
00:20  44Mb Writing Mock_OTU_table.txt

#output files: Mock_OTU_table.txt, map.uc
```

* here is the head of the otu map, "map.uc":

```
[shadeash@dev-intel10 Shade_MockCom]$ more map.uc
H	0	253	99.2	+	0	0	253M	Mock.1	OTU_1;size=57978;
H	4	253	99.2	+	0	0	253M	Mock.2	OTU_5;size=15010;
H	0	253	99.2	+	0	0	253M	Mock.3	OTU_1;size=57978;
N	*	253	*	.	*	*	*	Mock.4	*
H	2	253	98.8	+	0	0	253M	Mock.5	OTU_3;size=30059;
H	27	253	100.0	+	0	0	253M	Mock.6	OTU_29;size=188;
N	*	253	*	.	*	*	*	Mock.7	*
H	27	253	98.0	+	0	0	253M	Mock.8	OTU_29;size=188;
H	0	253	98.8	+	0	0	253M	Mock.9	OTU_1;size=57978;
H	3	253	99.2	+	0	0	253M	Mock.10	OTU_4;size=14545;
```
* Results:  we match 83% of sequences to OTU definitions. It seems like HITS to the OTU definitions are given an H at the beginning of the line.
* should we be using our denoised dataset instead of our original?

```
[shadeash@dev-intel10 Shade_MockCom]$ usearch -usearch_global denoised.fq -db mock_denoised_NoChimeraRef_otus.fa -strand plus -id 0.97 -uc map_denoised.uc -otutabout Mock_OTU_table_denoised.txt
usearch v8.1.1803_i86linux32, 4.0Gb RAM (24.6Gb total), 8 cores
(C) Copyright 2013-15 Robert C. Edgar, all rights reserved.
http://drive5.com/usearch

Licensed to: billspat@msu.edu

00:00  40Mb  100.0% Reading mock_denoised_NoChimeraRef_otus.fa
00:00 6.7Mb  100.0% Masking                                   
00:00 7.6Mb  100.0% Word stats
00:00 7.6Mb  100.0% Alloc rows
00:00 9.1Mb  100.0% Build index

WARNING: Max OMP threads 1

00:01  44Mb  100.0% Searching, 49.1% matched
187323 / 207831 mapped to OTUs (90.1%)      
00:01  44Mb Writing Mock_OTU_table_denoised.txt

#output files: Mock_OTU_table_denoised.txt, map_denoised.uc
```
* Here, we decrease our number of reads (because we used the denoised dataset), but we map 90.1% to OTUs (the remaining N's should be the chimeras, which were excluded) from the OTU definitions.  This seems more appropriate - here is the head of the OTU map "map_denoised.uc."

```
H	0	253	100.0	+	0	0	253M	Mock.16;size=56854;	OTU_1;size=57978;
H	1	253	100.0	+	0	0	253M	Mock.25;size=30282;	OTU_2;size=30348;
H	2	253	100.0	+	0	0	253M	Mock.11;size=28182;	OTU_3;size=30059;
H	3	253	100.0	+	0	0	253M	Mock.18;size=14434;	OTU_4;size=14545;
H	4	253	100.0	+	0	0	253M	Mock.37;size=14008;	OTU_5;size=15010;
H	5	253	100.0	+	0	0	253M	Mock.26;size=12938;	OTU_6;size=14217;
H	6	253	100.0	+	0	0	253M	Mock.337;size=876;	OTU_7;size=1005;
```
* Results:  we can see that the top 6 OTUs seem to be the are mock community strains.  Their proportions relative to each other are not as expected (they should be even).
* Wonder if there is a way that we can account for errors to know if, after grouping all the errors from each strain with its parent strain, they would be even.
* In the end, we end up with 1624 OTUs...   

* Okay, back to taxonomy We need to determine if any of these are contaminants.  It seems that the utax algorithm is definitely (in development and not peer-reviewed yet)[http://www.drive5.com/usearch/manual/tax_conf.html].  This makes me worried about using it.  I'll try to submit our sequences to the (RDP Classifier)[http://rdp.cme.msu.edu/classifier/classifier.jsp].  
* Using the recommended 0.5 confidence for short-read sequences
* Found info on command-line RDP Classifier (here)[https://github.com/rdpstaff/classifier]

```
module load RDPClassifier/2.9

java -jar $RDP_JAR_PATH/classifier.jar classify -c 0.5 -o mock_denoised_classified.txt -h mock_hier.txt mock_denoised_NoChimeraRef_otus.fa

#output files: mock_hier.txt, mock_denoised_classified.txt
```
* Results:  Top 6 OTUs are classified as we expect
    * OTU_1;size=57978;		Root	rootrank	1.0	Bacteria	domain	1.0	Firmicutes	phylum	1.0	Bacilli	class	1.0	Bacillales	order	0.98	Bacillaceae 1	family	0.37	Bacillus	genus	0.36

    * OTU_2;size=30348;		Root	rootrank	1.0	Bacteria	domain	1.0	"Bacteroidetes"	phylum	1.0	Flavobacteriia	class	1.0	"Flavobacteriales"	order	1.0	Flavobacteriaceae	family	1.0	Flavobacterium	genus	1.0

    * OTU_3;size=30059;		Root	rootrank	1.0	Bacteria	domain	1.0	"Proteobacteria"	phylum	1.0	Gammaproteobacteria	class	1.0	"Enterobacteriales"	order	1.0	Enterobacteriaceae	family	1.0	Escherichia/Shigella	genus	0.85

    * OTU_4;size=14545;		Root	rootrank	1.0	Bacteria	domain	1.0	"Deinococcus-Thermus"	phylum	1.0	Deinococci	class	1.0	Deinococcales	order	1.0	Deinococcaceae	family	1.0	Deinococcus	genus	1.0

    * OTU_5;size=15010;		Root	rootrank	1.0	Bacteria	domain	1.0	"Proteobacteria"	phylum	1.0	Betaproteobacteria	class	1.0	Burkholderiales	order	1.0	Burkholderiaceae	family	1.0	Burkholderia	genus	1.0

    * OTU_6;size=14217;		Root	rootrank	1.0	Bacteria	domain	1.0	"Proteobacteria"	phylum	1.0	Gammaproteobacteria	class	1.0	Pseudomonadales	order	1.0	Pseudomonadaceae	family	1.0	Pseudomonas	genus	1.0

* What about the rest of the thousands of OTUs?  Generally, they are not  close relatives of these strains. We have 37 different phyla represented in our dataset, and only 4 of those are our mock community strains.

### What to do next?   
1.  We could use the mock community to identify contaminants?   
    - We could use an open-reference approach where we try to hit the "contaminants" database with high confidence (100%), and set-aside and remove any sequences that match the crap database.  We would do this potentially BEFORE matching to a reference database; or we could add this to the end of the OTU picking pipeline
    - we can add a second step of contaminant scrutiny by also using the abundance of that potential contaminant in the mock-community as a way to distinguish "real" contaminants from closely related but real taxa in our samples
    - Should we expect contaminants (e.g., from kit or PCR) to be consistently detected across all samples?  If they are in near-equal abundance, then we have further confidence that they are real contaminants that can be removed.  The paper by (Salter et al. 2014)[http://www.biomedcentral.com/1741-7007/12/87] suggests that even different (identical) DNA extraction kits from the same company can have different contaminants, so perhaps this isn't a good idea after all.  
    -  See (also)[http://www.genomebiology.com/2014/15/12/564]
2.  Eliminate any taxa with less than some sequence abundance cut-off as possible contaminants.
    - For our mock community, taxa with less than <1000 seqs are either really erroneous reads or contaminants. An abudance cut-off of 1000 or less seems really conservative for not-mock samples.
    - Alternatively, we could search for an equivalent "break point" of ranked abundance.  In the mock community, there was a 15-fold decrease in the number of sequences affiliated with real taxa and the number of sequences affiliated with the suspect taxa.
    - should this be considered for each individual sample, or for the dataset as a whole?  It would be more precise to curate each individual sample, but potentially only after considering occurrence patterns across samples to inform spurious results (errors and contaminants).
3.  Generally, the usearch "Denoising" error cloud and dereplicating with chimera-detection worked well to curb (though not eliminate) our OTU inflation problem.  We should test these approaches moving forward.
4.  Denoising/Dealing with the whole dataset - can we inform improved d and w (beyond the default) by our error structure (Q scores) for the whole dataset?
5.  Other thoughts   
    - how to extend usearch to be open reference
    - using the RDP classifier instead of uclust
    - combining the chimera checking with denoising step - could this be done by using the `-cluster_otus` command instead of the `-cluster_fast` one?
```
[shadeash@dev-intel10 Shade_MockCom]$ usearch -cluster_otus uniques_Mock_nosigs.fastq -centroids_fastq denoised_chimera.fq -id 0.9 -maxdiffs 5 -abskew 10 -sizein -sizeout -sort size -otus mock_denoised_chim_otus.fa -relabel OTU_ -uparseout results_chim.txt
usearch v8.1.1803_i86linux32, 4.0Gb RAM (24.6Gb total), 8 cores
(C) Copyright 2013-15 Robert C. Edgar, all rights reserved.
http://drive5.com/usearch

Licensed to: billspat@msu.edu

00:06  54Mb  100.0% 2752 OTUs, 3432 chimeras (18.7%)

WARNING: Option -centroids_fastq ignored


WARNING: Option -sort ignored


WARNING: Option -maxdiffs ignored


WARNING: Option -abskew ignored
```
* Didn't work - will have to cluster OTUs and detect chimeras in separate steps.

### Making a database of craptaminants - contaminants and gross multi-error OTUs remaining after the top 6 type strains are set aside.
* Include all OTUs not among the top 6 - there are 1623 OTUs total, so the remaining 1617 will be the craptaminants db.
* I did this manually by editing (in nano) the mock_denoised_NoChimeraRef_otus.fa to remove the top 6 OTUs' representative sequence (centroid) and leave the remaining ones.  The resulting sequence file is called `mock_craptaminant_OTU_db.fa`.

### Developing usearch workflow for whole community
* A script to automate paired end merging, based on last year's PANDAseq bash (script)[https://github.com/edamame-course/2015-tutorials/blob/master/QIIME_files/Cen_pandaseq_merge.sh]

* Copy all file names to new nano file, and then use grep to output the forward reads into a new file.  (Rename the new file, remove the old.)
* merge_fq_list.txt includes only Centralia fastq names, plus the mock community, totaling 55 file names.  18 samples x 3 reps each = 54, plus mock = 55.
* Making copies of fastq files for merging
* rsync (example)[http://unix.stackexchange.com/questions/41693/how-to-copy-some-but-not-all-files] to exclude extra sequencing files (from Matt Schrenk's group)
```
pwd
>/mnt/research/ShadeLab/WorkingSpace/Shade_MockCom/Merging

rsync -aP --exclude='*SCH*' ../../../Shade/20141230_16Stag_Centralia/20141230_B_16S_PE/* .

rsync -aP ../../../Shade/20141230_16Stag_Centralia/20141230_A_16S_PE/* .

#unzip
gunzip *gz

```


* qsub for merging

```
#! /bin/bash --login
# Time job will take to execute (HH:MM:SS format)
#PBS -l walltime=01:00:00
# Memory needed by the job
#PBS -l mem=264Gb
# Number of shared memory nodes required and the number of processors per node
#PBS -l nodes=1:ppn=8
# Make output and error files the same file
#PBS -j oe
# Send an email when a job is aborted, begins or ends
#PBS -m abe
# Give the job a name
#PBS -N mergereads_12nov15
# _______________________________________________________________________#

cd ${PBS_O_WORKDIR}

#load software
module load USEARCH/8.1.1803

# use usearch -fastq_mergepairs to merge reads - requires name list for FORWARD reads only (file <merge_fq_list.txt>); list file should be located in same directory as this script and the fastq files.

#make an output directory
mkdir mergedfastq

for file in $(<merge_fq_list.txt)
do

    usearch -fastq_mergepairs ${file} -fastqout mergedfastq/${file}_merged.fastq -relabel @ -fastq_merge_maxee 1.0 -fastq_minmergelen 250 -fastq_maxmergelen 274 -fastq_nostagger

done

# _______________________________________________________________________#
# PBS stats
cat ${PBS_NODEFILE}
env | grep PBS
qstat -f ${PBS_JOBID}
```

## 13 Nov 2015
* The qsub script ran but failed on all but 17 samples. I think the reason is because the usearch merging script automatically detects the Illumina "R1" signature in the read names and uses this position to identify the "R2" mate.  Unfortunately, our sample names also include an "R" identified to designate the replicate core.  So, I think the script is confusing this first R with the last Illumina R.  I can either rename our files or designate the reverse reads in the input command.

* first, I cleaned up the working directory to remove extra files
```
find . -type f -name '*.fastq' -delete
```
* I made a new parent directory called Shade_WorkingSpace, and moved the Merging and the Shade_MockCom subdirectories to Shade_Working. Then, I proceeded with the moving, the unzipping, the renaming, and the merge qsubscript.
```
pwd
>/mnt/research/ShadeLab/WorkingSpace/Shade_WorkingSpace/Merging

rsync -aP --exclude='*SCH*' ../../../Shade/20141230_16Stag_Centralia/20141230_B_16S_PE/* .

rsync -aP ../../../Shade/20141230_16Stag_Centralia/20141230_A_16S_PE/* .

#unzip
gunzip *gz

#sanity check: find all files with extension
find . -type f -name '*_L001_R*_001.fastq' | wc -l
>132
#We had some extra samples (11 extra not including Matt Schrenk's, which would be 22 extra F and R fastq's).  We have 55 samples of interest (18 samples * 3 DNA replicates + Mock community), and we have F and R fastq's for both = 110 files, plus the 22 extra = 132.  Sanity check a success!

#Rename files
#rename is a space-delimited file with the FULL old file name first and the new file name second
while read line; do eval mv $line; done < rename.txt

#this returned errors, but the process seemed to work, as samples that files that should have had shortened names do, and files should not, do not.
#Example error
#mv: cannot stat `C18_06102014_RE1_D06_GAGGCTCATCAT_L001_R2_001.fastq': No such file or directory
#After googling, this error may be from "globbing" from wildcard?

#Run merge qsub script
qsub merge.qsub
>output file:
#mergereads_12nov15.o28216219, mergedfastq/
```

* Checking the output file, mergereads_12nov15.o28216219
* the script took less than 5 minutes to run, we can decrease wall time.  it took about 5.5 s. per sample to merge. I reduced to a generous 15 minute wall time for the merge qsub for 55 samples.
* merge_fq_list.txt is a list of FORWARD (R1) file names only (hopefully, this could be *automated* in the future by taking the second column of the rename.txt script, including only the R1 reads)
* output must be in the same order as the list of file names to output
* also revised script to echo ${file} to make it easier to collate the merging data
* also want to write script to *automate* collation of the merging results
* merging results were completely consistent (100% reproducible) across replicate mergings on the same sample.  
* according to results file, fatal errors (no file found) for samples.  These seem to be misnamed on the merge_fq_list.  They should include D07, D08, and D09.
C13D07_TCTAGCGTAGTG_L001_R1_001
C13D08_TCGAGGACTGCA_L001_R1_001
C13D09_CGGAGCTATGGT_L001_R1_001
* actually, the rename file (rename.txt) was off, not the merge_fq_list.
* In the SeqProduction file (A), the names are:
C13_06102014_R2_D07	TCTAGCGTAGTG
C13_06102014_R2_D08	TCGAGGACTGCA
C13_06102014_R2_D09	CGGAGCTATGGT
* In the rename.txt file, the names are:
C13_06102014_R2_D07_TCTAGCGTAGTG_L001_R1_001.fastq  C13D10_TCTAGCGTAGTG_L001_R1_001.fastq
C13_06102014_R2_D08_TCGAGGACTGCA_L001_R1_001.fastq  C13D11_TCGAGGACTGCA_L001_R1_001.fastq
C13_06102014_R2_D09_CGGAGCTATGGT_L001_R1_001.fastq  C13D12_CGGAGCTATGGT_L001_R1_001.fastq
* So, the correct names are 7,8,9 but the switcheroo happened in rename.  I manually edited rename.txt, and will re-run



## 23 Nov 2015
* Continue with merging and assessing the performance of usearch fastq_mergepairs script on our Centralia data

```
qsub merge.qsub
```
* I output the merging stats for every sample from the results file 'mergereads_usearch.o28318404' , and curated it manually for plotting summary statistics in R.  There must be a way to *automate* the extraction of data for each merge into a tab-delimited text format.

* Here are the summary statistics of all 55 merged fastq's (including Mock community)
![img1](Rplot_MergeSummary.tiff)

* There is an outlier sample (in red) that has generally lower merging/ numbers of input pairs.  This sample is:
 C03D02_CTAACCTCCGCT_L001_R1_001     153083  Pairs, 82538 Merged

 * moving forward - remove unmerged fastq from working directory, and then proceed with usearch pipeline for quality filtering and OTU picking

 ```
 #remove un-merged fastq's (specify maxdepth 1 to avoid deleting merged fastq's in the subdirectory)
 find . -type f -name '*.fastq' -delete -maxdepth 1

 #combine together all merged fastq's
 find ./mergedfastq -type f -name '*fastq' -exec cat '{}' > combined_merged.fastq ';'

 #dereplicate
 module load USEARCH/8.1.1803

 usearch -derep_fulllength combined_merged.fastq -fastqout uniques_combined_merged.fastq -sizeout

 #output files: uniques_combined_merged.fastq

 #Remove singletons
 usearch -sortbysize uniques_combined_merged.fastq -fastqout nosigs_uniques_combined_merged.fastq -minsize 2

 #output files:   nosigs_uniques_combined_merged.fastq

 ```

* SNAFU!  The 32-bit version of usearch cannot handle our large data, and the de-replication step returned an error.  We need to try to get an upgrade for the rdp's 64-bit version.

## 24 Nov 2015
* GOOD NEWS!  RDP was able to update their 64-bit version from 7 to 8.1.1831!  
* PATH to RDP usearch:  /mnt/research/rdp/public/thirdParty/usearch8.1.1831_i86linux64

```
#De-replicate merged reads
[shadeash@dev-intel14 Merging]$ /mnt/research/rdp/public/thirdParty/usearch8.1.1831_i86linux64 -derep_fulllength combined_merged.fastq -fastqout uniques_combined_merged.fastq -sizeout

usearch v8.1.1831_i86linux64, 264Gb RAM, 20 cores
(C) Copyright 2013-15 Robert C. Edgar, all rights reserved.
http://drive5.com/usearch

Licensed to: colej@msu.edu

02:54 6.7Gb  100.0% Reading combined_merged.fastq

WARNING: Max OMP threads 1

03:11 7.3Gb 10995193 seqs, 5256753 uniques, 4439743 singletons (84.5%)
03:11 7.3Gb Min size 1, median 1, max 105735, avg 2.09
03:24 7.2Gb  100.0% Writing uniques_combined_merged.fastq

##output files: uniques_combined_merged.fastq


#Remove single sequences
[shadeash@dev-intel14 Merging]$ /mnt/research/rdp/public/thirdParty/usearch8.1.1831_i86linux64 -sortbysize uniques_combined_merged.fastq -fastqout nosigs_uniques_combined_merged.fastq -minsize 2

usearch v8.1.1831_i86linux64, 264Gb RAM, 20 cores
(C) Copyright 2013-15 Robert C. Edgar, all rights reserved.
http://drive5.com/usearch

Licensed to: colej@msu.edu

00:36 3.2Gb  100.0% Reading uniques_combined_merged.fastq
00:36 3.2Gb Getting sizes                                
00:42 3.2Gb Sorting 817010 sequences
00:43 3.2Gb  100.0% Writing output

##output file:   nosigs_uniques_combined_merged.fastq


#Pre-cluster (denoise)
[shadeash@dev-intel14 Merging]$ /mnt/research/rdp/public/thirdParty/usearch8.1.1831_i86linux64 -cluster_fast nosigs_uniques_combined_merged.fastq -centroids_fastq denoised_nosigs_uniques_combined_merged.fastq -id 0.9 -maxdiffs 5 -abskew 10 -sizein -sizeout -sort size
usearch v8.1.1831_i86linux64, 264Gb RAM, 20 cores
(C) Copyright 2013-15 Robert C. Edgar, all rights reserved.
http://drive5.com/usearch

Licensed to: colej@msu.edu

00:03 537Mb  100.0% Reading nosigs_uniques_combined_merged.fastq
00:03 503Mb Pass 1...
WARNING: Max OMP threads 1

817010 seqs (tot.size 6555450), 817010 uniques, 0 singletons (0.0%)
00:05 561Mb Min size 2, median 2, max 105735, avg 8.02
00:06 581Mb done.
00:07 587Mb Sort size... done.
57:35 1.2Gb  100.0% 309956 clusters, max size 196850, avg 21.14
57:35 1.2Gb    0.0% Writing centroids to denoised_nosigs_uniques_combined_merged57:36 1.2Gb   23.1% Writing centroids to denoised_nosigs_uniques_combined_merged57:36 1.2Gb  100.0% Writing centroids to denoised_nosigs_uniques_combined_merged.fastq

      Seqs  817010 (817.0k)
  Clusters  309956 (310.0k)
  Max size  196850 (196.8k)
  Avg size  21.1
  Min size  2
Singletons  0, 0.0% of seqs, 0.0% of clusters
   Max mem  1.2Gb
      Time  57:32
Throughput  236.7 seqs/sec.

##output file: denoised_nosigs_uniques_combined_merged.fastq

#Closed-reference OTU picking to eliminate OTUs that match exactly to the craptaminant database
/mnt/research/rdp/public/thirdParty/usearch8.1.1831_i86linux64 -search_exact denoised_nosigs_uniques_combined_merged.fastq -db mock_craptaminant_OTU_db.fa -notmatchedfq nocrap_denoised_nosigs_uniques_combined_merged.fastq -strand plus -matchedfq craptaminantSeqs_denoised_nosigs_uniques_combined_merged.fastq

#output files: craptaminantSeqs_denoised_nosigs_uniques_combined_merged.fastq, nocrap_denoised_nosigs_uniques_combined_merged.fastq

grep -c @ craptaminantSeqs_denoised_nosigs_uniques_combined_merged.fastq
>1391
```

* there were 1391 denoised sequences that had perfect matches to our craptaminant database.  We can move forward omitting these.

```
grep -c @ nocrap_denoised_nosigs_uniques_combined_merged.fastq
308598
```
* there were 308598 denoised sequences that remained for analysis.

## 30 November 2015
### Getting a database for the reference-based OTU picking
* downloaded the 13.8 greengenes database from the [qiime resources paged](http://qiime.org/home_static/dataFiles.html) and transferred to ShadeLab working space:

```
scp gg_13_8_otus.tar.gz shadeash@hpcc.msu.edu:/mnt/research/ShadeLab/WorkingSpace/Shade_WorkingSpace/Merging
```
* unzip db onto HPCC

```
tar -zxvf gg_13_8_otus.tar.gz
```

### Open reference OTU picking step 1
* test the script: Match to the best database we've got, but save those clusters that do not hit

```
/mnt/research/rdp/public/thirdParty/usearch8.1.1831_i86linux64 -usearch_global nocrap_denoised_nosigs_uniques_combined_merged.fastq -id 0.97 -relabel refOTU_ -sizeout -uparseout ref_otu_results.txt -db gg_13_8_otus/rep_set/97_otus.fasta -notmatchedfq RefNoMatch_nocrap_denoised_nosigs_uniques_combined_merged.fastq -centroids RefMatchedCentroids_nocrap_denoised_nosigs_uniques_combined_merged.fasta -strand plus
```
* submitted a qsub for the above script

```
grep -c @ RefNoMatch_nocrap_denoised_nosigs_uniques_combined_merged.fastq
254447
```

* based on output file, the following options are void with usearch_global:
```
WARNING: Option -centroids ignored


WARNING: Option -relabel ignored


WARNING: Option -uparseout ignored


WARNING: Option -sizeout ignored

# revised the command, as below

/mnt/research/rdp/public/thirdParty/usearch8.1.1831_i86linux64 -usearch_global nocrap_denoised_nosigs_uniques_combined_merged.fastq -id 0.97 -db gg_13_8_otus/rep_set/97_otus.fasta -notmatchedfq RefNoMatch_nocrap_denoised_nosigs_uniques_combined_merged.fastq -strand plus -uc RefMatch_nocrap_denoised_nosigs_uniques_combined_merged.txt -matchedfq RefMatch_nocrap_denoised_nosigs_uniques_combined_merged.fastq

##Results - sequences in each - hitting the database and not
[shadeash@dev-intel10 Merging]$ grep -c @ RefMatch_nocrap_denoised_nosigs_uniques_combined_merged.fastq
54151
[shadeash@dev-intel10 Merging]$ grep -c @ RefNoMatch_nocrap_denoised_nosigs_uniques_combined_merged.fastq
254447

# Try again, this time with the OTU table write-out (it is so hard to find out all of the options for these scripts from the usearch manual)
/mnt/research/rdp/public/thirdParty/usearch8.1.1831_i86linux64 -usearch_global nocrap_denoised_nosigs_uniques_combined_merged.fastq -id 0.97 -db gg_13_8_otus/rep_set/97_otus.fasta -notmatchedfq RefNoMatch_nocrap_denoised_nosigs_uniques_combined_merged.fastq -strand plus -uc RefMatch_nocrap_denoised_nosigs_uniques_combined_merged.txt -matchedfq RefMatch_nocrap_denoised_nosigs_uniques_combined_merged.fastq -otutabout RefMatchOTUs_nocrap_denoised_nosigs_uniques_combined_merged.txt


wc -l RefMatchOTus_nocrap_denoised_nosigs_uniques_combined_merged.txt
9145 RefMatchOTus_nocrap_denoised_nosigs_uniques_combined_merged.txt
```
* usearch_global against greengenes took less than 15 minutes to execute
* we have 9,145 OTUs with 97% identity to the greengenes reference database v 13.8
* perhaps we don't really need the OTU table back at this point, since we are using dereplicated sequences... if so, omit the -otutaout option

```
/mnt/research/rdp/public/thirdParty/usearch8.1.1831_i86linux64 -cluster_otus RefNoMatch_nocrap_denoised_nosigs_uniques_combined_merged.fastq -minsize 2 -otus DeNovoUclustOTUs_RefNoMatch_nocrap_denoised_nosigs_uniques_combined_merged.fa -relabel OTU_dn_ -sizeout -uparseout DeNovoUclustResults_RefNoMatch_nocrap_denoised_nosigs_uniques_combined_merged.up
```
* there were 195,358 chimeras detected
* realized I should have output the .fa instead of the fastq file for the uclust_global against the gg db. back to usearch_global
```
/mnt/research/rdp/public/thirdParty/usearch8.1.1831_i86linux64 -usearch_global nocrap_denoised_nosigs_uniques_combined_merged.fastq -id 0.97 -db gg_13_8_otus/rep_set/97_otus.fasta -notmatchedfq RefNoMatch_nocrap_denoised_nosigs_uniques_combined_merged.fastq -strand plus -uc RefMatchOTUMap_nocrap_denoised_nosigs_uniques_combined_merged.uc -matched RefMatch_nocrap_denoised_nosigs_uniques_combined_merged.fa -otutabout RefMatchOTUTab_nocrap_denoised_nosigs_uniques_combined_merged.txt

# combine the representative OTUs from the reference-based and de novo clustering
cat eNovoUclustOTUs_RefNoMatch_nocrap_denoised_nosigs_uniques_combined_merged.fa RefMatch_nocrap_denoised_nosigs_uniques_combined_merged.fa > MASTER_RepSeqs.fa
```
* there are, in total 75,071 representative sequences = 75,071 OTUs? 54,148 from the reference-based, and 20,923 from the de novo.
* now, onto matching the original merged reads (including errors and singletons, which could be "counted" if they cluster at 97% to our OTUs) using usearch_global

```
/mnt/research/rdp/public/thirdParty/usearch8.1.1831_i86linux64 -usearch_global combined_merged.fastq -db MASTER_RepSeqs.fa  -strand plus -id 0.97 -uc MASTER_OTU_map.uc -otutabout MASTER_OTU_table.txt
```
* the job took 1.5 hrs to run (walltime)
* seems that the OTU table contains 64,667 OTUs.  This is still relatively high, but much fewer than the previous ~300,000 we were getting before the quality filtering.  This also ~10K fewer than the 75,071 - where did those OTUs go?  
* notes from this usearch manual [page](http://www.drive5.com/usearch/manual/termination_options.html).  the usearch_global (used for reference db matching and, ultimately, for mapping reads) default options for maxaccepts and maxrejects is 1 and 32, respectively, and for cluster_fast (used for "denoising") it is 1 and 8.
* One nomenclature problem is that the ref-based OTUs have the name of the seq/sample instead of the gg ID.  Need to figure that out.  What if when we run usearch_global against the gg db, we return the db matches instead of the dataset matches by setting the -dbmatched options, and THEN combining it with the de novo options?  That should have consistent nomenclature across datasets.  We don't actually need our matches from our dataset - we need the non-matches from our dataset (to move forward to de novo clustering) and the db matches to combine with the de-novos.

```
cat gg_97_rep_set_matched.fa DeNovoUclustOTUs_RefNoMatch_nocrap_denoised_nosigs_uniques_combined_merged.fa > MASTER_RepSeqs.fa

/mnt/research/rdp/public/thirdParty/usearch8.1.1831_i86linux64 -usearch_global nocrap_denoised_nosigs_uniques_combined_merged.fastq -id 0.97 -db gg_13_8_otus/rep_set/97_otus.fasta -notmatchedfq RefNoMatch_nocrap_denoised_nosigs_uniques_combined_merged.fastq -strand plus -uc RefMatchOTUMap_nocrap_denoised_nosigs_uniques_combined_merged.uc -dbmatched gg_97_rep_set_matched.fa
```

* also, can I use an alias on the HPCC, within a script?  let's find out...YES

```
alias usearch='/mnt/research/rdp/public/thirdParty/usearch8.1.1831_i86linux64'
```

### 02 Dec 2015
* Re-ran the OTU mapping with the gg/de_novo database
*  Results:  30K sequences - this makes quite a bigger difference in reducing the OTUs because it uses longer sequences from the gg db as the reference rather than the dataset (duh) which is more appropriate/ correct.  We have ~30K OTUs, which is more in line with what we should expect from the literature
```
[shadeash@dev-intel14 Merging]$ wc -l MASTER_OTU_table.txt
29958 MASTER_OTU_table.txt

grep -c "^>" MASTER_RepSeqs.fa
30067
```
* Now, it is time to start with a clean slate, re-run the analysis, and reproduce the results, starting from the work with the full dataset.

### 03 Dec 2015
* results from the second run (with file management revisions in the beginning for batch scripting) of the workflow:
* 30056 OTUs in the MASTER_RepSeqs.fa file: 9144 gg OTUs + 20912 de novo OTUs
* 29946 rows in the OTU table.  Perhaps ultimate singleton sequences are by default omitted?  Not sure why the discrepancy between the .fa db and the actual OTU table rows.
* 194543 chimera sequences detected in the de novo clustering:

```
grep -c "chimera" DeNovoUclustResults_RefNoMatch_nocrap_denoised_nosigs_uniques_combined_merged.up
194543
```
* These results seem quite reasonable as far as expected OTU numbers.  Now, to assign taxonomy to the rep sequences, and try the whole script from scratch.

```
module load RDPClassifier/2.9

java -jar $RDP_JAR_PATH/classifier.jar classify -c 0.5 -o MASTER_OTU_classified.txt -h otu_hier.txt MASTER_RepSeqs.fa
```
* note:  the classifier confidence option '-c' default is 0.8, but we are using 0.5.  Perhaps this will improve putative assignments?  anyway, we have to be careful about assignments with confidence < 0.8.
* okay, now will try to run the entire batch script from merging to assigning taxonomy, w/ first estimate of 6 hr wall time w/ 264 Gb and 8 ppn
* note about taxonomy - using the RDP classifier with the RDP database may not be awesome.  there is also the greengenes (gg_13_8_otus/taxonomy/97_otu_taxonomy.txt) file that we can use for the gg assignments.  What, then, do we use for the de novo assignemnts?  The best hit ot the gg database may be okay.

### 04 Jan 2016
* Try the RDP classified with higher confidence score by changing -c 0.5 to -c 0.8

```
module load RDPClassifier/2.9

java -jar $RDP_JAR_PATH/classifier.jar classify -c 0.8 -o MASTER_OTU_classified.txt -h otu_hier_c8.txt MASTER_RepSeqs.fa
```

* maybe we can re-train classifier independently?
* this is a multi-step process, tutorial is not straightforward...QIIME already has a built-in workflow for classifier re-training, and maybe we can move into qiime and use that instead of piece-meal re-training the Classifier
```
module load RDPClassifier/2.9

java -jar $RDP_JAR_PATH/classifier.jar classify -c 0.8 -o MASTER_OTU_classified.txt -h otu_hier_gg_c8.txt -h /mnt/research/ShadeLab/WorkingSpace/gg_13_8_otus/taxonomy/97_otu_taxonomy.txt -t /mnt/research/ShadeLab/WorkingSpace/gg_13_8_otus/rep_set/97_otus.fasta MASTER_RepSeqs.fa

```


* Can we move into QIIME from this step?  The HPCC has downgraded QIIME from 1.9.0 to 1.8.0, which is okay for our classification purposes
* --id_to_taxonomy_fp is designated by -t
* --reference_seqs_fp is designated by -r
* export 2.2 (older version, default with QIIME) OR 2.9 - try to use 2.9
* this works!
```
module load QIIME/1.8.0

#export path to Classifier 2.2
export RDP_JAR_PATH=/opt/software/QIIME/1.8.0--GCC-4.4.5/rdpclassifier-2.2-release/rdp_classifier-2.2.jar

#export path to Classifier 2.9
export RDP_JAR_PATH=/opt/software/RDPClassifier/2.9/dist/rdp_classifier-2.9.jar


#use QIIME to assign taxonomy
assign_taxonomy.py -i MASTER_RepSeqs.fa -m rdp -c 0.8 -t /mnt/research/ShadeLab/WorkingSpace/gg_13_8_otus/taxonomy/97_otu_taxonomy.txt -r /mnt/research/ShadeLab/WorkingSpace/gg_13_8_otus/rep_set/97_otus.fasta
```
* Add QIIME header to taxonomy file and append the taxonomy metadata to .biom file

```
echo "#OTUID"$'\t'"taxonomy"$'\t'"confidence" > templine.txt

cat  templine.txt rdp_assigned_taxonomy/MASTER_RepSeqs_tax_assignments.txt >> rdp_assigned_taxonomy/MASTER_RepSeqs_tax_assignments_header.txt

biom add-metadata -i MASTER_OTU_bm.biom -o MASTER_OTU_bm_rdp.biom --observation-metadata-fp rdp_assigned_taxonomy/MASTER_RepSeqs_tax_assignments_header.txt

rm templine.txt
```
* here:  insert other metadata to the .biom file (?)

* Moving on to the fun part?  Diversity and ecological analyses

```
mkdir mkdir QIIME_1_8_0/

biom summarize_table -i MASTER_OTU_bm_rdp.biom -o QIIME_1_8_0/summary_MASTER_OTU_bm_rdp.txt

cd QIIME_1_8_0/
more summary_MASTER_OTU_bm_rdp.txt

Num samples: 54
Num observations: 9144
Total count: 5673035
Table density (fraction of non-zero values): 0.312
Table md5 (unzipped): f290dae037cb0687eea2ceefe21f4f77

Counts/sample summary:
 Min: 40810.0
 Max: 215801.0
 Median: 105780.000
 Mean: 105056.204
 Std. dev.: 26750.447
 Sample Metadata Categories: None provided
 Observation Metadata Categories: taxonomy; confidence
```

```
 cd ..

 single_rarefaction.py -i MASTER_OTU_bm_rdp.biom -o QIIME_1_8_0/MASTER_OTU_bm_rdp_even40810.biom -d 40810

 biom summarize_table -i QIIME_1_8_0/MASTER_OTU_bm_rdp_even40810.biom -o QIIME_1_8_0/summary_MASTER_OTU_bm_rdp_even40810.txt
 ```
 * Problem:  the mock community still has a lot of sequences in it (215,801 sequences)?  This means that the sequences in the mock community were very similar to the sequences in the actual dataset, after removing craptaminants?  Keep this in mind, and check the number of OTUs that are ultimately assigned to this community.  It should be tens.

 * Next steps:  
 1.  subsample to understand variability between DNA extraction replicates
 2.  collapse and subsample to move forward with analysis

 * Another problem -where did sample C01D01 go?  did we lose it in re-naming?  We have only 54 samples, and with the mock we should have 55...?  Opps - the sample ID was accidentally truncated in the merge_fq_list.txt file.  This means that we have to run the whole analysis again with the corrected file.  Will correct and re-run the qsub tonight.  

 ### 06 Jan 2016
 * Error message returned on classifier 2.9 when running batch qsub:
* No error when running classifier 2.2 - what is going on?
```
 File
 "/opt/software/QIIME/1.8.0--GCC-4.4.5/lib/python2.7/site-packages/qiime/pycogent_backports/rdp_classifier.py", line 509, in train_rdp_classifier_and_assign_taxonomy
  tmp_dir=tmp_dir)
File "/opt/software/QIIME/1.8.0--GCC-4.4.5/lib/python2.7/site-packages/qiime/pycogent_backports/rdp_classifier.py", line 479, in train_rdp_classifier
  return app(training_seqs_file)
File "/opt/software/QIIME/1.8.0--GCC-4.4.5/lib/python2.7/site-packages/qiime/pycogent_backports/rdp_classifier.py", line 339, in __call__
  raise ApplicationError(exception_msg + stderr_msg)
cogent.app.util.ApplicationError: Training output file "/tmp/RdpTrainer_GBBHTo/bergeyTrainingTree.xml" not found.  This may happen if an error occurred during the RDP training process.  More details may be available in the standard error, printed below.
```
### 21 January 2016
* Contributions from Sang-Hoon Lee
* Compare the Silva Alignment version 111 (97_Silva_111_rep_set.fasta) to the GreeneGenes 97% sequence identity alignment for pynast aligner in QIIME 1.8.0.  The Silva Alignment is supposed to be higher quality than the greengenes alignment.  Note that this is an older version of the aligner and Sang-Hoon doesn't remember where he downloaded it from.  The most recent version is v.123, and I would like to use that moving forward.
*  Both alignments have comparable results as far as failures.  For the Silva alignment, 6 GG reference OTUs (full length) fail, and ~1800 de novo OTUs.  For the greenegenes alignment, no GG reference OTUs, but ~1800 de novo OTU failures, similar to the Silva.  I would like to use the Silva alignment because it is higher quality and the results are comparable.
*  We will filter these alignment failures from the MASTER rep set of sequences and from the BIOM table before proceeding.
*  We got the newest Silva alignment from the mothur website: http://mothur.org/wiki/Silva_reference_files, and it is here on the HPCC

```
/mnt/research/ShadeLab/WorkingSpace/Silva_v123_referencefiles
```
* Note that QIIME 1.8.0 will [no longer be supported after Jan 2016](https://qiime.wordpress.com/2015/10/30/toward-qiime-2/), only 1.9.1 from here on out.  We've used anaconda on the HPCC to install python2 packages so that we can use QIIME 1.9.0, which will continue to be supported for a bit.

### 27 January 2016
* Moving onward! I started a job to compare the results between removing "craptaminant" OTUs and not
* Back to the problem of qiime and alignment failures and version problems and problems with adding assigned taxonomy to the biom table format   
  *  We removed the usearch option to include OTU size at the cluster_otus step, which alleviated some downstream formatting challenges
  *  We now have access to qiime 1.9.1, which also is supposed to play nicely with classifier 2.9.  I can't get this to work, but I can get it to use the qiime default classifier 2.2.
  *  I started one alignment job using QIIME 1.8.0 and the exact same job with QIIME 1.9.1 and the anaconda wrapper.  The point of this is just to see if we can get QIIME 1.9.1 into our pipeline.


```
#Alignment with QIIME 1.8.0
module load QIIME/1.8.0

align_seqs.py -i MASTER_RepSeqs.fa -t /mnt/research/ShadeLab/WorkingSpace/Silva_v123_referencefiles/silva.nr_v123.align


#Alignment with QIIME 1.9.1
source /mnt/research/ShadeLab/software/loadanaconda2.sh

align_seqs.py -i MASTER_RepSeqs.fa -t /mnt/research/ShadeLab/WorkingSpace/Silva_v123_referencefiles/silva.nr_v123.align -o qiime1.9.1_pynast_aligned/
```
* the qiime 1.9.1 pynast alignment to the Silva123 template failed.
* the qiime 1.8.0 pynast alignment to the Silva 123 template failed.  I think the Silva123 template is the problem (Sang-Hoon got it from mothur, and I think the formatting is off), and I have gotten a different one from the QIIME forum.  I will move this to the HPCC and start again.  It's PATH is here:

```
/mnt/research/ShadeLab/SharedResources/SILVA123_QIIME_release/core_alignment/core_alignment_SILVA123.fasta
```


* The rdp classification within qiime 1.9.1 using rdp 2.9 to the greengenes reference failed.  I thnk the problem is that QIIME 1.9.1 cannot find the RDP 2.9.

* now, we need to figure out how to make a biom table from our usearch pieces.  We need an OTU map

```
module load QIIME/1.8.0

align_seqs.py -i MASTER_RepSeqs.fa -t /mnt/research/ShadeLab/SharedResources/SILVA123_QIIME_release/core_alignment/core_alignment_SILVA123.fasta -o qiime189_pynast_silva123/


#Alignment with QIIME 1.9.1
source /mnt/research/ShadeLab/software/loadanaconda2.sh

align_seqs.py -i MASTER_RepSeqs.fa -t /mnt/research/ShadeLab/SharedResources/SILVA123_QIIME_release/core_alignment/core_alignment_SILVA123.fasta -o qiime191_pynast_silva123/
```

### 29 Jan 2016
* The alignment against the Silva v123 template is equivalent for QIIME 1.8.0 and 1.9.1 - not surprising because the pynast algorithm is the same.  The good news is that the new QIIME 1.9.1 ShadeLAb install with anaconda is working!
|QIIME v    | 1.8.0 HPCC install  | 1.9.1 Anaconda install   |
| :------------- | :-------------: |-------------: |
| template      | silva 123      |silva 123      |
| total aligned     | 28887      |28887     |
| de novo aligned      | 19718      |19718        |
| total failed      | 1331      |1331        |
| de novo failed      | 1325      |1325      |

* We have 6 gg OTUs that fail to align to the silva v123 template - these should be noted in the manuscript.  They are:
| GG OTU ID     |
| :-------------: |
| 1837676       |
| 2041715      |
| 2041722      |
| 4104788      |
| 4151783      |
| 4466966       |

* moved gg database into SharedResources directory
PATH: /mnt/research/ShadeLab/SharedResources/gg_13_8_otus

### 01 Feb 2016
* Working with the new uparse biom table to move into QIIME.  Must convert the jsn format to HD5, filter failed alignments from OTU table and MASTER_Rep_Seqs file to move on
```
biom convert -i MASTER_OTU_bm.biom -o MASTER_OTU_hdf5.biom --table-type="BIOM table" --to-hdf5
```
* filted failed alignments from OTU table.
```
filter_otus_from_otu_table.py -i MASTER_OTU_hdf5.biom -o MASTER_OTU_hdf5_filteredfailedalignments.biom -e qiime191_pynast_silva123/MASTER_RepSeqs_failures.fasta
```
* filtering the failed-to-align sequences reduced the total sequence count from 8,326,877 to 8,291,763.  Removed ~30K sequences.
```
filter_fasta.py -f MASTER_RepSeqs.fa -o MASTER_RepSeqs_filteredfailedalignments.fa -a qiime191_pynast_silva123/MASTER_RepSeqs_aligned.fasta
```
* filtering the failed-to-align sequences reduced the rep sequence count (no. OTUs) from 30218 to 28887 rep. seqs.
* now, try again to assign taxonomy using RDP but within the QIIME 1.9.1 environment.  We need to export the path to RDP classifier 2.2 (2.9 is still not working, but the changes are mostly in the database, so it should be okay to use the 2.2 algorithm with the greengenes database)

```
module load RDPClassifier/2.2

export RDP_JAR_PATH=/opt/software/QIIME/1.8.0--GCC-4.4.5/rdpclassifier-2.2-release/rdp_classifier-2.2.jar

assign_taxonomy.py -i MASTER_RepSeqs_filteredfailedalignments.fa -m rdp -c 0.8 -t /mnt/research/ShadeLab/SharedResources/gg_13_8_otus/taxonomy/97_otu_taxonomy.txt -r /mnt/research/ShadeLab/SharedResources/gg_13_8_otus/rep_set/97_otus.fasta -o rdp_assigned_taxonomy22/
```

* add taxonomy assignments to biom table; note that there as was a bug in the biom add-metadata command that requires additional options (--sc-separated taxonomy and --obervation-header OTUID, taxonomy); this, incombo with the jasn-to-hdf5 convserion, was the cause of our previous formatting problems.
```
echo "#OTUID"$'\t'"taxonomy"$'\t'"confidence" > templine.txt

cat  templine.txt rdp_assigned_taxonomy22/MASTER_RepSeqs_filteredfailedalignments_tax_assignments.txt >> rdp_assigned_taxonomy22/MASTER_RepSeqs_filteredfailedalignments_tax_assignments_header.txt

biom add-metadata -i MASTER_OTU_hdf5_filteredfailedalignments.biom -o MASTER_OTU_hdf5_filteredfailedalignments_rdp.biom --observation-metadata-fp rdp_assigned_taxonomy22/MASTER_RepSeqs_filteredfailedalignments_tax_assignments_header.txt --sc-separated taxonomy --observation-header OTUID,taxonomy

```

* summarize the full biom table (to assess variability in technical replicates)
```
# subsample to even (53116.0 minimum observed sequences in sample C03D02)
single_rarefaction.py -i MASTER_OTU_hdf5_filteredfailedalignments_rdp.biom -o MASTER_OTU_hdf5_filteredfailedalignments_rdp_even53116.biom -d 53116
```

* collapse table to combine all technical reps into one sample
```
collapse_samples.py -b MASTER_OTU_hdf5_filteredfailedalignments_rdp.biom -m Centralia_Full_Map.txt --output_biom_fp MASTER_OTU_hdf5_filteredfailedalignments_rdp_collapse.biom --output_mapping_fp Centralia_Collapsed_Map.txt --collapse_mode sum --collapse_fields Sample

biom summarize_table -i MASTER_OTU_hdf5_rdp_collapse.biom -o MASTER_OTU_hdf5_rdp_collapse_summary.txt

###
Num samples: 19
Num observations: 28775
Total count: 8291763
Table density (fraction of non-zero values): 0.257

Counts/sample summary:
 Min: 227768.0
 Max: 571174.0
 Median: 455244.000
 Mean: 436408.579
 Std. dev.: 73608.466
 Sample Metadata Categories: collapsed_ids
 Observation Metadata Categories: taxonomy

Counts/sample detail:
Mock: 227768.0
C03: 321798.0
C02: 371272.0
C01: 383255.0
C08: 393956.0
C06: 399432.0
C05: 433496.0
C11: 448213.0
C09: 450407.0
C18: 455244.0
C13: 456826.0
C07: 460208.0
C16: 469832.0
C14: 474826.0
C04: 481403.0
C10: 486112.0
C12: 494069.0
C17: 512472.0
C15: 571174.0
###

single_rarefaction.py -i MASTER_OTU_hdf5_filteredfailedalignments_rdp_collapse.biom -o MASTER_OTU_hdf5_filteredfailedalignments_rdp_collapse_even227768.biom -d 227768
```
