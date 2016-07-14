#! /bin/bash --login
# Time job will take to execute (HH:MM:SS format)
#PBS -l walltime=18:00:00
# Memory needed by the job
#PBS -l mem=264Gb
# Number of shared memory nodes required and the number of processors per node
#PBS -l nodes=1:ppn=8
# Make output and error files the same file
#PBS -j oe
# Send an email when a job is aborted, begins or ends
#PBS -m abe
# Give the job a name
#PBS -N batch_usearch_centralia_03dec2015
# _______________________________________________________________________#

cd ${PBS_O_WORKDIR}

## set alias for usearch
alias usearch='/mnt/research/rdp/public/thirdParty/usearch8.1.1831_i86linux64'

## PATH to raw fastq (zipped) on ShadeLab HPCC research space
### research/ShadeLab/Shade/20141230_16Stag_Centralia/20141230_A_16S_PE/
### research/ShadeLab/Shade/20141230_16Stag_Centralia/20141230_B_16S_PE/

## PATH to gg db 13.8
### /mnt/research/ShadeLab/WorkingSpace/gg_13_8_otus

## FILES THAT MUST BE IN THE WORKING directory
# File of renaming conventions:  rename.txt
# Names of paired ends:  merge_fq_list.txt
# craptaminant db: mock_craptaminant_OTU_db.fa
# Mapping file: Centralia_Full_Map.txt


### i.  Copy needed raw fastq files
mkdir rawfastq
mv rename.txt rawfastq/
cd rawfastq

