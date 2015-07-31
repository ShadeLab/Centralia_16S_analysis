***
### Install usearch61 and usearch onto the QIIME AMI instance ###
***
```
cd ..
curl -O https://raw.githubusercontent.com/edamame-course/2015-tutorials/master/QIIME_files/usearch5.2.236_i86linux32
curl -O https://raw.githubusercontent.com/edamame-course/2015-tutorials/master/QIIME_files/usearch6.1.544_i86linux32
```

***
### Install pandaseq onto the QIIME AMI instance ###
***
* which pandaseq
* git clone http://github.com/neufeld/pandaseq.git/
* cd pandaseq
* ./autogen.sh && ./configure && make && sudo make install
* sudo ldconfig
* which pandaseq


***
### For Replicate 1 data analysis ###
***
***
## 1. Assembling Illumina paired-end sequences ##
***
```
mkdir pandaseq_merged_reads
```
```
chmod 777 pandaseq_merge.sh
```
```
./pandaseq_merge.sh
```

***
## Add mapping information to sequence ##
***
```
add_qiime_labels.py -i pandaseq_merged_reads/ -m MappingFiles/Centralia_Full_Map.txt -c InputFastaFileName -n 1
count_seqs.py -i combined_seqs.fna
```

***
## Add mapping information to sequence ##
***
```
add_qiime_labels.py -i pandaseq_merged_reads_2nd/ -m MappingFiles/Centralia_Full_Map.txt -c InputFastaFileName -n 1
count_seqs.py -i combined_seqs.fna
```

***
## Add mapping information to sequence ##
***
```
add_qiime_labels.py -i pandaseq_merged_reads_3rd/ -m MappingFiles/Centralia_Full_Map.txt -c InputFastaFileName -n 1
count_seqs.py -i combined_seqs.fna
```

***
## Split big dataset into each samples ##
***
```
split_sequence_file_on_sample_ids.py -i combined_seqs.fna -o split_samples_1/
```
***
## Split big dataset into each samples ##
***
```
split_sequence_file_on_sample_ids.py -i combined_seqs.fna -o split_samples_2/
```
***
## Split big dataset into each samples ##
***
```
split_sequence_file_on_sample_ids.py -i combined_seqs.fna -o split_samples_3/
```

***
## Pick OTUs with open reference ##
***
```
cd split_samples_1/
pick_open_reference_otus.py -i C01.05102014.R1.D01.GGAGACAAGGGA.fasta,C01.05102014.R1.D02.AATCAGTCTCGT.fasta,C01.05102014.R1.D03.AATCCGTACAGC.fasta,C02.05102014.R1.D01.ACACCTGGTGAT.fasta,C02.05102014.R1.D02.TATCGTTGACCA.fasta,C02.05102014.R1.D03.TTACTGTGCGAT.fasta,C03.05102014.R1.D01.AGGCTACACGAC.fasta,C03.05102014.R1.D02.CTAACCTCCGCT.fasta,C03.05102014.R1.D03.GAACCAAAGGAT.fasta,C04.05102014.R1.D01.GTATGCGCTGTA.fasta,C04.05102014.R1.D02.GTACATACCGGT.fasta,C04.05102014.R1.D03.TCCGACACAATT.fasta,C05.05102014.R1.D01.CCAGTGTATGCA.fasta,C05.05102014.R1.D02.CCTCGTTCGACT.fasta,C05.05102014.R1.D03.TGAGTCACTGGT.fasta,C06.05102014.R1.D01.GACTTGGTATTC.fasta,C06.05102014.R1.D02.TACACGATCTAC.fasta,C06.05102014.R1.D03.GCACACACGTTA.fasta,C07.05102014.R1.D01.CACGCCATAATG.fasta,C07.05102014.R1.D02.CAGGCGTATTGG.fasta,C07.05102014.R1.D03.GGATCGCAGATC.fasta,C08.05102014.R1.D01.GCTGATGAGCTG.fasta,C08.05102014.R1.D02.AGCTGTTGTTTG.fasta,C08.05102014.R1.D03.GGATGGTGTTGC.fasta,C09.05102014.R2.D04.GCGATATATCGC.fasta,C09.05102014.R2.D05.TAGGATTGCTCG.fasta,C09.05102014.R2.D06.ATGTGCACGACT.fasta,C10.05102014.R1.D01.ACGCGCAGATAC.fasta,C10.05102014.R1.D02.GACTTTCCCTCG.fasta,C10.05102014.R1.D03.ATCCCGAATTTG.fasta,C11.06102014.R1.D01.GTTGGTCAATCT.fasta,C11.06102014.R1.D02.TAGCTCGTAACT.fasta,C11.06102014.R1.D03.CAGTGCATATGC.fasta,C12.06102014.R2.D01.TCACGGGAGTTG.fasta,C12.06102014.R2.D02.CTGCTAACGCAA.fasta,C12.06102014.R2.D03.TTAGGGCTCGTA.fasta,C13.06102014.R2.D10.CGCAGCGGTATA.fasta,C13.06102014.R2.D11.AATGCCTCAACT.fasta,C13.06102014.R2.D12.GGTGTCTATTGT.fasta,C14.06102014.R1.D01.AAGAGATGTCGA.fasta,C14.06102014.R1.D02.TCCAAAGTGTTC.fasta,C14.06102014.R1.D03.TACAGATGGCTC.fasta,C15.06102014.R2.D01.ACGTGTACCCAA.fasta,C15.06102014.R2.D02.AAGGAGCGCCTT.fasta,C15.06102014.R2.D03.CGATCCGTATTA.fasta,C16.06102014.R1.D01.GTCTAATTCCGA.fasta,C16.06102014.R1.D02.TCCGAATTCACA.fasta,C16.06102014.R1.D03.ACGCCACGAATG.fasta,C17.06102014.R1.D01.GGCCACGTAGTA.fasta,C17.06102014.R1.D02.TAGGAACTGGCC.fasta,C17.06102014.R1.D03.CTAGCGAACATC.fasta,C18.06102014.RE1.D04.GACAGGAGATAG.fasta,C18.06102014.RE1.D05.ATTCCTGTGAGT.fasta,C18.06102014.RE1.D06.GAGGCTCATCAT.fasta -o usearch61_openref/ -m usearch61
```

***
## Pick OTUs with open reference ##
***
```
cd split_samples_2/
pick_open_reference_otus.py -i C01.05102014.R1.D01.GGAGACAAGGGA.fasta,C01.05102014.R1.D02.AATCAGTCTCGT.fasta,C01.05102014.R1.D03.AATCCGTACAGC.fasta,C02.05102014.R1.D01.ACACCTGGTGAT.fasta,C02.05102014.R1.D02.TATCGTTGACCA.fasta,C02.05102014.R1.D03.TTACTGTGCGAT.fasta,C03.05102014.R1.D01.AGGCTACACGAC.fasta,C03.05102014.R1.D02.CTAACCTCCGCT.fasta,C03.05102014.R1.D03.GAACCAAAGGAT.fasta,C04.05102014.R1.D01.GTATGCGCTGTA.fasta,C04.05102014.R1.D02.GTACATACCGGT.fasta,C04.05102014.R1.D03.TCCGACACAATT.fasta,C05.05102014.R1.D01.CCAGTGTATGCA.fasta,C05.05102014.R1.D02.CCTCGTTCGACT.fasta,C05.05102014.R1.D03.TGAGTCACTGGT.fasta,C06.05102014.R1.D01.GACTTGGTATTC.fasta,C06.05102014.R1.D02.TACACGATCTAC.fasta,C06.05102014.R1.D03.GCACACACGTTA.fasta,C07.05102014.R1.D01.CACGCCATAATG.fasta,C07.05102014.R1.D02.CAGGCGTATTGG.fasta,C07.05102014.R1.D03.GGATCGCAGATC.fasta,C08.05102014.R1.D01.GCTGATGAGCTG.fasta,C08.05102014.R1.D02.AGCTGTTGTTTG.fasta,C08.05102014.R1.D03.GGATGGTGTTGC.fasta,C09.05102014.R2.D04.GCGATATATCGC.fasta,C09.05102014.R2.D05.TAGGATTGCTCG.fasta,C09.05102014.R2.D06.ATGTGCACGACT.fasta,C10.05102014.R1.D01.ACGCGCAGATAC.fasta,C10.05102014.R1.D02.GACTTTCCCTCG.fasta,C10.05102014.R1.D03.ATCCCGAATTTG.fasta,C11.06102014.R1.D01.GTTGGTCAATCT.fasta,C11.06102014.R1.D02.TAGCTCGTAACT.fasta,C11.06102014.R1.D03.CAGTGCATATGC.fasta,C12.06102014.R2.D01.TCACGGGAGTTG.fasta,C12.06102014.R2.D02.CTGCTAACGCAA.fasta,C12.06102014.R2.D03.TTAGGGCTCGTA.fasta,C13.06102014.R2.D10.CGCAGCGGTATA.fasta,C13.06102014.R2.D11.AATGCCTCAACT.fasta,C13.06102014.R2.D12.GGTGTCTATTGT.fasta,C14.06102014.R1.D01.AAGAGATGTCGA.fasta,C14.06102014.R1.D02.TCCAAAGTGTTC.fasta,C14.06102014.R1.D03.TACAGATGGCTC.fasta,C15.06102014.R2.D01.ACGTGTACCCAA.fasta,C15.06102014.R2.D02.AAGGAGCGCCTT.fasta,C15.06102014.R2.D03.CGATCCGTATTA.fasta,C16.06102014.R1.D01.GTCTAATTCCGA.fasta,C16.06102014.R1.D02.TCCGAATTCACA.fasta,C16.06102014.R1.D03.ACGCCACGAATG.fasta,C17.06102014.R1.D01.GGCCACGTAGTA.fasta,C17.06102014.R1.D02.TAGGAACTGGCC.fasta,C17.06102014.R1.D03.CTAGCGAACATC.fasta,C18.06102014.RE1.D04.GACAGGAGATAG.fasta,C18.06102014.RE1.D05.ATTCCTGTGAGT.fasta,C18.06102014.RE1.D06.GAGGCTCATCAT.fasta -o usearch61_openref/ -m usearch61
```

