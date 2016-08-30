## Analysis of community structure across freeze-thaw pre-treatment prior to MO BIO Power Soil extraction, for improved Gram-positive lysis
###Question:  does the freeze-thaw treatment increase representation of Gram-positive lineages?
### PATH to MiSeq community data from reference sample Cen17  CHECK YEAR and sample
```
/mnt/research/ShadeLab/Sequence/raw_sequence/160701_JackMisc_fastqs
```
### Raw data files provided from Argonne:
```
AshleyShade_map.txt                   Undetermined_S0_L001_R1_001.fastq.gz
Undetermined_S0_L001_I1_001.fastq.gz  Undetermined_S0_L001_R2_001.fastq.gz
```
###

### Copy files - do not unzip
```
rsync -aP /mnt/research/ShadeLab/Sequence/raw_sequence/160701_JackMisc_fastqs/ .

```

### load qiime 1.9.1
```
source /mnt/research/ShadeLab/software/loadanaconda2.sh
```

### Workflow will generally follow [default from ipython notebook](http://nbviewer.jupyter.org/github/biocore/qiime/blob/1.9.1/examples/ipynb/illumina_overview_tutorial.ipynb).

```
#check map file
validate_mapping_file.py -o map_validate/ -m AshleyShade_map.txt

#split libraries
split_libraries_fastq.py -o split_libraries/ -i Undetermined_S0_L001_R1_001.fastq.gz -b Undetermined_S0_L001_I1_001.fastq.gz -m AshleyShade_map.txt --barcode_type 12

#count sequences
count_seqs.py -i split_libraries/seqs.fna

#pick OTUs open reference
pick_closed_reference_otus.py -o otus/ -i split_libraries/seqs.fna
#pick_open_reference_otus.py -o otus/ -i split_libraries/seqs.fna


#check otu picking
biom summarize-table -i otus/otu_table_mc2_w_tax_no_pynast_failures.biom

#core diversity analyses
core_diversity_analyses.py -o core_diversity/ --recover_from_failure -c "SampleType,Replicates,Method" -i otus/otu_table_mc2_w_tax_no_pynast_failures.biom -m AshleyShade_map2.txt -t otus/rep_set.tre -e 7097

#alpha diversity single depth
single_rarefaction.py -i otus/otu_table_mc2_w_tax_no_pynast_failures.biom -o otu_table_mc2_w_tax_no_pynast_failures_even7097.biom -d 7097

#calculate PD and richness
alpha_diversity.py -i otu_table_mc2_w_tax_no_pynast_failures_even7097.biom -m PD_whole_tree,observed_otus -t otus/rep_set.tre -o otu_table_mc2_w_tax_no_pynast_failures_even7097_alphadiv.txt


#Phylum summary
summarize_taxa.py -i otu_table_mc2_w_tax_no_pynast_failures_even7097.biom -L 2 -o phylum_summary/


#Convert biom
biom convert -i otu_table_mc2_w_tax_no_pynast_failures_even7097.biom -o otu_table_mc2_w_tax_no_pynast_failures_even7097.txt --to-tsv --header-key taxonomy --output-metadata-id "ConsensusLineage"

###Also : closed reference protocol as comparison
source /mnt/research/ShadeLab/software/loadanaconda2.sh

#closed reference OTU picking
pick_closed_reference_otus.py -o otus/ -i split_libraries/seqs.fna


#alpha diversity single depth
single_rarefaction.py -i otus/otu_table.biom -o otu_table_even7097.biom -d 7097

#calculate PD and richness
alpha_diversity.py -i otu_table_even7097.biom -m PD_whole_tree,observed_otus -t otus/97_otus.tree -o otu_table_even7097_alphadiv.txt

#Phylum summary
summarize_taxa.py -i otu_table_even7097.biom -L 2 -o phylum_summary/


#Convert biom
biom convert -i otu_table_even7097.biom -o otu_table_even7097.txt --to-tsv --header-key taxonomy --output-metadata-id "ConsensusLineage"
