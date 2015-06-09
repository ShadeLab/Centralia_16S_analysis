How Stable Are Soil Microbial Communities When Responding To An Extreme Thermal Disturbance?

Sang-Hoon Lee1,3, Jackson W. Sorensen1, Joshua R. Herr1, Tammy C. Tobin2 and Ashley Shade1* 1Department of Microbiology and Molecular Genetics, Michigan State University, East Lansing, MI, USA
2Department of Biology, Susquehanna University, Selinsgrove, PA, USA
3 School of Civil, Environmental and Architectural Engineering, Korea University, Anam-Dong, Seongbuk-Gu, Seoul, South Korea.

* Corresponding author.
Department of Microbiology and Molecular Genetics, Michigan State University, East Lansing, MI, USA.
Tel.: +1-517-884-5399; fax: +1-???-???-????.
E-mail address: shade.ashley@gmail.com (Ashley Shade).

Key words: 16S tag-sequencing, metagenomics, Thermophile, Community diversity, disturbance, stability


 
Abstract

An ongoing underground coal mine fire has been burning under Centralia, Pennsylvania since 1962. Underlying more than 150 acres, the fire spreads at a pace of 3-7 m/yr through coal seams with surface soil temperatures exceeding 80°C at active vents. This extreme environment offers a unique opportunity to ask how soil microbial community structure and function is altered in response to an extreme, ongoing disturbance that impacts the community at both ecological and evolutionary scales. In a preliminary study exploring compositional differences between mesophilic (35oC) and thermophilic (65oC) Centralia soil communities, Tobin and coworkers1 found that the abundances of thermophiles (e.g. Chthonomomas sp., Geobacillus sp. and Thermogemmatispora sp.) were increased in the fire-affected soils. We compare changes in soil microbial community diversity and structure along 18 sampling sites that historically were affected by fire at different times encompassing a chronosequence of fire response and recovery from 1982 to the present day. High-throughput 16S rRNA gene tag-sequencing (Illumina MiSeq) was performed using thermophilic affected (>55°C), mesophilic affected (30-45°C), unaffected (ambient), and recovered (post-fire, ambient) soil samples, followed by multivariate statistical analyses of community structure and diversity. An average of 309,766 sequences were generated per sample, many were attributed to known thermophiles, most notably including members of the phyla Crenarchaeota and Cyanobacteria. The abundance of some community members were dramatically decreased in response to increasing temperature (e.g. Bacteroidetes, Verrucomicrobia, and Planctomycetes), while others increased in abundance (e.g. Crenarchaeota and Cyanobacteria). We correlated soil metadata, including temperature and chemistry (i.e. iron, sulfur, and ammonium) to molecular sequence data to hypothesize how community structure may be influenced across the fire gradient. Our results suggest that thermophilic bacterial communities are well adapted and play important roles in stability (resistance and resilience) of the microbial communities to the prolonged temperature increase.