***
## Pick OTUs with open reference ##
***
```
cd split_samples_3/
pick_open_reference_otus.py -i C01.05102014.R1.D01.GGAGACAAGGGA.fasta,C01.05102014.R1.D02.AATCAGTCTCGT.fasta,C01.05102014.R1.D03.AATCCGTACAGC.fasta,C02.05102014.R1.D01.ACACCTGGTGAT.fasta,C02.05102014.R1.D02.TATCGTTGACCA.fasta,C02.05102014.R1.D03.TTACTGTGCGAT.fasta,C03.05102014.R1.D01.AGGCTACACGAC.fasta,C03.05102014.R1.D02.CTAACCTCCGCT.fasta,C03.05102014.R1.D03.GAACCAAAGGAT.fasta,C04.05102014.R1.D01.GTATGCGCTGTA.fasta,C04.05102014.R1.D02.GTACATACCGGT.fasta,C04.05102014.R1.D03.TCCGACACAATT.fasta,C05.05102014.R1.D01.CCAGTGTATGCA.fasta,C05.05102014.R1.D02.CCTCGTTCGACT.fasta,C05.05102014.R1.D03.TGAGTCACTGGT.fasta,C06.05102014.R1.D01.GACTTGGTATTC.fasta,C06.05102014.R1.D02.TACACGATCTAC.fasta,C06.05102014.R1.D03.GCACACACGTTA.fasta,C07.05102014.R1.D01.CACGCCATAATG.fasta,C07.05102014.R1.D02.CAGGCGTATTGG.fasta,C07.05102014.R1.D03.GGATCGCAGATC.fasta,C08.05102014.R1.D01.GCTGATGAGCTG.fasta,C08.05102014.R1.D02.AGCTGTTGTTTG.fasta,C08.05102014.R1.D03.GGATGGTGTTGC.fasta,C09.05102014.R2.D04.GCGATATATCGC.fasta,C09.05102014.R2.D05.TAGGATTGCTCG.fasta,C09.05102014.R2.D06.ATGTGCACGACT.fasta,C10.05102014.R1.D01.ACGCGCAGATAC.fasta,C10.05102014.R1.D02.GACTTTCCCTCG.fasta,C10.05102014.R1.D03.ATCCCGAATTTG.fasta,C11.06102014.R1.D01.GTTGGTCAATCT.fasta,C11.06102014.R1.D02.TAGCTCGTAACT.fasta,C11.06102014.R1.D03.CAGTGCATATGC.fasta,C12.06102014.R2.D01.TCACGGGAGTTG.fasta,C12.06102014.R2.D02.CTGCTAACGCAA.fasta,C12.06102014.R2.D03.TTAGGGCTCGTA.fasta,C13.06102014.R2.D10.CGCAGCGGTATA.fasta,C13.06102014.R2.D11.AATGCCTCAACT.fasta,C13.06102014.R2.D12.GGTGTCTATTGT.fasta,C14.06102014.R1.D01.AAGAGATGTCGA.fasta,C14.06102014.R1.D02.TCCAAAGTGTTC.fasta,C14.06102014.R1.D03.TACAGATGGCTC.fasta,C15.06102014.R2.D01.ACGTGTACCCAA.fasta,C15.06102014.R2.D02.AAGGAGCGCCTT.fasta,C15.06102014.R2.D03.CGATCCGTATTA.fasta,C16.06102014.R1.D01.GTCTAATTCCGA.fasta,C16.06102014.R1.D02.TCCGAATTCACA.fasta,C16.06102014.R1.D03.ACGCCACGAATG.fasta,C17.06102014.R1.D01.GGCCACGTAGTA.fasta,C17.06102014.R1.D02.TAGGAACTGGCC.fasta,C17.06102014.R1.D03.CTAGCGAACATC.fasta,C18.06102014.RE1.D04.GACAGGAGATAG.fasta,C18.06102014.RE1.D05.ATTCCTGTGAGT.fasta,C18.06102014.RE1.D06.GAGGCTCATCAT.fasta -o usearch61_openref/ -m usearch61
```

***
## For set 1 ##
***
```
biom summarize_table -i usearch61_openref_1st/otu_table_mc2_w_tax.biom -o 
```
```
usearch61_openref_1st/summary_otu_table_mc2_w_tax.txt
```
```
more usearch61_openref_1st/summary_otu_table_mc2_w_tax.txt
```

***
## Rarefaction (subsampling) ##
***
```
mkdir usearch61_openref_1st/even77008/
```
```
single_rarefaction.py -i usearch61_openref_1st/otu_table_mc2_w_tax.biom -o 
```
```
usearch61_openref_1st/even77008/otu_table_mc2_w_tax_even77008.biom -d 77008
```
```
biom summarize_table -i usearch61_openref_1st/even77008/otu_table_mc2_w_tax_even77008.biom -o 
```
```
usearch61_openref_1st/even77008/summary_otu_table_mc2_w_tax_even77008.txt
```
```
more usearch61_openref_1st/even77008/summary_otu_table_mc2_w_tax_even77008.txt
```

***
## Calculating within-sample (alpha) diversity ##
***
```
mkdir usearch61_openref_2nd/even77008/WS_Diversity_even77008/ 
```
```
alpha_diversity.py -i usearch61_openref_2nd/even77008/otu_table_mc2_w_tax_even77008.biom -m observed_species,PD_whole_tree -o
```
```
usearch61_openref_2nd/even77008/WS_Diversity_even77008/WS_Diversity_even77008.txt -t usearch61_openref_2nd/rep_set.tre
```
```
head usearch61_openref_2nd/even77008/WS_Diversity_even77008/WS_Diversity_even77008.txt
```

***
## Visualizing within-sample diversity ##
***
```
summarize_taxa_through_plots.py -o usearch61_openref_2nd/even77008/WS_Diversity_even77008/taxa_summary77008/ -i usearch61_openref_2nd/even77008/otu_table_mc2_w_tax_even77008.biom
```


* Create Rarefaction curves
```
alpha_rarefaction.py -i usearch61_openref_1st/even77008/otu_table_mc2_w_tax_even77008.biom -o usearch61_openref_1st/even77008/rarefaction_curve/ -t usearch61_openref_2nd/rep_set.tre -m ../MappingFiles/Centralia_Full_Map.txt -e 10000
```

***
## Make resemblance matrices to analyze comparative (beta) diversity ##
***
```
beta_diversity.py -i usearch61_openref_2nd/even77008/otu_table_mc2_w_tax_even77008.biom -m unweighted_unifrac,weighted_unifrac,binary_sorensen_dice,bray_curtis -o usearch61_openref_2nd/even77008/compar_div_even77008/ -t usearch61_openref_2nd/rep_set.tre
```