rsync -aP --exclude='*SCH*' /mnt/research/ShadeLab/Shade/20141230_16Stag_Centralia/20141230_B_16S_PE/* .
rsync -aP /mnt/research/ShadeLab/Shade/20141230_16Stag_Centralia/20141230_A_16S_PE/* .

#unzip files
gunzip *gz

## rename files
while read line; do eval mv $line; done < rename.txt

cd ..

### i.  Merge and quality filter paired-end fastq reads
mkdir mergedfastq

for file in $(<merge_fq_list.txt)
do

    usearch -fastq_mergepairs rawfastq/${file}.fastq -fastqout mergedfastq/${file}_merged.fastq -relabel @ -fastq_merge_maxee 1.0 -fastq_minmergelen 250 -fastq_maxmergelen 274 -fastq_nostagger

done

### ii.  Pool all merged-paired ends across samples
mv rename.txt ..

find ./mergedfastq -type f -name '*fastq' -exec cat '{}' > combined_merged.fastq ';'

## output file:
### combined_merged.fastq

### clean-up: remove unmerged raw file directory
rm -rf rawfastq/

## clean-up: remove merged, uncombined file directory
rm -rf mergedfastq/

### iii.  De-replicate
usearch -derep_fulllength combined_merged.fastq -fastqout uniques_combined_merged.fastq -sizeout

## output file:
### uniques_combined_merged.fastq

### iv.  Remove single sequences
usearch -sortbysize uniques_combined_merged.fastq -fastqout nosigs_uniques_combined_merged.fastq -minsize 2

## output file:
### nosigs_uniques_combined_merged.fastq

### v. Precluster (denoise) - for our dataset on the 64-bit usearch, this takes ~1 hour to run.
usearch -cluster_fast nosigs_uniques_combined_merged.fastq -centroids_fastq denoised_nosigs_uniques_combined_merged.fastq -id 0.9 -maxdiffs 5 -abskew 10 -sizein -sizeout -sort size

## output file:
### denoised_nosigs_uniques_combined_merged.fastq

### vi.  Remove sequences that match 100% to our craptaminant database
#usearch -search_exact denoised_nosigs_uniques_combined_merged.fastq -db mock_craptaminant_OTU_db.fa -notmatchedfq nocrap_denoised_nosigs_uniques_combined_merged.fastq -strand plus -matchedfq craptaminantSeqs_denoised_nosigs_uniques_combined_merged.fastq

## output files:
### craptaminantOTUs_denoised_nosigs_uniques_combined_merged.fa;
### nocrap_denoised_nosigs_uniques_combined_merged.fastq

### vi.  Reference-based OTU picking using usearch_global: Cluster sequences at 97% identity to the greengenes database, version 13.8
#usearch -usearch_global nocrap_denoised_nosigs_uniques_combined_merged.fastq -id 0.97 -db /mnt/research/ShadeLab/SharedResources/gg_13_8_otus/rep_set/97_otus.fasta -notmatchedfq RefNoMatch_nocrap_denoised_nosigs_uniques_combined_merged.fastq -strand plus -uc RefMatchOTUMap_nocrap_denoised_nosigs_uniques_combined_merged.uc -dbmatched gg_97_rep_set_matched.fa

#if part vi (craptaminant removal) is skipped, use line below
usearch -usearch_global denoised_nosigs_uniques_combined_merged.fastq -id 0.97 -db /mnt/research/ShadeLab/SharedResources/gg_13_8_otus/rep_set/97_otus.fasta -notmatchedfq RefNoMatch_nocrap_denoised_nosigs_uniques_combined_merged.fastq -strand plus -uc RefMatchOTUMap_nocrap_denoised_nosigs_uniques_combined_merged.uc -dbmatched gg_97_rep_set_matched.fa

## output files:
### RefMatchOTUMap_nocrap_denoised_nosigs_uniques_combined_merged.uc (usearch standard results table);
### RefNoMatch_nocrap_denoised_nosigs_uniques_combined_merged.fastq (sequences that did not hit the gg db and need to be clustered de novo)
### gg_97_rep_set_matched.fa (gg 97_rep_set matches to our dataset - add to MASTER OTU rep. sequences)

### vii.  De novo OTU picking using uclust:  cluster sequences at 97% identity (includes chimera checking with uparse), and omits singletons
usearch -cluster_otus RefNoMatch_nocrap_denoised_nosigs_uniques_combined_merged.fastq -minsize 2 -otus DeNovoUclustOTUs_RefNoMatch_nocrap_denoised_nosigs_uniques_combined_merged.fa -relabel OTU_dn_ -uparseout DeNovoUclustResults_RefNoMatch_nocrap_denoised_nosigs_uniques_combined_merged.up

## output files:
### DeNovoUclustOTUs_RefNoMatch_nocrap_denoised_nosigs_uniques_combined_merged.fa (representative sequences for de novo OTUs)
### DeNovoUclustResults_RefNoMatch_nocrap_denoised_nosigs_uniques_combined_merged.up (uparse standard results table)

### viii.  Combine ref-based and de novo representative OTU sequences into one master OTU "db" file.
cat gg_97_rep_set_matched.fa DeNovoUclustOTUs_RefNoMatch_nocrap_denoised_nosigs_uniques_combined_merged.fa > RepSeqs.fa

## output files:
### RepSeqs.fa

### ix.  Map all sequences (pre-dereplication) back to OTU definitions using usearch_global.  Any sequences that do not hit the new OTU database are discarded.
usearch -usearch_global combined_merged.fastq -db RepSeqs.fa  -strand plus -id 0.97 -uc OTU_map.uc -biomout OTU_jsn.biom

## output files:
### OTU_map.uc (usearch standard results file)
### OTU_jsn.biom (biom-formatted table - jason format; this will be converted to hdf5 when we move into QIIME)


###xi Align sequences to the Silva v123 template using QIIME
### Use anaconda with python2 and the QIIME 1.9.1 install
source /mnt/research/ShadeLab/software/loadanaconda2.sh

#default alignment minimum is 75% of the sequence length
align_seqs.py -i RepSeqs.fa -t /mnt/research/ShadeLab/SharedResources/SILVA123_QIIME_release/core_alignment/core_alignment_SILVA123.fasta -o qiime191_pynast_silva123/


#convert jsn BIOM table to hdf5
biom convert -i OTU_jsn.biom -o OTU_hdf5.biom --table-type="OTU table" --to-hdf5

#filter failed alignments from OTU table
filter_otus_from_otu_table.py -i OTU_hdf5.biom -o OTU_hdf5_filteredfailedalignments.biom -e qiime191_pynast_silva123/RepSeqs_failures.fasta

#filter failed alignments from RepSeqs file
filter_fasta.py -f RepSeqs.fa -o MASTER_RepSeqs_filteredfailedalignments.fa -a qiime191_pynast_silva123/RepSeqs_aligned.fasta

## output files
### /qiime191_pynast_silva123/RepSeqs_failures.fasta
### /qiime191_pynast_silva123/RepSeqs_aligned.fasta
### /qiime191_pynast_silva123/RepSeqs_log.txt
### OTU_hdf5.biom
### OTU_hdf5_filteredfailedalignments.biom
### MASTER_RepSeqs_filteredfailedalignments.fa

###xii.  Classify sequences using the RDP Classifier v. 2.0 with the greenegenes 97% OTU database v. 13.8; classifier re-training and assignment uses the QIIME v 1.9.1 workflow
#use QIIME RDP Classifier 2.2 to assign taxonomy with greengenes database
#module load RDPClassifier/2.2

#export RDP_JAR_PATH=/opt/software/QIIME/1.8.0--GCC-4.4.5/rdpclassifier-2.2-release/rdp_classifier-2.2.jar

assign_taxonomy.py -i MASTER_RepSeqs_filteredfailedalignments.fa -m rdp -c 0.8 -t /mnt/research/ShadeLab/SharedResources/gg_13_8_otus/taxonomy/97_otu_taxonomy.txt -r /mnt/research/ShadeLab/SharedResources/gg_13_8_otus/rep_set/97_otus.fasta -o rdp_assigned_taxonomy22/

#add taxonomy as metadata to hdf5 biom table
echo "#OTUID"$'\t'"taxonomy"$'\t'"confidence" > templine.txt

cat  templine.txt rdp_assigned_taxonomy22/MASTER_RepSeqs_filteredfailedalignments_tax_assignments.txt >> rdp_assigned_taxonomy22/MASTER_RepSeqs_filteredfailedalignments_tax_assignments_header.txt

#source /mnt/research/ShadeLab/software/loadanaconda2.sh

biom add-metadata -i OTU_hdf5_filteredfailedalignments.biom -o MASTER_OTU_hdf5_filteredfailedalignments_rdp.biom --observation-metadata-fp rdp_assigned_taxonomy22/MASTER_RepSeqs_filteredfailedalignments_tax_assignments_header.txt --sc-separated taxonomy --observation-header OTUID,taxonomy

rm templine.txt

## output files
### rdp_assigned_taxonomy/MASTER_RepSeqs_filteredfailedalignments_tax_assignments.log
### rdp_assigned_taxonomy/MASTER_RepSeqs_filteredfailedalignments_tax_assignments.txt
### rdp_assigned_taxonomy/MASTER_RepSeqs_filteredfailedalignments_tax_assignment_header.txt
### MASTER_OTU_hdf5_filteredfailedalignments_rdp.biom

###xii.  Make phylogeny
#make phylogenetic tree using FastTree (default) QIIME method, version
make_phylogeny.py -i qiime191_pynast_silva123/RepSeqs_aligned.fasta -o MASTER_RepSeqs_aligned.tre

###xiii.  Subsampling and collapsing the OTU table-type using QIIME 1.9.1
single_rarefaction.py -i MASTER_OTU_hdf5_filteredfailedalignments_rdp.biom -o MASTER_OTU_hdf5_filteredfailedalignments_rdp_even53116.biom -d 53116

collapse_samples.py -b MASTER_OTU_hdf5_filteredfailedalignments_rdp.biom -m Centralia_Full_Map.txt --output_biom_fp MASTER_OTU_hdf5_filteredfailedalignments_rdp_collapse.biom --output_mapping_fp Centralia_Collapsed_Map.txt --collapse_mode sum --collapse_fields Sample

#includes mock community sample
single_rarefaction.py -i MASTER_OTU_hdf5_filteredfailedalignments_rdp_collapse.biom -o MASTER_OTU_hdf5_filteredfailedalignments_rdp_collapse_even227768.biom -d 227100

#discludes mock community sample
single_rarefaction.py -i MASTER_OTU_hdf5_filteredfailedalignments_rdp_collapse.biom -o MASTER_OTU_hdf5_filteredfailedalignments_rdp_collapse_even321798.biom -d 321000

#rarefaction analysis on collapsed dataset
alpha_rarefaction.py -i MASTER_OTU_hdf5_filteredfailedalignments_rdp_collapse.biom -m Centralia_Collapsed_Map.txt -a -n 25 -o alpha_rarefaction_collapsed/

### MASTER_OTU_hdf5_filteredfailedalignments_rdp_even53116.biom
### MASTER_OTU_hdf5_filteredfailedalignments_rdp_collapse.biom
### Centralia_Collapsed_Map.txt
### MASTER_OTU_hdf5_filteredfailedalignments_rdp_collapse_even227768.biom
### MASTER_OTU_hdf5_filteredfailedalignments_rdp_collapse_even321798.biom

###xiv.  Diversity calculations
#make phylogenetic tree using FastTree (default) QIIME method, version
make_phylogeny.py -i qiime191_pynast_silva123/RepSeqs_aligned.fasta -o MASTER_RepSeqs_aligned.tre

#alpha diversity analyses on even, collapsed dataset
alpha_diversity.py -i MASTER_OTU_hdf5_filteredfailedalignments_rdp_collapse_even321798.biom -m PD_whole_tree,observed_otus -t MASTER_RepSeqs_aligned.tre -o MASTER_OTU_hdf5_filteredfailedalignments_rdp_collapse_even321798_alphadiv.txt

#beta diversity analysis on even, collapsed dataset
beta_diversity.py -i MASTER_OTU_hdf5_filteredfailedalignments_rdp_collapse_even321798.biom -t MASTER_RepSeqs_aligned.tre -o betadiv_even321798/ -m unweighted_unifrac,weighted_unifrac,bray_curtis,binary_sorensen_dice

## output files
### MASTER_RepSeqs_aligned.tre
###
 _______________________________________________________________________#
# PBS stats
cat ${PBS_NODEFILE}
env | grep PBS
qstat -f ${PBS_JOBID}