1. Introduction
1.1 About Centralia coal mine fired area
- general information from Erika et al.,
- temperature gradient history
- other 
[example (Erika et al., 2011):The coal fire at Centralia has been burning for 48 years and continues to move below the surface, silently changing the vegetation and landscape as it progresses westward (Elick, 2007; Ressler and Markel, 2006). Over the years, this coal fire has been located and studied using surface manifestations such as the release of gasses and heat, changes in vegetation, and mineral precipitates and discolored rock from around vents (Chaiken et al., 1980; Nolter and Vice, 2004; Ressler and Markel, 2006). At first, boreholeswere drilled tomeasure temperature, depth of fire, and gas composition (Chaiken et al., 1980; GAI Consultants Inc., 1983). These boreholes showed increasing temperatures as the fire moved progressively through the region. Several studies included airborne thermal infrared imagery (TIR) to identify the spatial distribution of the fire and to predict its movement (Becker, 1982; GAI Consultants Inc., 1983; Knuth and Stamm, 1972), but after most of the town was relocated in the mid 1980's, government agencies relied less on remote sensing as a necessary means of monitoring the fire.]

1.2 About community changes in response to the environmental conditions
 - bacterial community difference in different environmental conditions
 - community changes in response to the environmental gradients
 - effect of physical and chemical properties of environments (heat, pH, etc. with reference)

1.3 Thermophilic bacterial community response in the normal environments
 - definition of thermophilic bacteria
 - ecological distribution patterns of thermophiles
 - sampled environmental conditions?
[example (Blanc et al., 1999): Recently, we developed a set of media adapted to the enumeration of thermophilic bacterial populations. Relatively high numbers of autotrophic bacteria, growing at temperatures above 70³C, were isolated from hot composts and characterized [7], as well as large numbers of thermophilic heterotrophic bacteria related to Thermus thermophilus [8] and Bacillus spp. [9^11].]

1.4 research aim
To investigate bacterial community composition changes in response to the heat gradient, 
 - totally, 18 of soil samples were collected from Centralia that has 4 different environmental conditions.
 - 16S rRNA gene tag sequencing by illumina miseq was conducted
 - sequences were analyzed by Qiime and 
 - community changes were compared by statistical analysis
 
2. Materials and Methods

2.1. Sample collection and characterization of physico-chemical properties from Centralia soil.
The geographic location of sampling site were located in the GPS position from 40o 47.926 (Latitude) and 076o 20.357 (Longitude) from October 15 to 16 2014.  Background colors of Fig. 1 indicated the fire history (Elick2) and the foreground arrows showed Oct 2014 sampling sites.  Totally, 18Eighteen of surface soil samples (210 cm depth) which representinged a gradient of historical fire activity, were collected along each fire front 1 (Site C01 to C06) and fire front 2 (C09 to C18), including both two of warm (but not actively venting: (C14, and C16) and two unaffected reference sites (C08, and C17) (Fig. 1). The collected soils samples were immediately  stored at 4oC ice box, and transported to the laboratory, for longer storage after and sieved with 4 mm pore. Inset: Fire fronts 1-4, as identified by Nolter and Vice3. The physico-chemical characteristics of each soil samples which represented in Table 1., were measured using   the standard protocols of the Michigan State University Soil  and Plant Nutrient Laboratory (http://www.spnl.msu.edu/_pdf/Soil_Test_Report.pdf)~~!@@. 

2.2 Community DNA extraction and sequencing
Community DNAs were directly extracted from 0.5g of three replicates of each of the 18 soil samples using MoBio Soil DNA Isolation Kit (MoBio, Solana Beach, CA, U.S.A.) according to the manufacturer’s protocol. The concentration and purity of the extracted DNA were determined using the Qubit® dsDNA BR Assay Kit (Life technologies, NY, USA). The typical concentrations of the eachof extracted DNAs were are represented in Table 1.  Paired end sequencing, based on the bacterial and archaeal 16S rRNA hypervariable region V4, were performed using Illumina MiSeq system (Illumina, CA, USA) with V4 region target specific primer sets (Table 3. Reference Caporaso primers), according to the manufacturer’s protocol. All of the sequencing procedures including the construction of Illumina sequencing library using the Illumina TruSeq Nano DNA Library Preparation Kit, emulsion PCR, and a sequencing operations were conducted at RTSF the Michigan State University Genomics Core sequencing center of Michigan State University (East Lansing, MI, USA) following their standard protocols and manufacturer’s instructions. 

2.3. Analyses of sequence data
Base calling of sequences was performed by Illumina Real Time Analysis (RTA) v1.18.61 and output of RTA was demultiplexed and converted to FastQ format with Illumina Bcl2Fastq v1.8.4. Moreover, same program was used for the adaptor and barcode sequences removing. After removal of sequences, pandaseq program (REF???### Neufeld group) was used for the merging both forward and reverse paired end sequences under the conditions including simple Bayesian algorithm, allowing unbarcoded sequences with maximum and minimum length 253 bp, and 47 bp of maximum overlap, at the 90% threshold level. After pandaseq merging, OTUs from the sequences included in each samples were extracted using “pick open reference otu” command  (REF????) Rideout) using “usearch61” method  (edgar) in QIIME 1.9.0 ( Caporaso REF@@###). 

2.5. Statistical methods 
The evenness of extracted OTUsSequences in each samples were synchronized subsampled to those an even THIS NUMBER, which was the minimum number of sequences observed in a sample of minimum numbers (Table @@.). Using the subsampled OTUssequences, within-sample (aAlpha) -diversity was calculated using observed species (richness) and phylogenetic PdDiversity (“whole tree” methodmethod; ref Faith).  Classification was performed using the Ribosomal Database Project Classifier with the greengenes version (INSERT) database. and the classification results for different taxonomic levels, were also used for the Nnetwork correlatons were analysis calculated by using extended Local Similarity Analysis (eLSA; ref with no temporal lag and default (???) parameters), summarized with the igraph package in R (ref) and visualized with Cytoscape (ref). Comparative (Moreover, the bBeta) -diversity matrices was also calculated using weighted, and unweighted UniFrac (phylogenetic, ref Lozupone), binary Sorensen diceSorensen, and Bray-Curtis methods in QIIME 1.9.0.. The weighted UuniFfrac matrix was used for the Principal Correspondence Analysis (PCoA) in QIIME 1.9.0. In addition, Mantel R test, ANOSIM, and heatmap analysis based on z-scored occurrence patterns for the comparison of bacterial community structures between samples and Canonical Correlation Analysis (CCA) for the evaluating the effect of environmental factors were also performed using R program. 





 
3. Results and discussions

3.1 Physico-chemical characteristics of soil samples.
- The physico-chemical characteristics of soil samples measured to interpret community patterns. 
- With the exception of temperature and organic matter (360 and 500), active vent (red circles), warm (orange circles), recovered (yellow circles), and reference sites (green circles) were not distinct, 
- Moreover, the samples from active vent sites showed generally greater ranges than that of recovered sites.
- suggesting that the temperature, and organic matters (360 and 500) might be significant effect on bacterial community compositions.

3.2 Sequence data analysis.
- From sequence data analysis using Qiime, even 73,419 16S rRNA amplicons per soil (minimum sequences from C~~, while that of maximum was C$$$) were observed. 
- An average of 309,766 sequences (totally, 314,021 unique OTUs) were extracted generated per sample.
- 

3.3 Bacterial community compositions (at phylum level)
- Five of Active vent samples which collected from >30 oC sites were clustered together in UPGMA clustering results on the heatmap.
- bacterial diversity and T-test between Active vent and recovered sites showed statistically significant differences.
- PCoA analysis & ANOSIM showed that the separately located patterns of samples between Active vent and recovered sites were observed.
- Comparison of relative abundance of bacterial groups at phylum level, showed that 8 of 22 bacterial phyla were significantly changed patterns between Active vent and recovered site.
  - 5 of 8 were decreased, while 3 of 8 were increased, suggesting that bacterial phyla belonging to the phyla that increased might be contains thermophilic bacteria.

3.4 Important environmental drivers on the bacterial community changes.
- Mantel test between bacterial community composition and environmental factors showed that statistically supported R value, suggesting that the differences of bacterial community composition in each samples might be explained by environmental factors that observed in this study.
- CCA analysis & ANOSIM analysis also confirms the results of PCoA analysis that separated patterns between Active vent and recovered site samples.
- Correlation analysis between axis and environmental variables showed that only temperature, calcium, and pH showed significant correlation with axes 1 and 2

3.5 Networks between bacterial groups and environmental factors
- Total Network tree interpretation (how many nodes and edges, etc???)
- in total network tree = incredible relationships were observed not only between bacterial genus, but also environmental variables and bacterial genus.
- In sub network tree
  - Ca = all positive correlation.
  - pH = most of bacterial genus showed positive correlations, except for two genus belonging to the phyla Acidobacteria, Firmicutes and WPS-2.
- Which the bacterial genus are changed? or effected by selected environmental factors?
- Relationship of results with other analysis.

4. Conclusion
- 
- 
- 
- ###, ###, ### genus might be positively changed by temperature, while !!@ were affected by Ca or pH.

5. Acknowledgement
This study was supported by MSU grant???


6. Reference
 
Table 1. Primer set used for this study.
Primer name	sequence (5' - 3')	Target	target site	Product size 
(bp)	Tm	Reference
515F	GTGCCAGCMGCCGCGGTAA	16S V4	515-534	291	69.5	Caporaso et al., ISME J. 2012
806R	GGACTACHVGGGTWTCTAAT		787-806		45.1	


 
Table 2. Comparison of phylum level bacterial distribution between Active vent and Recovered site. 
 
 
Table 3. Correlation between Axis score and environmental factors.
 

 
Table S1. Bacterial richness and phylogenetic diversity of sampling sites.
 

 
Table S2. ANOSIM analysis of bacterial community compositions between active vent, warm, recovered, and reference sites.
 
 
Table S3. Correlation networks between significant environmental factors and bacterial genus.
 

 
Figure legends

Figure 1. Sampling sites at Centralia Mine Fire. Surface soil samples (10 cm depth) were collected along two fire fronts in Centralia, from October 15 to 16 2014. Each sampling sites represents a gradient of historical fire activity. Background colors indicate the fire history (Elick2) and the foreground arrows show Oct 2014 sampling sites. Inset: Fire fronts 1-4, as identified by Nolter and Vice3

Figure 2. Physico-chemical characteristics of collected soil samples were measured to interpret community patterns. With the exception of temperature and organic matter (360 and 500), active vent (red circles), warm (orange circles), recovered (yellow circles), and reference sites (green circles) were not distinct, though active vents generally had greater ranges.

Figure 3. Comparison of (a) Bacterial richness and (b) phylogenetic diversity between Active Vent (red circles) / Worm (orange circles) and recovered (yellow circles) / reference (green circles) sites. Recovered soils had more OTUs and greater phylogenetic breadth than active vents. (Student t-test: B=both p <0.01)

Figure 4. Comparison of phylum level bacterial distribution between Active vent and Recovered site. Phylum-level differences are apparent across soils, especially for seven bacterial phyla marked in Table 3.

Figure 5. CCA ordination for bacterial communities based on total OTUs. The distinction between active (red), recovered (yellow), and reference (green) soils, except for warm sites (orange) from each fire front 1 (opened) and 2 (closed). Statistically significant (P < 0.05) explanatory variables are represented by solid arrows. 

Figure 6. Network analysis between genus level bacterial groups and environmental factors based on correlation analysis (eLSA). Connections between nodes represents a strong (LS score > 0.6, < -0.6) and significant (P < 0.01) correlation. Each blue solid arrows and orange dotted arrows indicate positive and negative correlations, respectively. From the main network, the three sub-networks for the significant environmental factors (Temperature, pH, and Ca) which selected from the CCA analysis were also generated with the same conditions.  

Figure 7. Venn diagram analysis.

Supplementary figures
Figure S1. Heat map analysis based on Z-scores of occurrence patterns of phyla through 18 Centralia soil samples. The origin of samples were labeled with sample name. The clustering results between the samples were conducted using UPGMA algorithm.

Figure S2. The principal coordinate analysis, based on weighted UniFrac distances, shows distinction between active, recovered, and reference soils. Error bars show the spread around three replicate DNA extractions.