***
## Using QIIME for visualization: Ordination (PCoA)
***
```
mkdir usearch61_openref_2nd/even77008/compar_div_even77008_PCoA/
```
```
principal_coordinates.py -i usearch61_openref_2nd/even77008/compar_div_even77008/ -o usearch61_openref_2nd/even77008/compar_div_even77008_PCoA/
```
```
make_2d_plots.py -i usearch61_openref_2nd/even77008/compar_div_even77008_PCoA/pcoa_weighted_unifrac_otu_table_mc2_w_tax_even77008.txt -m ../MappingFiles/Centralia_Full_Map.txt -o usearch61_openref_2nd/even77008/compar_div_even77008_PCoA/PCoA_2D_plot_Weighted_Unifrac/
```
```
make_2d_plots.py -i usearch61_openref_2nd/even77008/compar_div_even77008_PCoA/pcoa_unweighted_unifrac_otu_table_mc2_w_tax_even77008.txt -m ../MappingFiles/Centralia_Full_Map.txt -o usearch61_openref_2nd/even77008/compar_div_even77008_PCoA/PCoA_2D_plot_Unweighted_Unifrac/
```
```
make_2d_plots.py -i usearch61_openref_2nd/even77008/compar_div_even77008_PCoA/pcoa_binary_sorensen_dice_otu_table_mc2_w_tax_even77008.txt -m ../MappingFiles/Centralia_Full_Map.txt -o usearch61_openref_2nd/even77008/compar_div_even77008_PCoA/PCoA_2D_plot_sorensen/
```
```
make_2d_plots.py -i usearch61_openref_2nd/even77008/compar_div_even77008_PCoA/pcoa_bray_curtis_otu_table_mc2_w_tax_even77008.txt -m ../MappingFiles/Centralia_Full_Map.txt -o usearch61_openref_2nd/even77008/compar_div_even77008_PCoA/PCoA_2D_plot_Bray_Curtis/
```

***
## Using QIIME for visualization: Ordination (NMDS)
***
```
mkdir usearch61_openref_2nd/even77008/NMDS_Plot
nmds.py -i usearch61_openref_2nd/even77008/compar_div_even77008/bray_curtis_otu_table_mc2_w_tax_even77008.txt -o usearch61_openref_2nd/even77008/NMDS_Plot/mc2_even77008_braycurtis_NMDS_coords.txt
```
```
nmds.py -i usearch61_openref_2nd/even77008/compar_div_even77008/binary_sorensen_dice_otu_table_mc2_w_tax_even77008.txt -o usearch61_openref_2nd/even77008/NMDS_Plot/mc2_even77008_sorenson_NMDS_coords.txt
```
```
nmds.py -i usearch61_openref_2nd/even77008/compar_div_even77008/unweighted_unifrac_otu_table_mc2_w_tax_even77008.txt -o usearch61_openref_2nd/even77008/NMDS_Plot/mc2_even77008_UWunifrac_NMDS_coords.txt
```
```
nmds.py -i usearch61_openref_2nd/even77008/compar_div_even77008/weighted_unifrac_otu_table_mc2_w_tax_even77008.txt -o usearch61_openref_2nd/even77008/NMDS_Plot/mc2_even77008_Wunifrac_NMDS_coords.txt
```

***
## Make heatmap ##
***
```
mkdir usearch61_openref_2nd/even77008/WS_Diversity_even77008/taxa_summary77008/heatmap/
```
```
make_otu_heatmap.py -i usearch61_openref_2nd/even77008/WS_Diversity_even77008/taxa_summary77008/otu_table_mc2_w_tax_even77008_L2.biom -o usearch61_openref_2nd/even77008/WS_Diversity_even77008/taxa_summary77008/heatmap/heatmap_L2_even77008.pdf
```
```
make_otu_heatmap.py -i usearch61_openref_2nd/even77008/WS_Diversity_even77008/taxa_summary77008/otu_table_mc2_w_tax_even77008_L3.biom -o usearch61_openref_2nd/even77008/WS_Diversity_even77008/taxa_summary77008/heatmap/heatmap_L3_even77008.pdf
```
```
make_otu_heatmap.py -i usearch61_openref_2nd/even77008/WS_Diversity_even77008/taxa_summary77008/otu_table_mc2_w_tax_even77008_L4.biom -o usearch61_openref_2nd/even77008/WS_Diversity_even77008/taxa_summary77008/heatmap/heatmap_L4_even77008.pdf
```
```
make_otu_heatmap.py -i usearch61_openref_2nd/even77008/WS_Diversity_even77008/taxa_summary77008/otu_table_mc2_w_tax_even77008_L5.biom -o usearch61_openref_2nd/even77008/WS_Diversity_even77008/taxa_summary77008/heatmap/heatmap_L5_even77008.pdf
```
```
make_otu_heatmap.py -i usearch61_openref_2nd/even77008/WS_Diversity_even77008/taxa_summary77008/otu_table_mc2_w_tax_even77008_L6.biom -o usearch61_openref_2nd/even77008/WS_Diversity_even77008/taxa_summary77008/heatmap/heatmap_L6_even77008.pdf
```


***
### For Collapsed replicate samples based on Sum for analysis 1 ###
***
***
## Collapse OTUs retried from triplicate sample based on sum
***
```
mkdir usearch61_openref_1st/Collapsed_sum/
```
```
collapse_samples.py -b usearch61_openref_2nd/otu_table_mc2_w_tax.biom -m ../MappingFiles/Centralia_Full_Map.txt --output_biom_fp usearch61_openref_2nd/Collapsed_sum/collapsed_OTU_table.biom --output_mapping_fp usearch61_openref_2nd/Collapsed_sum/collapsed_map_new_rep.txt --collapse_mode sum --collapse_fields GPS_pt
```
```
biom summarize_table -i usearch61_openref_2nd/Collapsed_sum/collapsed_OTU_table.biom -o usearch61_openref_2nd/Collapsed_sum/summary_collapsed_OTU_table.biom
more usearch61_openref_2nd/Collapsed_sum/summary_collapsed_OTU_table.biom
```

***
## Rarefaction (subsampling)
***
```
mkdir usearch61_openref_1st/Collapsed_sum/even454693/
```
```
single_rarefaction.py -i usearch61_openref_1st/Collapsed_sum/collapsed_OTU_table.biom -o usearch61_openref_1st/Collapsed_sum/even454693/otu_table_mc2_w_tax_even454693.biom -d 454693
```
```
biom summarize_table -i usearch61_openref_1st/Collapsed_sum/even454693/otu_table_mc2_w_tax_even454693.biom -o usearch61_openref_1st/Collapsed_sum/even454693/summary_otu_table_mc2_w_tax_even454693.txt
```
```
more usearch61_openref_1st/Collapsed_sum/even454693/summary_otu_table_mc2_w_tax_even454693.txt
```

***
## Calculating within-sample (alpha) diversity
***
```
mkdir usearch61_openref_1st/Collapsed_sum/even454693/WS_Diversity_even454693/ 
```
```
alpha_diversity.py -i usearch61_openref_1st/Collapsed_sum/even454693/otu_table_mc2_w_tax_even454693.biom -m observed_species,PD_whole_tree -o usearch61_openref_1st/Collapsed_sum/even454693/WS_Diversity_even454693/WS_Diversity_454693.txt -t usearch61_openref_1st/rep_set.tre
```
```
more usearch61_openref_1st/Collapsed_sum/even454693/WS_Diversity_even454693/WS_Diversity_454693.txt
```

***
## Visualizing within-sample diversity
***
```
summarize_taxa_through_plots.py -o usearch61_openref_1st/Collapsed_sum/even454693/WS_Diversity_even454693/taxa_summary454693/ -i usearch61_openref_1st/Collapsed_sum/even454693/otu_table_mc2_w_tax_even454693.biom
```

* Create Rarefaction curves
```
alpha_rarefaction.py -i usearch61_openref_1st/Collapsed_sum/even454693/otu_table_mc2_w_tax_even454693.biom -o usearch61_openref_1st/Collapsed_sum/even454693/rarefaction_curve/ -t usearch61_openref_1st/rep_set.tre -m ../MappingFiles/Centralia_Full_Map.txt -e 100
```

