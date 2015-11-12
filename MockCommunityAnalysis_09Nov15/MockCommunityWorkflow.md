#Part 1:  Mock community analysis
### PATH to Mock community data from Centralia 2014 16S amplicons
```
research/ShadeLab/Shade/20141230_16Stag_Centralia/20141230_B_16S_PE/Mock_Cmty_TCCTCTGTCGAC_L001_R*
```

### File names for forward (R1) and reverse (R2) read files
* Mock_Cmty_TCCTCTGTCGAC_L001_R1_001.fastq.gz
* Mock_Cmty_TCCTCTGTCGAC_L001_R2_001.fastq.gz

### Merge paired ends and quality filtering
```
usearch -fastq_mergepairs Mock_Cmty_TCCTCTGTCGAC_L001_R1_001.fastq -fastqout Mock.fastq -relabel @ -fastq_merge_maxee 1.0 -fastq_minmergelen 250 -fastq_maxmergelen 274 -fastq_nostagger

usearch v8.1.1803_i86linux32, 4.0Gb RAM (264Gb total), 20 cores
(C) Copyright 2013-15 Robert C. Edgar, all rights reserved.
http://drive5.com/usearch

#output files: Mock.fastq
```

### FOR REAL DATA-  POOL SAMPLES FROM DATASET AT THIS STEP

### Deplication with UNOISE
```
usearch -derep_fulllength Mock.fastq -fastqout uniques_Mock.fastq -sizeout

#output files: uniques_Mock.fastq

#step 1.5 - remove singletons
usearch -sortbysize uniques_Mock.fastq -fastqout uniques_Mock_nosigs.fastq -minsize 2

#output files:   uniques_Mock_nosigs.fastq
```

### Denoise (pre-cluster) with parent sequences with USEARCH
```
usearch -cluster_fast uniques_Mock_nosigs.fastq -centroids_fastq denoised.fq -id 0.9 -maxdiffs 5 -abskew 10 -sizein -sizeout -sort size

#output files:  denoised.fq
```

### Pick OTUs with UPARSE, includes chimera detection
```
usearch -cluster_otus denoised.fq -otus mock_denoised_otus.fa -relabel OTU_ -sizeout -uparseout results.txt   

#output files:  mock_denoised_otus.fa, results.txt   
```

### Additional reference-based chimera detection (only for mock)
```
usearch -uchime_ref mock_denoised_otus.fa -db gold.fa -strand plus -nonchimeras mock_denoised_NoChimeraRef_otus.fa

output files: mock_denoised_NoChimeraRef_otus.fa
```

### Mapping de-noised reads to defined OTUs.  Anything that does not hit at 97% identity or greater (e.g., chimeras) to the OTUs will be discarded.   
```
usearch -usearch_global denoised.fq -db mock_denoised_NoChimeraRef_otus.fa -strand plus -id 0.97 -uc map_denoised.uc -otutabout Mock_OTU_table.txt

#output files:  map.uc, Mock_OTU_table.txt
```

### Assigning taxonomy with the RDP Classifier
```
module load RDPClassifier/2.9

java -jar $RDP_JAR_PATH/classifier.jar classify -c 0.5 -o mock_denoised_classified.txt -h mock_hier.txt mock_denoised_NoChimeraRef_otus.fa

#output files: mock_hier.txt, mock_denoised_classified.txt
```

### Make a database of contaminant OTUs detected in mock community by removing real rep. OTU sequences (mock type stains) from `mock_denoised_NoChimeraRef_otus.fa`.  New db file is: `mock_craptaminant_OTU_db.fa`