***
## Make resemblance matrices to analyze comparative (beta) diversity
***
```
beta_diversity.py -i usearch61_openref_1st/Collapsed_sum/even454693/otu_table_mc2_w_tax_even454693.biom -m unweighted_unifrac,weighted_unifrac,binary_sorensen_dice,bray_curtis -o usearch61_openref_1st/Collapsed_sum/even454693/compar_div_even454693/ -t usearch61_openref_1st/rep_set.tre
```

***
## Using QIIME for visualization: Ordination (PCoA)
***
```
mkdir usearch61_openref_1st/Collapsed_sum/even454693/compar_div_even454693_PCoA/
```
```
principal_coordinates.py -i usearch61_openref_1st/Collapsed_sum/even454693/compar_div_even454693/ -o usearch61_openref_1st/Collapsed_sum/even454693/compar_div_even454693_PCoA/
```
```
make_2d_plots.py -i usearch61_openref_1st/Collapsed_sum/even454693/compar_div_even454693_PCoA/pcoa_weighted_unifrac_otu_table_mc2_w_tax_even454693.txt -m usearch61_openref_1st/Collapsed_sum/collapsed_map_new_rep.txt -o usearch61_openref_1st/Collapsed_sum/even454693/compar_div_even454693_PCoA/PCoA_2D_plot_Weighted_Unifrac/
```
```
make_2d_plots.py -i usearch61_openref_1st/Collapsed_sum/even454693/compar_div_even454693_PCoA/pcoa_unweighted_unifrac_otu_table_mc2_w_tax_even454693.txt -m usearch61_openref_1st/Collapsed_sum/collapsed_map_new_rep.txt -o usearch61_openref_1st/Collapsed_sum/even454693/compar_div_even454693_PCoA/PCoA_2D_plot_Unweighted_Unifrac/
```
```
make_2d_plots.py -i usearch61_openref_1st/Collapsed_sum/even454693/compar_div_even454693_PCoA/pcoa_binary_sorensen_dice_otu_table_mc2_w_tax_even454693.txt -m usearch61_openref_1st/Collapsed_sum/collapsed_map_new_rep.txt -o usearch61_openref_1st/Collapsed_sum/even454693/compar_div_even454693_PCoA/PCoA_2D_plot_sorensen/
```
```
make_2d_plots.py -i usearch61_openref_1st/Collapsed_sum/even454693/compar_div_even454693_PCoA/pcoa_bray_curtis_otu_table_mc2_w_tax_even454693.txt -m usearch61_openref_1st/Collapsed_sum/collapsed_map_new_rep.txt -o usearch61_openref_1st/Collapsed_sum/even454693/compar_div_even454693_PCoA/PCoA_2D_plot_Bray_Curtis/
```

***
## Using QIIME for visualization: Ordination (NMDS)
***
```
NMS plots
mkdir usearch61_openref_1st/Collapsed_sum/even454693/NMDS_Plot
nmds.py -i usearch61_openref_1st/Collapsed_sum/even454693/compar_div_even454693/bray_curtis_otu_table_mc2_w_tax_even454693.txt -o usearch61_openref_1st/Collapsed_sum/even454693/NMDS_Plot/mc2_even454693_braycurtis_NMDS_coords.txt
```
```
nmds.py -i usearch61_openref_1st/Collapsed_sum/even454693/compar_div_even454693/binary_sorensen_dice_otu_table_mc2_w_tax_even454693.txt -o usearch61_openref_1st/Collapsed_sum/even454693/NMDS_Plot/mc2_even454693_sorenson_NMDS_coords.txt
```
```
nmds.py -i usearch61_openref_1st/Collapsed_sum/even454693/compar_div_even454693/unweighted_unifrac_otu_table_mc2_w_tax_even454693.txt -o usearch61_openref_1st/Collapsed_sum/even454693/NMDS_Plot/mc2_even454693_UWunifrac_NMDS_coords.txt
```
```
nmds.py -i usearch61_openref_1st/Collapsed_sum/even454693/compar_div_even454693/weighted_unifrac_otu_table_mc2_w_tax_even454693.txt -o usearch61_openref_1st/Collapsed_sum/even454693/NMDS_Plot/mc2_even454693_Wunifrac_NMDS_coords.txt
```

***
## Make heatmap
***
```
mkdir usearch61_openref_1st/Collapsed_sum/even454693/WS_Diversity_even454693/taxa_summary454693/heatmap/
make_otu_heatmap.py -i usearch61_openref_1st/Collapsed_sum/even454693/WS_Diversity_even454693/taxa_summary454693/otu_table_mc2_w_tax_even454693_L2.biom -o usearch61_openref_1st/Collapsed_sum/even454693/WS_Diversity_even454693/taxa_summary454693/heatmap/heatmap_L2_even454693.pdf
```
```
make_otu_heatmap.py -i usearch61_openref_1st/Collapsed_sum/even454693/WS_Diversity_even454693/taxa_summary454693/otu_table_mc2_w_tax_even454693_L3.biom -o usearch61_openref_1st/Collapsed_sum/even454693/WS_Diversity_even454693/taxa_summary454693/heatmap/heatmap_L3_even454693.pdf
```
```
make_otu_heatmap.py -i usearch61_openref_1st/Collapsed_sum/even454693/WS_Diversity_even454693/taxa_summary454693/otu_table_mc2_w_tax_even454693_L4.biom -o usearch61_openref_1st/Collapsed_sum/even454693/WS_Diversity_even454693/taxa_summary454693/heatmap/heatmap_L4_even454693.pdf
```
```
make_otu_heatmap.py -i usearch61_openref_1st/Collapsed_sum/even454693/WS_Diversity_even454693/taxa_summary454693/otu_table_mc2_w_tax_even454693_L5.biom -o usearch61_openref_1st/Collapsed_sum/even454693/WS_Diversity_even454693/taxa_summary454693/heatmap/heatmap_L5_even454693.pdf
```
```
make_otu_heatmap.py -i usearch61_openref_1st/Collapsed_sum/even454693/WS_Diversity_even454693/taxa_summary454693/otu_table_mc2_w_tax_even454693_L6.biom -o usearch61_openref_1st/Collapsed_sum/even454693/WS_Diversity_even454693/taxa_summary454693/heatmap/heatmap_L6_even454693.pdf
```






For set 2

biom summarize_table -i usearch61_openref_2nd/otu_table_mc2_w_tax.biom -o usearch61_openref_2nd/summary_otu_table_mc2_w_tax.txt
more usearch61_openref_2nd/summary_otu_table_mc2_w_tax.txt

Rarefaction (subsampling)

mkdir usearch61_openref_2nd/even77035/
single_rarefaction.py -i usearch61_openref_2nd/otu_table_mc2_w_tax.biom -o usearch61_openref_2nd/even77035/otu_table_mc2_w_tax_even77035.biom -d 77035
biom summarize_table -i usearch61_openref_2nd/even77035/otu_table_mc2_w_tax_even77035.biom -o usearch61_openref_2nd/even77035/summary_otu_table_mc2_w_tax_even77035.txt
more usearch61_openref_2nd/even77035/summary_otu_table_mc2_w_tax_even77035.txt

Calculating within-sample (alpha) diversity
Navigate back into the usearch61_openref/ directory, and make a new directory for alpha diversity results.
mkdir usearch61_openref_2nd/even77035/WS_Diversity_even77035/ 
alpha_diversity.py -i usearch61_openref_2nd/even77035/otu_table_mc2_w_tax_even77035.biom -m observed_species,PD_whole_tree -o usearch61_openref_2nd/even77035/WS_Diversity_even77035/WS_Diversity_even77035.txt -t usearch61_openref_2nd/rep_set.tre
head usearch61_openref_2nd/even77035/WS_Diversity_even77035/WS_Diversity_even77035.txt

Visualizing within-sample diversity
summarize_taxa_through_plots.py -o usearch61_openref_2nd/even77035/WS_Diversity_even77035/taxa_summary77035/ -i usearch61_openref_2nd/even77035/otu_table_mc2_w_tax_even77035.biom

*** Rarefaction curves ***
alpha_rarefaction.py -i usearch61_openref_2nd/even77035/otu_table_mc2_w_tax_even77035.biom -o usearch61_openref_2nd/even77035/rarefaction_curve/ -t usearch61_openref_2nd/rep_set.tre -m ../MappingFiles/Centralia_Full_Map.txt -e 100

Make resemblance matrices to analyze comparative (beta) diversity
beta_diversity.py -i usearch61_openref_2nd/even77035/otu_table_mc2_w_tax_even77035.biom -m unweighted_unifrac,weighted_unifrac,binary_sorensen_dice,bray_curtis -o usearch61_openref_2nd/even77035/compar_div_even77035/ -t usearch61_openref_2nd/rep_set.tre


Using QIIME for visualization: Ordination
mkdir usearch61_openref_2nd/even77035/compar_div_even77035_PCoA/

principal_coordinates.py -i usearch61_openref_2nd/even77035/compar_div_even77035/ -o usearch61_openref_2nd/even77035/compar_div_even77035_PCoA/

make_2d_plots.py -i usearch61_openref_2nd/even77035/compar_div_even77035_PCoA/pcoa_weighted_unifrac_otu_table_mc2_w_tax_even77035.txt -m ../MappingFiles/Centralia_Full_Map.txt -o usearch61_openref_2nd/even77035/compar_div_even77035_PCoA/PCoA_2D_plot_Weighted_Unifrac/

make_2d_plots.py -i usearch61_openref_2nd/even77035/compar_div_even77035_PCoA/pcoa_unweighted_unifrac_otu_table_mc2_w_tax_even77035.txt -m ../MappingFiles/Centralia_Full_Map.txt -o usearch61_openref_2nd/even77035/compar_div_even77035_PCoA/PCoA_2D_plot_Unweighted_Unifrac/

make_2d_plots.py -i usearch61_openref_2nd/even77035/compar_div_even77035_PCoA/pcoa_binary_sorensen_dice_otu_table_mc2_w_tax_even77035.txt -m ../MappingFiles/Centralia_Full_Map.txt -o usearch61_openref_2nd/even77035/compar_div_even77035_PCoA/PCoA_2D_plot_sorensen/

make_2d_plots.py -i usearch61_openref_2nd/even77035/compar_div_even77035_PCoA/pcoa_bray_curtis_otu_table_mc2_w_tax_even77035.txt -m ../MappingFiles/Centralia_Full_Map.txt -o usearch61_openref_2nd/even77035/compar_div_even77035_PCoA/PCoA_2D_plot_Bray_Curtis/


NMS plots
mkdir usearch61_openref_2nd/even77035/NMDS_Plot
nmds.py -i usearch61_openref_2nd/even77035/compar_div_even77035/bray_curtis_otu_table_mc2_w_tax_even77035.txt -o usearch61_openref_2nd/even77035/NMDS_Plot/mc2_even77035_braycurtis_NMDS_coords.txt

nmds.py -i usearch61_openref_2nd/even77035/compar_div_even77035/binary_sorensen_dice_otu_table_mc2_w_tax_even77035.txt -o usearch61_openref_2nd/even77035/NMDS_Plot/mc2_even77035_sorenson_NMDS_coords.txt

nmds.py -i usearch61_openref_2nd/even77035/compar_div_even77035/unweighted_unifrac_otu_table_mc2_w_tax_even77035.txt -o usearch61_openref_2nd/even77035/NMDS_Plot/mc2_even77035_UWunifrac_NMDS_coords.txt

nmds.py -i usearch61_openref_2nd/even77035/compar_div_even77035/weighted_unifrac_otu_table_mc2_w_tax_even77035.txt -o usearch61_openref_2nd/even77035/NMDS_Plot/mc2_even77035_Wunifrac_NMDS_coords.txt

Make heatmap

mkdir usearch61_openref_2nd/even77035/WS_Diversity_even77035/taxa_summary77035/heatmap/

make_otu_heatmap.py -i usearch61_openref_2nd/even77035/WS_Diversity_even77035/taxa_summary77035/otu_table_mc2_w_tax_even77035_L2.biom -o usearch61_openref_2nd/even77035/WS_Diversity_even77035/taxa_summary77035/heatmap/heatmap_L2_even77035.pdf

make_otu_heatmap.py -i usearch61_openref_2nd/even77035/WS_Diversity_even77035/taxa_summary77035/otu_table_mc2_w_tax_even77035_L3.biom -o usearch61_openref_2nd/even77035/WS_Diversity_even77035/taxa_summary77035/heatmap/heatmap_L3_even77035.pdf

make_otu_heatmap.py -i usearch61_openref_2nd/even77035/WS_Diversity_even77035/taxa_summary77035/otu_table_mc2_w_tax_even77035_L4.biom -o usearch61_openref_2nd/even77035/WS_Diversity_even77035/taxa_summary77035/heatmap/heatmap_L4_even77035.pdf

make_otu_heatmap.py -i usearch61_openref_2nd/even77035/WS_Diversity_even77035/taxa_summary77035/otu_table_mc2_w_tax_even77035_L5.biom -o usearch61_openref_2nd/even77035/WS_Diversity_even77035/taxa_summary77035/heatmap/heatmap_L5_even77035.pdf

make_otu_heatmap.py -i usearch61_openref_2nd/even77035/WS_Diversity_even77035/taxa_summary77035/otu_table_mc2_w_tax_even77035_L6.biom -o usearch61_openref_2nd/even77035/WS_Diversity_even77035/taxa_summary77035/heatmap/heatmap_L6_even77035.pdf

 
Collapsed replicates based on Sum
mkdir usearch61_openref_2nd/Collapsed_sum/
collapse_samples.py -b usearch61_openref_2nd/otu_table_mc2_w_tax.biom -m ../MappingFiles/Centralia_Full_Map.txt --output_biom_fp usearch61_openref_2nd/Collapsed_sum/collapsed_OTU_table.biom --output_mapping_fp usearch61_openref_2nd/Collapsed_sum/collapsed_map_new_rep.txt --collapse_mode sum --collapse_fields GPS_pt

biom summarize_table -i usearch61_openref_2nd/Collapsed_sum/collapsed_OTU_table.biom -o usearch61_openref_2nd/Collapsed_sum/summary_collapsed_OTU_table.biom
more usearch61_openref_2nd/Collapsed_sum/summary_collapsed_OTU_table.biom
Min: 455113 seqs

Rarefaction (subsampling)
mkdir usearch61_openref_2nd/Collapsed_sum/even455113/
single_rarefaction.py -i usearch61_openref_2nd/Collapsed_sum/collapsed_OTU_table.biom -o usearch61_openref_2nd/Collapsed_sum/even455113/otu_table_mc2_w_tax_even455113.biom -d 455113
biom summarize_table -i usearch61_openref_2nd/Collapsed_sum/even455113/otu_table_mc2_w_tax_even455113.biom -o usearch61_openref_2nd/Collapsed_sum/even455113/summary_otu_table_mc2_w_tax_even455113.txt
more usearch61_openref_2nd/Collapsed_sum/even455113/summary_otu_table_mc2_w_tax_even455113.txt


Calculating within-sample (alpha) diversity
Navigate back into the usearch61_openref/ directory, and make a new directory for alpha diversity results.
mkdir usearch61_openref_2nd/Collapsed_sum/even455113/WS_Diversity_even455113/ 
alpha_diversity.py -i usearch61_openref_2nd/Collapsed_sum/even455113/otu_table_mc2_w_tax_even455113.biom -m observed_species,PD_whole_tree -o usearch61_openref_2nd/Collapsed_sum/even455113/WS_Diversity_even455113/WS_Diversity_455113.txt -t usearch61_openref_2nd/rep_set.tre
more usearch61_openref_2nd/Collapsed_sum/even455113/WS_Diversity_even455113/WS_Diversity_455113.txt

Visualizing within-sample diversity
summarize_taxa_through_plots.py -o usearch61_openref_2nd/Collapsed_sum/even455113/WS_Diversity_even455113/taxa_summary455113/ -i usearch61_openref_2nd/Collapsed_sum/even455113/otu_table_mc2_w_tax_even455113.biom

*** Rarefaction curves ***
alpha_rarefaction.py -i usearch61_openref_2nd/Collapsed_sum/even455113/otu_table_mc2_w_tax_even455113.biom -o usearch61_openref_2nd/Collapsed_sum/even455113/rarefaction_curve/ -t usearch61_openref_2nd/rep_set.tre -m ../MappingFiles/Centralia_Full_Map.txt -e 100


Make resemblance matrices to analyze comparative (beta) diversity
beta_diversity.py -i usearch61_openref_2nd/Collapsed_sum/even455113/otu_table_mc2_w_tax_even455113.biom -m unweighted_unifrac,weighted_unifrac,binary_sorensen_dice,bray_curtis -o usearch61_openref_2nd/Collapsed_sum/even455113/compar_div_even455113/ -t usearch61_openref_2nd/rep_set.tre


Using QIIME for visualization: Ordination
mkdir usearch61_openref_2nd/Collapsed_sum/even455113/compar_div_even455113_PCoA/

principal_coordinates.py -i usearch61_openref_2nd/Collapsed_sum/even455113/compar_div_even455113/ -o usearch61_openref_2nd/Collapsed_sum/even455113/compar_div_even455113_PCoA/

make_2d_plots.py -i usearch61_openref_2nd/Collapsed_sum/even455113/compar_div_even455113_PCoA/pcoa_weighted_unifrac_otu_table_mc2_w_tax_even455113.txt -m usearch61_openref_2nd/Collapsed_sum/collapsed_map_new_rep.txt -o usearch61_openref_2nd/Collapsed_sum/even455113/compar_div_even455113_PCoA/PCoA_2D_plot_Weighted_Unifrac/

make_2d_plots.py -i usearch61_openref_2nd/Collapsed_sum/even455113/compar_div_even455113_PCoA/pcoa_unweighted_unifrac_otu_table_mc2_w_tax_even455113.txt -m usearch61_openref_2nd/Collapsed_sum/collapsed_map_new_rep.txt -o usearch61_openref_2nd/Collapsed_sum/even455113/compar_div_even455113_PCoA/PCoA_2D_plot_Unweighted_Unifrac/

make_2d_plots.py -i usearch61_openref_2nd/Collapsed_sum/even455113/compar_div_even455113_PCoA/pcoa_binary_sorensen_dice_otu_table_mc2_w_tax_even455113.txt -m usearch61_openref_2nd/Collapsed_sum/collapsed_map_new_rep.txt -o usearch61_openref_2nd/Collapsed_sum/even455113/compar_div_even455113_PCoA/PCoA_2D_plot_sorensen/

make_2d_plots.py -i usearch61_openref_2nd/Collapsed_sum/even455113/compar_div_even455113_PCoA/pcoa_bray_curtis_otu_table_mc2_w_tax_even455113.txt -m usearch61_openref_2nd/Collapsed_sum/collapsed_map_new_rep.txt -o usearch61_openref_2nd/Collapsed_sum/even455113/compar_div_even455113_PCoA/PCoA_2D_plot_Bray_Curtis/


NMS plots
mkdir usearch61_openref_2nd/Collapsed_sum/even455113/NMDS_Plot
nmds.py -i usearch61_openref_2nd/Collapsed_sum/even455113/compar_div_even455113/bray_curtis_otu_table_mc2_w_tax_even455113.txt -o usearch61_openref_2nd/Collapsed_sum/even455113/NMDS_Plot/mc2_even455113_braycurtis_NMDS_coords.txt

nmds.py -i usearch61_openref_2nd/Collapsed_sum/even455113/compar_div_even455113/binary_sorensen_dice_otu_table_mc2_w_tax_even455113.txt -o usearch61_openref_2nd/Collapsed_sum/even455113/NMDS_Plot/mc2_even455113_sorenson_NMDS_coords.txt

nmds.py -i usearch61_openref_2nd/Collapsed_sum/even455113/compar_div_even455113/unweighted_unifrac_otu_table_mc2_w_tax_even455113.txt -o usearch61_openref_2nd/Collapsed_sum/even455113/NMDS_Plot/mc2_even455113_UWunifrac_NMDS_coords.txt

nmds.py -i usearch61_openref_2nd/Collapsed_sum/even455113/compar_div_even455113/weighted_unifrac_otu_table_mc2_w_tax_even455113.txt -o usearch61_openref_2nd/Collapsed_sum/even455113/NMDS_Plot/mc2_even455113_Wunifrac_NMDS_coords.txt

Make heatmap
mkdir usearch61_openref_2nd/Collapsed_sum/even455113/WS_Diversity_even455113/taxa_summary455113/heatmap/
make_otu_heatmap.py -i usearch61_openref_2nd/Collapsed_sum/even455113/WS_Diversity_even455113/taxa_summary455113/otu_table_mc2_w_tax_even455113_L2.biom -o usearch61_openref_2nd/Collapsed_sum/even455113/WS_Diversity_even455113/taxa_summary455113/heatmap/heatmap_L2_even455113.pdf

make_otu_heatmap.py -i usearch61_openref_2nd/Collapsed_sum/even455113/WS_Diversity_even455113/taxa_summary455113/otu_table_mc2_w_tax_even455113_L3.biom -o usearch61_openref_2nd/Collapsed_sum/even455113/WS_Diversity_even455113/taxa_summary455113/heatmap/heatmap_L3_even455113.pdf

make_otu_heatmap.py -i usearch61_openref_2nd/Collapsed_sum/even455113/WS_Diversity_even455113/taxa_summary455113/otu_table_mc2_w_tax_even455113_L4.biom -o usearch61_openref_2nd/Collapsed_sum/even455113/WS_Diversity_even455113/taxa_summary455113/heatmap/heatmap_L4_even455113.pdf

make_otu_heatmap.py -i usearch61_openref_2nd/Collapsed_sum/even455113/WS_Diversity_even455113/taxa_summary455113/otu_table_mc2_w_tax_even455113_L5.biom -o usearch61_openref_2nd/Collapsed_sum/even455113/WS_Diversity_even455113/taxa_summary455113/heatmap/heatmap_L5_even455113.pdf

make_otu_heatmap.py -i usearch61_openref_2nd/Collapsed_sum/even455113/WS_Diversity_even455113/taxa_summary455113/otu_table_mc2_w_tax_even455113_L6.biom -o usearch61_openref_2nd/Collapsed_sum/even455113/WS_Diversity_even455113/taxa_summary455113/heatmap/heatmap_L6_even455113.pdf

 
For set 3

biom summarize_table -i usearch61_openref_3rd/otu_table_mc2_w_tax.biom -o usearch61_openref_3rd/summary_otu_table_mc2_w_tax.txt
more usearch61_openref_3rd/summary_otu_table_mc2_w_tax.txt

Rarefaction (subsampling)
mkdir usearch61_openref_3rd/even77118/

single_rarefaction.py -i usearch61_openref_3rd/otu_table_mc2_w_tax.biom -o usearch61_openref_3rd/even77118/otu_table_mc2_w_tax_even77118.biom -d 77118

biom summarize_table -i usearch61_openref_3rd/even77118/otu_table_mc2_w_tax_even77118.biom -o usearch61_openref_3rd/even77118/summary_otu_table_mc2_w_tax_even77118.txt

more usearch61_openref_3rd/even77118/summary_otu_table_mc2_w_tax_even77118.txt

Calculating within-sample (alpha) diversity
Navigate back into the usearch61_openref/ directory, and make a new directory for alpha diversity results.
mkdir usearch61_openref_3rd/even77118/WS_Diversity_even77118/ 

alpha_diversity.py -i usearch61_openref_3rd/even77118/otu_table_mc2_w_tax_even77118.biom -m observed_species,PD_whole_tree -o usearch61_openref_3rd/even77118/WS_Diversity_even77118/WS_Diversity_even77118.txt -t usearch61_openref_3rd/rep_set.tre

head usearch61_openref_3rd/even77118/WS_Diversity_even77118/WS_Diversity_even77118.txt

Visualizing within-sample diversity
summarize_taxa_through_plots.py -o usearch61_openref_3rd/even77118/WS_Diversity_even77118/taxa_summary77118/ -i usearch61_openref_3rd/even77118/otu_table_mc2_w_tax_even77118.biom

*** Rarefaction curves ***
alpha_rarefaction.py -i usearch61_openref_3rd/even77118/otu_table_mc2_w_tax_even77118.biom -o usearch61_openref_3rd/even77118/rarefaction_curve/ -t usearch61_openref_3rd/rep_set.tre -m ../MappingFiles/Centralia_Full_Map.txt -e 100

Make resemblance matrices to analyze comparative (beta) diversity
beta_diversity.py -i usearch61_openref_3rd/even77118/otu_table_mc2_w_tax_even77118.biom -m unweighted_unifrac,weighted_unifrac,binary_sorensen_dice,bray_curtis -o usearch61_openref_3rd/even77118/compar_div_even77118/ -t usearch61_openref_3rd/rep_set.tre


Using QIIME for visualization: Ordination
mkdir usearch61_openref_3rd/even77118/compar_div_even77118_PCoA/

principal_coordinates.py -i usearch61_openref_3rd/even77118/compar_div_even77118/ -o usearch61_openref_3rd/even77118/compar_div_even77118_PCoA/

make_2d_plots.py -i usearch61_openref_3rd/even77118/compar_div_even77118_PCoA/pcoa_weighted_unifrac_otu_table_mc2_w_tax_even77118.txt -m ../MappingFiles/Centralia_Full_Map.txt -o usearch61_openref_3rd/even77118/compar_div_even77118_PCoA/PCoA_2D_plot_Weighted_Unifrac/

make_2d_plots.py -i usearch61_openref_3rd/even77118/compar_div_even77118_PCoA/pcoa_unweighted_unifrac_otu_table_mc2_w_tax_even77118.txt -m ../MappingFiles/Centralia_Full_Map.txt -o usearch61_openref_3rd/even77118/compar_div_even77118_PCoA/PCoA_2D_plot_Unweighted_Unifrac/

make_2d_plots.py -i usearch61_openref_3rd/even77118/compar_div_even77118_PCoA/pcoa_binary_sorensen_dice_otu_table_mc2_w_tax_even77118.txt -m ../MappingFiles/Centralia_Full_Map.txt -o usearch61_openref_3rd/even77118/compar_div_even77118_PCoA/PCoA_2D_plot_sorensen/

make_2d_plots.py -i usearch61_openref_3rd/even77118/compar_div_even77118_PCoA/pcoa_bray_curtis_otu_table_mc2_w_tax_even77118.txt -m ../MappingFiles/Centralia_Full_Map.txt -o usearch61_openref_3rd/even77118/compar_div_even77118_PCoA/PCoA_2D_plot_Bray_Curtis/


NMS plots
mkdir usearch61_openref_3rd/even77118/NMDS_Plot

nmds.py -i usearch61_openref_3rd/even77118/compar_div_even77118/bray_curtis_otu_table_mc2_w_tax_even77118.txt -o usearch61_openref_3rd/even77118/NMDS_Plot/mc2_even77118_braycurtis_NMDS_coords.txt

nmds.py -i usearch61_openref_3rd/even77118/compar_div_even77118/ binary_sorensen_dice_otu_table_mc2_w_tax_even77118.txt -o usearch61_openref_3rd/even77118/NMDS_Plot/mc2_even77118_sorenson_NMDS_coords.txt

nmds.py -i usearch61_openref_3rd/even77118/compar_div_even77118/ unweighted_unifrac_otu_table_mc2_w_tax_even77118.txt -o usearch61_openref_3rd/even77118/NMDS_Plot/mc2_even77118_UWunifrac_NMDS_coords.txt

nmds.py -i usearch61_openref_3rd/even77118/compar_div_even77118/ weighted_unifrac_otu_table_mc2_w_tax_even77118.txt -o usearch61_openref_3rd/even77118/NMDS_Plot/mc2_even77118_Wunifrac_NMDS_coords.txt

Make heatmap

mkdir usearch61_openref_3rd/even77118/WS_Diversity_even77118/taxa_summary77118/heatmap/

make_otu_heatmap.py -i usearch61_openref_3rd/even77118/WS_Diversity_even77118/taxa_summary77118/otu_table_mc2_w_tax_even77118_L2.biom -o usearch61_openref_3rd/even77118/WS_Diversity_even77118/taxa_summary77118/heatmap/heatmap_L2_even77118.pdf

make_otu_heatmap.py -i usearch61_openref_3rd/even77118/WS_Diversity_even77118/taxa_summary77118/otu_table_mc2_w_tax_even77118_L3.biom -o usearch61_openref_3rd/even77118/WS_Diversity_even77118/taxa_summary77118/heatmap/heatmap_L3_even77118.pdf

make_otu_heatmap.py -i usearch61_openref_3rd/even77118/WS_Diversity_even77118/taxa_summary77118/otu_table_mc2_w_tax_even77118_L4.biom -o usearch61_openref_3rd/even77118/WS_Diversity_even77118/taxa_summary77118/heatmap/heatmap_L4_even77118.pdf

make_otu_heatmap.py -i usearch61_openref_3rd/even77118/WS_Diversity_even77118/taxa_summary77118/otu_table_mc2_w_tax_even77118_L5.biom -o usearch61_openref_3rd/even77118/WS_Diversity_even77118/taxa_summary77118/heatmap/heatmap_L5_even77118.pdf

make_otu_heatmap.py -i usearch61_openref_3rd/even77118/WS_Diversity_even77118/taxa_summary77118/otu_table_mc2_w_tax_even77118_L6.biom -o usearch61_openref_3rd/even77118/WS_Diversity_even77118/taxa_summary77118/heatmap/heatmap_L6_even77118.pdf

 
Collapsed replicates based on Sum
mkdir usearch61_openref_3rd/Collapsed_sum/
collapse_samples.py -b usearch61_openref_3rd/otu_table_mc2_w_tax.biom -m ../MappingFiles/Centralia_Full_Map.txt --output_biom_fp usearch61_openref_3rd/Collapsed_sum/collapsed_OTU_table.biom --output_mapping_fp usearch61_openref_3rd/Collapsed_sum/collapsed_map_new_rep.txt --collapse_mode sum --collapse_fields GPS_pt

biom summarize_table -i usearch61_openref_3rd/Collapsed_sum/collapsed_OTU_table.biom -o usearch61_openref_3rd/Collapsed_sum/summary_collapsed_OTU_table.biom
more usearch61_openref_3rd/Collapsed_sum/summary_collapsed_OTU_table.biom
Min: 455229 seqs

Rarefaction (subsampling)
mkdir usearch61_openref_3rd/Collapsed_sum/even455229/
single_rarefaction.py -i usearch61_openref_3rd/Collapsed_sum/collapsed_OTU_table.biom -o usearch61_openref_3rd/Collapsed_sum/even455229/otu_table_mc2_w_tax_even455229.biom -d 455229
biom summarize_table -i usearch61_openref_3rd/Collapsed_sum/even455229/otu_table_mc2_w_tax_even455229.biom -o usearch61_openref_3rd/Collapsed_sum/even455229/summary_otu_table_mc2_w_tax_even455229.txt
more usearch61_openref_3rd/Collapsed_sum/even455229/summary_otu_table_mc2_w_tax_even455229.txt


Calculating within-sample (alpha) diversity
Navigate back into the usearch61_openref/ directory, and make a new directory for alpha diversity results.
mkdir usearch61_openref_3rd/Collapsed_sum/even455229/WS_Diversity_even455229/ 
alpha_diversity.py -i usearch61_openref_3rd/Collapsed_sum/even455229/otu_table_mc2_w_tax_even455229.biom -m observed_species,PD_whole_tree -o usearch61_openref_3rd/Collapsed_sum/even455229/WS_Diversity_even455229/WS_Diversity_455229.txt -t usearch61_openref_3rd/rep_set.tre
more usearch61_openref_3rd/Collapsed_sum/even455229/WS_Diversity_even455229/WS_Diversity_455229.txt

Visualizing within-sample diversity
summarize_taxa_through_plots.py -o usearch61_openref_3rd/Collapsed_sum/even455229/WS_Diversity_even455229/taxa_summary455229/ -i usearch61_openref_3rd/Collapsed_sum/even455229/otu_table_mc2_w_tax_even455229.biom

*** Rarefaction curves ***
alpha_rarefaction.py -i usearch61_openref_3rd/Collapsed_sum/even455229/otu_table_mc2_w_tax_even455229.biom -o usearch61_openref_3rd/Collapsed_sum/even455229/rarefaction_curve/ -t usearch61_openref_3rd/rep_set.tre -m ../MappingFiles/Centralia_Full_Map.txt -e 100


Make resemblance matrices to analyze comparative (beta) diversity
beta_diversity.py -i usearch61_openref_3rd/Collapsed_sum/even455229/otu_table_mc2_w_tax_even455229.biom -m unweighted_unifrac,weighted_unifrac,binary_sorensen_dice,bray_curtis -o usearch61_openref_3rd/Collapsed_sum/even455229/compar_div_even455229/ -t usearch61_openref_3rd/rep_set.tre


Using QIIME for visualization: Ordination
mkdir usearch61_openref_3rd/Collapsed_sum/even455229/compar_div_even455229_PCoA/

principal_coordinates.py -i usearch61_openref_3rd/Collapsed_sum/even455229/compar_div_even455229/ -o usearch61_openref_3rd/Collapsed_sum/even455229/compar_div_even455229_PCoA/

make_2d_plots.py -i usearch61_openref_3rd/Collapsed_sum/even455229/compar_div_even455229_PCoA/pcoa_weighted_unifrac_otu_table_mc2_w_tax_even455229.txt -m usearch61_openref_3rd/Collapsed_sum/collapsed_map_new_rep.txt -o usearch61_openref_3rd/Collapsed_sum/even455229/compar_div_even455229_PCoA/PCoA_2D_plot_Weighted_Unifrac/

make_2d_plots.py -i usearch61_openref_3rd/Collapsed_sum/even455229/compar_div_even455229_PCoA/pcoa_unweighted_unifrac_otu_table_mc2_w_tax_even455229.txt -m usearch61_openref_3rd/Collapsed_sum/collapsed_map_new_rep.txt -o usearch61_openref_3rd/Collapsed_sum/even455229/compar_div_even455229_PCoA/PCoA_2D_plot_Unweighted_Unifrac/

make_2d_plots.py -i usearch61_openref_3rd/Collapsed_sum/even455229/compar_div_even455229_PCoA/pcoa_binary_sorensen_dice_otu_table_mc2_w_tax_even455229.txt -m usearch61_openref_3rd/Collapsed_sum/collapsed_map_new_rep.txt -o usearch61_openref_3rd/Collapsed_sum/even455229/compar_div_even455229_PCoA/PCoA_2D_plot_sorensen/

make_2d_plots.py -i usearch61_openref_3rd/Collapsed_sum/even455229/compar_div_even455229_PCoA/pcoa_bray_curtis_otu_table_mc2_w_tax_even455229.txt -m usearch61_openref_3rd/Collapsed_sum/collapsed_map_new_rep.txt -o usearch61_openref_3rd/Collapsed_sum/even455229/compar_div_even455229_PCoA/PCoA_2D_plot_Bray_Curtis/


NMS plots
mkdir usearch61_openref_3rd/Collapsed_sum/even455229/NMDS_Plot
nmds.py -i usearch61_openref_3rd/Collapsed_sum/even455229/compar_div_even455229/bray_curtis_otu_table_mc2_w_tax_even455229.txt -o usearch61_openref_3rd/Collapsed_sum/even455229/NMDS_Plot/mc2_even455229_braycurtis_NMDS_coords.txt

nmds.py -i usearch61_openref_3rd/Collapsed_sum/even455229/compar_div_even455229/binary_sorensen_dice_otu_table_mc2_w_tax_even455229.txt -o usearch61_openref_3rd/Collapsed_sum/even455229/NMDS_Plot/mc2_even455229_sorenson_NMDS_coords.txt

nmds.py -i usearch61_openref_3rd/Collapsed_sum/even455229/compar_div_even455229/unweighted_unifrac_otu_table_mc2_w_tax_even455229.txt -o usearch61_openref_3rd/Collapsed_sum/even455229/NMDS_Plot/mc2_even455229_UWunifrac_NMDS_coords.txt

nmds.py -i usearch61_openref_3rd/Collapsed_sum/even455229/compar_div_even455229/weighted_unifrac_otu_table_mc2_w_tax_even455229.txt -o usearch61_openref_3rd/Collapsed_sum/even455229/NMDS_Plot/mc2_even455229_Wunifrac_NMDS_coords.txt

Make heatmap
mkdir usearch61_openref_3rd/Collapsed_sum/even455229/WS_Diversity_even455229/taxa_summary455229/heatmap/
make_otu_heatmap.py -i usearch61_openref_3rd/Collapsed_sum/even455229/WS_Diversity_even455229/taxa_summary455229/otu_table_mc2_w_tax_even455229_L2.biom -o usearch61_openref_3rd/Collapsed_sum/even455229/WS_Diversity_even455229/taxa_summary455229/heatmap/heatmap_L2_even455229.pdf

make_otu_heatmap.py -i usearch61_openref_3rd/Collapsed_sum/even455229/WS_Diversity_even455229/taxa_summary455229/otu_table_mc2_w_tax_even455229_L3.biom -o usearch61_openref_3rd/Collapsed_sum/even455229/WS_Diversity_even455229/taxa_summary455229/heatmap/heatmap_L3_even455229.pdf

make_otu_heatmap.py -i usearch61_openref_3rd/Collapsed_sum/even455229/WS_Diversity_even455229/taxa_summary455229/otu_table_mc2_w_tax_even455229_L4.biom -o usearch61_openref_3rd/Collapsed_sum/even455229/WS_Diversity_even455229/taxa_summary455229/heatmap/heatmap_L4_even455229.pdf

make_otu_heatmap.py -i usearch61_openref_3rd/Collapsed_sum/even455229/WS_Diversity_even455229/taxa_summary455229/otu_table_mc2_w_tax_even455229_L5.biom -o usearch61_openref_3rd/Collapsed_sum/even455229/WS_Diversity_even455229/taxa_summary455229/heatmap/heatmap_L5_even455229.pdf

make_otu_heatmap.py -i usearch61_openref_3rd/Collapsed_sum/even455229/WS_Diversity_even455229/taxa_summary455229/otu_table_mc2_w_tax_even455229_L6.biom -o usearch61_openref_3rd/Collapsed_sum/even455229/WS_Diversity_even455229/taxa_summary455229/heatmap/heatmap_L6_even455229.pdf


 
Make OTU table with taxomony
biom convert -i usearch61_openref_1st/otu_table_mc2_w_tax.biom -o usearch61_openref_1st/1st_biom_converted_OTU_table_w_tax.txt --table-type "OTU table" --to-tsv --header-key taxonomy --output-metadata-id "ConsensusLineage"

biom convert -i usearch61_openref_2nd/otu_table_mc2_w_tax.biom -o usearch61_openref_2nd/2nd_biom_converted_OTU_table_w_tax.txt --table-type "OTU table" --to-tsv --header-key taxonomy --output-metadata-id "ConsensusLineage"

biom convert -i usearch61_openref_3rd/otu_table_mc2_w_tax.biom -o usearch61_openref_3rd/3rd_biom_converted_OTU_table_w_tax.txt --table-type "OTU table" --to-tsv --header-key taxonomy --output-metadata-id "ConsensusLineage"


biom convert -i usearch61_openref_1st/even77008/otu_table_mc2_w_tax_even77008.biom -o usearch61_openref_1st/even77008/1st_biom_converted_OTU_table_w_tax_even77008.txt --table-type "OTU table" --to-tsv --header-key taxonomy --output-metadata-id "ConsensusLineage"

biom convert -i usearch61_openref_2nd/even77035/otu_table_mc2_w_tax_even77035.biom -o usearch61_openref_2nd/even77035/2nd_biom_converted_OTU_table_w_tax_even77035.txt --table-type "OTU table" --to-tsv --header-key taxonomy --output-metadata-id "ConsensusLineage"

biom convert -i usearch61_openref_3rd/even77118/otu_table_mc2_w_tax_even77118.biom -o usearch61_openref_3rd/even77118/3rd_biom_converted_OTU_table_w_tax_even77118.txt --table-type "OTU table" --to-tsv --header-key taxonomy --output-metadata-id "ConsensusLineage"


biom convert -i usearch61_openref_1st/even454693/otu_table_mc2_w_tax_even454693.biom -o usearch61_openref_1st/even454693/1st_biom_converted_OTU_table_w_tax_even454693.txt --table-type "OTU table" --to-tsv --header-key taxonomy --output-metadata-id "ConsensusLineage"

biom convert -i usearch61_openref_2nd/Collapsed_sum/even455113/otu_table_mc2_w_tax_even455113.biom -o usearch61_openref_2nd/Collapsed_sum/even455113/2nd_biom_converted_OTU_table_w_tax_even455113.txt --table-type "OTU table" --to-tsv --header-key taxonomy --output-metadata-id "ConsensusLineage"

biom convert -i usearch61_openref_3rd/Collapsed_sum/even455229/otu_table_mc2_w_tax_even455229.biom -o usearch61_openref_3rd/Collapsed_sum/even455229/3rd_biom_converted_OTU_table_w_tax_even455229.txt --table-type "OTU table" --to-tsv --header-key taxonomy --output-metadata-id "ConsensusLineage"

