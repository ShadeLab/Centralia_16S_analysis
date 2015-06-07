# Centralia_16S_analysis
Community analysis for 16S rRNA Tag-sequencing results using QIIME

### Sampling
- 18 of Centralia coal mine fire site soil samples
- Sampling period: 10. 05. 2014 to 10. 06. 2014.
10. 05. 2014 : C01, C02, C03, C04, C05, C06, C07, C08, C09, and C10.
10. 06. 2014 : C11, C12, C13, C14, C15, C16, C17, and C18.
- Collected from 10 cm subsurface (depth)
- Fire front
   Fire front 1: C07, C09, C10, C11, C12, C13, C14, C15, C16, and C18.
   Fire front 2: C01, C02, C03, C04, C05, and C06.
   Reference: C08, and C17
- Classification
   Active vent: C06, C09, C10, C11, C12, C13, and C15.
   Warm: C14, and C16
   Recovered: C01, C02, C03, C04, C05, C07 and C18.
   Reference: C08, and C17

### DNA extraction
- MoBio PowerSoil DNA Isolation kit
- 0.25g of soil used
- DNA concentration (triplicate for each sample = 54 extraction)
=> C18 = 1/10 diluted

### 16S rDNA tag sequencing
- Samples
   C01_D01, C01_D02, C01_D03
   C02_D01, C02_D02, C02_D03
   C03_D01, C03_D02, C03_D03
   C04_D01, C04_D02, C04_D03
   C05_D01, C05_D02, C05_D03
   C06_D01, C06_D02, C06_D03
   C07_D01, C07_D02, C07_D03
   C08_D01, C08_D02, C08_D03
   C09_D04, C09_D05, C09_D06
   C10_D01, C10_D02, C10_D03
   C11_D01, C11_D02, C11_D03
   C12_D01, C12_D02, C12_D03
   C13_D10, C13_D11, C13_D12
   C14_D01, C14_D02, C14_D03
   C15_D01, C15_D02, C15_D03
   C16_D01, C16_D02, C16_D03
   C17_D01, C17_D02, C17_D03
   C18_D04, C18_D05, C18_D06

- Sequence analysis
### Activate qiime 1.9.0 in Amazon EC2 server
1. http://aws.amazon.com/ec2/?nc2=h_ls
2. My Account => AWS management console click 
3. input ID & PW => log in
4. Click “EC2” in left top side
5. Click “launch Instances” in the middle of page
6. Click “Community AMIs” and search “qiime”
7. Find “qiime-190 - ami-ea2a7682” and click “Select”
8. Select “General purpose - m3.large” and click “Next” at right below side
9. Click “Add Storage” at right below side
10. Change “Size (GiB)” (middle of page) from 10 to 100, and click “Next” at right below side
11. Enter value as “Qiime_Tutorial” and click “Next” at right below side
12. Click “Review and Launch”
13. Click “Launch”
14. Select “Choose an existing key pair”, if  you already launched ever.
       If not, choose “Creat a new key pair” and enter the key name.
15. Click “Download Key Pair”. You can find your key at download folder and copy it on Desktop screen.
16. Click “Launch Instances”
17. Click “View Instances”
18. Open your terminal and enter connect command
      Command: ssh ubuntu@ec2-52-1-59-136.compute-1.amazonaws.com -i /home/SHLEE/Desktop/Centralia_subsample_A.pem  

### Activate usearch61
1. copy "usearch6.1.544_i96linux32" and “usearch.236_i86linux32”file into your server
   Command: scp -i /home/SHLEE/Desktop/Centralia_subsample_A.pem -r /home/SHLEE/Desktop/usearch6.1.544_i96linux32 ubuntu@ec2-52-5-253-18.compute-1.amazonaws.com:/home/ubuntu/Tutorial/
scp -i /home/SHLEE/Desktop/Centralia_subsample_A.pem -r /home/SHLEE/Desktop/usearch.236_i86linux32 ubuntu@ec2-52-5-253-18.compute-1.amazonaws.com:/home/ubuntu/Tutorial/
2. cd /usr/local/bin
3. sudo mv ~/CenQIIMELee/usearch6.1.544_i96linux32
4. sudo mv ~/CenQIIMELee/usearch.236_i86linux32
4. sudo mv usearch6.1.544_i96linux32 usearch61
5. sudo chmod 777 /usr/local/bin/usearch61

### Subsampling using “seqtk”
Seqtk install 
1. git clone https://github.com/lh3/seqtk.git
2. sudo make
3. sudo cp seqtk /usr/local/bin
4. ~/mypath/to/seqtk/seqtk 

# Command
Seqtk sample -s100 [filename].fastq 5000 > [outputfilename].fasta
-s ??????

### Merging paired end sequences using Pandaseq
pandaseq -f C01_05102014_R1_D01_GGAGACAAGGGA_L001_R1_001.fastq.gz -r C01_05102014_R1_D01_GGAGACAAGGGA_L001_R2_001.fastq.gz -A simple_bayesian -B -F -w pandaseq_merged_reads/C01_05102014_R1_D01.fasta -l 253 -L 253 -o 47 -O 47 -t 0.9 -g pandaseq_merged_reads/C01_05102014_R1_D01.log

pandaseq 2.8 andre@masella.name Usage: pandaseq -f forward.fastq -r reverse.fastq [-6] [-A algorithm:parameters] [-B] [-C filter] [-D threshold] [-F] [-G log.txt.bz2] [-L length] [-N] [-O length] [-T threads] [-U unaligned.txt] [-W output.fasta.bz2] [-a] [-d flags] [-g log.txt] [-h] [-j] [-k kmers] [-l length] [-o length] [-p primer] [-q primer] [-t threshold] [-u unaligned.txt] [-v] [-w output.fasta]
-A  algorithm: parameters Select the algorithm to use for overlap selection and scoring.
-B  Allow unbarcoded sequences (try this for BADID errors).
-F  Output FASTQ instead of FASTA.
-g log.txt  Output log to a text file.
-l length   Minimum length for a sequence.
-L length   Maximum length for a sequence.
-o length   Minumum overlap region length for a sequence.
-O length   Maximum overlap region length for a sequence. (0 to use read length.)
-t threshold    The minimum probability that a sequence must have to assemble and, if used, match a primer.
-w output.fasta Output seqences to a FASTA (or FASTQ) file.


Known algorithms are ea_util, flash, pear, rdp_mle, simple_bayesian, stitch, uparse.
-For run-
#C01
pandaseq -f C01_05102014_R1_D01_GGAGACAAGGGA_L001_R1_001.fastq.gz -r C01_05102014_R1_D01_GGAGACAAGGGA_L001_R2_001.fastq.gz -A simple_bayesian -B -F -w pandaseq_merged_reads/C01_05102014_R1_D01.fasta -l 253 -L 253 -o 47 -O 47 -t 0.9 -g pandaseq_merged_reads/C01_05102014_R1_D01.log

pandaseq -f C01_05102014_R1_D02_AATCAGTCTCGT_L001_R1_001.fastq.gz -r C01_05102014_R1_D02_AATCAGTCTCGT_L001_R2_001.fastq.gz -A simple_bayesian -B -F -w pandaseq_merged_reads/C01_05102014_R1_D02.fasta -l 253 -L 253 -o 47 -O 47 -t 0.9 -g pandaseq_merged_reads/C01_05102014_R1_D02.log

pandaseq -f C01_05102014_R1_D03_AATCCGTACAGC_L001_R1_001.fastq.gz -r C01_05102014_R1_D03_AATCCGTACAGC_L001_R2_001.fastq.gz -A simple_bayesian -B -F -w pandaseq_merged_reads/C01_05102014_R1_D03.fasta -l 253 -L 253 -o 47 -O 47 -t 0.9 -g pandaseq_merged_reads/C01_05102014_R1_D03.log

#C02
pandaseq -f C02_05102014_R1_D01_ACACCTGGTGAT_L001_R1_001.fastq.gz -r C02_05102014_R1_D01_ACACCTGGTGAT_L001_R2_001.fastq.fastq.gz -A simple_bayesian -B -F -w pandaseq_merged_reads/ C02_05102014_R1_D01.fasta -l 253 -L 253 -o 47 -O 47 -t 0.9 -g pandaseq_merged_reads/ C02_05102014_R1_D01.log

pandaseq -f C02_05102014_R1_D02_TATCGTTGACCA_L001_R1_001.fastq.gz -r C02_05102014_R1_D02_TATCGTTGACCA_L001_R2_001.fastq.gz -A simple_bayesian -B -F -w pandaseq_merged_reads/ C02_05102014_R1_D02.fasta -l 253 -L 253 -o 47 -O 47 -t 0.9 -g pandaseq_merged_reads/ C02_05102014_R1_D02.log

pandaseq -f C02_05102014_R1_D03_TTACTGTGCGAT_L001_R1_001.fastq.gz -r C02_05102014_R1_D03_TTACTGTGCGAT_L001_R2_001.fastq.gz -A simple_bayesian -B -F -w pandaseq_merged_reads/ C02_05102014_R1_D03.fasta -l 253 -L 253 -o 47 -O 47 -t 0.9 -g pandaseq_merged_reads/ C02_05102014_R1_D03.log

#C03
pandaseq -f C03_05102014_R1_D01_AGGCTACACGAC_L001_R1_001.fastq.gz -r C03_05102014_R1_D01_AGGCTACACGAC_L001_R2_001.fastq.gz -A simple_bayesian -B -F -w pandaseq_merged_reads/ C03_05102014_R1_D01.fasta -l 253 -L 253 -o 47 -O 47 -t 0.9 -g pandaseq_merged_reads/ C03_05102014_R1_D01.log

pandaseq -f C03_05102014_R1_D02_CTAACCTCCGCT_L001_R1_001.fastq.gz -r C03_05102014_R1_D02_CTAACCTCCGCT_L001_R2_001.fastq.gz -A simple_bayesian -B -F -w pandaseq_merged_reads/ C03_05102014_R1_D02.fasta -l 253 -L 253 -o 47 -O 47 -t 0.9 -g pandaseq_merged_reads/ C03_05102014_R1_D02.log

pandaseq -f C03_05102014_R1_D03_GAACCAAAGGAT_L001_R1_001.fastq.gz -r C03_05102014_R1_D03_GAACCAAAGGAT_L001_R2_001.fastq.gz -A simple_bayesian -B -F -w pandaseq_merged_reads/ C03_05102014_R1_D03.fasta -l 253 -L 253 -o 47 -O 47 -t 0.9 -g pandaseq_merged_reads/ C03_05102014_R1_D02.log

# C04
pandaseq -f C04_05102014_R1_D01_GTATGCGCTGTA_L001_R1_001.fastq.gz -r C04_05102014_R1_D01_GTATGCGCTGTA_L001_R2_001.fastq.gz -A simple_bayesian -B -F -w pandaseq_merged_reads/ C04_05102014_R1_D01.fasta -l 253 -L 253 -o 47 -O 47 -t 0.9 -g pandaseq_merged_reads/ C04_05102014_R1_D01.log

pandaseq -f C04_05102014_R1_D01_GTATGCGCTGTA_L001_R1_001.fastq.gz -r C04_05102014_R1_D01_GTATGCGCTGTA_L001_R2_001.fastq.gz -A simple_bayesian -B -F -w pandaseq_merged_reads/ C04_05102014_R1_D02.fasta -l 253 -L 253 -o 47 -O 47 -t 0.9 -g pandaseq_merged_reads/ C04_05102014_R1_D02.log

pandaseq -f C04_05102014_R1_D03_TCCGACACAATT_L001_R1_001.fastq.gz -r C04_05102014_R1_D03_TCCGACACAATT_L001_R2_001.fastq.gz -A simple_bayesian -B -F -w pandaseq_merged_reads/ C04_05102014_R1_D03.fasta -l 253 -L 253 -o 47 -O 47 -t 0.9 -g pandaseq_merged_reads/ C04_05102014_R1_D03.log

#C05
pandaseq -f C05_05102014_R1_D01_CCAGTGTATGCA_L001_R1_001.fastq.gz -r C05_05102014_R1_D01_CCAGTGTATGCA_L001_R2_001.fastq.gz -A simple_bayesian -B -F -w pandaseq_merged_reads/ C05_05102014_R1_D01.fasta -l 253 -L 253 -o 47 -O 47 -t 0.9 -g pandaseq_merged_reads/ C05_05102014_R1_D01.log

pandaseq -f C05_05102014_R1_D02_CCTCGTTCGACT_L001_R1_001.fastq.gz -r C05_05102014_R1_D02_CCTCGTTCGACT_L001_R2_001.fastq.gz -A simple_bayesian -B -F -w pandaseq_merged_reads/ C05_05102014_R1_D02.fasta -l 253 -L 253 -o 47 -O 47 -t 0.9 -g pandaseq_merged_reads/ C05_05102014_R1_D02.log

pandaseq -f C05_05102014_R1_D03_TGAGTCACTGGT_L001_R1_001.fastq.gz -r C05_05102014_R1_D03_TGAGTCACTGGT_L001_R2_001.fastq.gz -A simple_bayesian -B -F -w pandaseq_merged_reads/ C05_05102014_R1_D03.fasta -l 253 -L 253 -o 47 -O 47 -t 0.9 -g pandaseq_merged_reads/ C05_05102014_R1_D03.log

# C06
pandaseq -f C06_05102014_R1_D01_GACTTGGTATTC_L001_R1_001.fastq.gz -r C06_05102014_R1_D01_GACTTGGTATTC_L001_R2_001.fastq.gz -A simple_bayesian -B -F -w pandaseq_merged_reads/ C06_05102014_R1_D01.fasta -l 253 -L 253 -o 47 -O 47 -t 0.9 -g pandaseq_merged_reads/ C06_05102014_R1_D01.log

pandaseq -f C06_05102014_R1_D02_TACACGATCTAC_L001_R1_001.fastq.gz -r C06_05102014_R1_D02_TACACGATCTAC_L001_R2_001.fastq.gz -A simple_bayesian -B -F -w pandaseq_merged_reads/ C06_05102014_R1_D02.fasta -l 253 -L 253 -o 47 -O 47 -t 0.9 -g pandaseq_merged_reads/ C06_05102014_R1_D02.log

pandaseq -f C06_05102014_R1_D03_GCACACACGTTA_L001_R1_001.fastq.gz -r C06_05102014_R1_D03_GCACACACGTTA_L001_R2_001.fastq.gz -A simple_bayesian -B -F -w pandaseq_merged_reads/ C06_05102014_R1_D03.fasta -l 253 -L 253 -o 47 -O 47 -t 0.9 -g pandaseq_merged_reads/ C06_05102014_R1_D03.log

#C07
pandaseq -f C07_05102014_R1_D01_CACGCCATAATG_L001_R1_001.fastq.gz -r C07_05102014_R1_D01_CACGCCATAATG_L001_R2_001.fastq.gz -A simple_bayesian -B -F -w pandaseq_merged_reads/ C07_05102014_R1_D01.fasta -l 253 -L 253 -o 47 -O 47 -t 0.9 -g pandaseq_merged_reads/ C07_05102014_R1_D01.log

pandaseq -f C07_05102014_R1_D02_CAGGCGTATTGG_L001_R1_001.fastq.gz -r C07_05102014_R1_D02_CAGGCGTATTGG_L001_R2_001.fastq.gz -A simple_bayesian -B -F -w pandaseq_merged_reads/ C07_05102014_R1_D02.fasta -l 253 -L 253 -o 47 -O 47 -t 0.9 -g pandaseq_merged_reads/ C07_05102014_R1_D02.log

pandaseq -f C07_05102014_R1_D03_GGATCGCAGATC_L001_R1_001.fastq.gz -r C07_05102014_R1_D03_GGATCGCAGATC_L001_R2_001.fastq.gz -A simple_bayesian -B -F -w pandaseq_merged_reads/ C07_05102014_R1_D03.fasta -l 253 -L 253 -o 47 -O 47 -t 0.9 -g pandaseq_merged_reads/ C07_05102014_R1_D03.log

#C08
pandaseq -f C08_05102014_R1_D01_GCTGATGAGCTG_L001_R1_001.fastq.gz -r C08_05102014_R1_D01_GCTGATGAGCTG_L001_R2_001.fastq.gz -A simple_bayesian -B -F -w pandaseq_merged_reads/ C08_05102014_R1_D01.fasta -l 253 -L 253 -o 47 -O 47 -t 0.9 -g pandaseq_merged_reads/ C08_05102014_R1_D01.log

pandaseq -f C08_05102014_R1_D02_AGCTGTTGTTTG_L001_R1_001.fastq.gz -r C08_05102014_R1_D02_AGCTGTTGTTTG_L001_R2_001.fastq.gz -A simple_bayesian -B -F -w pandaseq_merged_reads/ C08_05102014_R1_D02.fasta -l 253 -L 253 -o 47 -O 47 -t 0.9 -g pandaseq_merged_reads/ C08_05102014_R1_D02.log

pandaseq -f C08_05102014_R1_D03_GGATGGTGTTGC_L001_R1_001.fastq.gz -r C08_05102014_R1_D03_GGATGGTGTTGC_L001_R2_001.fastq.gz -A simple_bayesian -B -F -w pandaseq_merged_reads/ C08_05102014_R1_D03.fasta -l 253 -L 253 -o 47 -O 47 -t 0.9 -g pandaseq_merged_reads/ C08_05102014_R1_D03.log

#C09
pandaseq -f C09_05102014_R2_D04_GCGATATATCGC_L001_R1_001.fastq.gz -r C09_05102014_R2_D04_GCGATATATCGC_L001_R2_001.fastq.gz -A simple_bayesian -B -F -w pandaseq_merged_reads/ C09_05102014_R1_D04.fasta -l 253 -L 253 -o 47 -O 47 -t 0.9 -g pandaseq_merged_reads/ C09_05102014_R4_D01.log

pandaseq -f C09_05102014_R2_D05_TAGGATTGCTCG_L001_R1_001.fastq.gz -r C09_05102014_R2_D05_TAGGATTGCTCG_L001_R2_001.fastq.gz -A simple_bayesian -B -F -w pandaseq_merged_reads/ C09_05102014_R1_D05.fasta -l 253 -L 253 -o 47 -O 47 -t 0.9 -g pandaseq_merged_reads/ C09_05102014_R5_D02.log

pandaseq -f C09_05102014_R2_D06_ATGTGCACGACT_L001_R1_001.fastq.gz -r C09_05102014_R2_D06_ATGTGCACGACT_L001_R2_001.fastq.gz -A simple_bayesian -B -F -w pandaseq_merged_reads/ C09_05102014_R1_D06.fasta -l 253 -L 253 -o 47 -O 47 -t 0.9 -g pandaseq_merged_reads/ C09_05102014_R6_D03.log

#C10
pandaseq -f C10_05102014_R1_D01_ACGCGCAGATAC_L001_R1_001.fastq.gz -r C10_05102014_R1_D01_ACGCGCAGATAC_L001_R2_001.fastq.gz -A simple_bayesian -B -F -w pandaseq_merged_reads/ C10_05102014_R1_D01.fasta -l 253 -L 253 -o 47 -O 47 -t 0.9 -g pandaseq_merged_reads/ C10_05102014_R1_D01.log

pandaseq -f C10_05102014_R1_D02_GACTTTCCCTCG_L001_R1_001.fastq.gz -r C10_05102014_R1_D02_GACTTTCCCTCG_L001_R2_001.fastq.gz -A simple_bayesian -B -F -w pandaseq_merged_reads/ C10_05102014_R1_D02.fasta -l 253 -L 253 -o 47 -O 47 -t 0.9 -g pandaseq_merged_reads/ C10_05102014_R1_D02.log

pandaseq -f C10_05102014_R1_D03_ATCCCGAATTTG_L001_R1_001.fastq.gz -r C10_05102014_R1_D03_ATCCCGAATTTG_L001_R2_001.fastq.gz -A simple_bayesian -B -F -w pandaseq_merged_reads/ C10_05102014_R1_D03.fasta -l 253 -L 253 -o 47 -O 47 -t 0.9 -g pandaseq_merged_reads/ C10_05102014_R1_D03.log

#C11
pandaseq -f C11_06102014_R1_D01_GTTGGTCAATCT_L001_R1_001.fastq.gz -r C11_06102014_R1_D01_GTTGGTCAATCT_L001_R2_001.fastq.gz -A simple_bayesian -B -F -w pandaseq_merged_reads/ C11_06102014_R1_D01.fasta -l 253 -L 253 -o 47 -O 47 -t 0.9 -g pandaseq_merged_reads/ C11_06102014_R1_D01.log

pandaseq -f C11_06102014_R1_D02_TAGCTCGTAACT_L001_R1_001.fastq.gz -r C11_06102014_R1_D02_TAGCTCGTAACT_L001_R2_001.fastq.gz -A simple_bayesian -B -F -w pandaseq_merged_reads/ C11_06102014_R1_D02.fasta -l 253 -L 253 -o 47 -O 47 -t 0.9 -g pandaseq_merged_reads/ C11_06102014_R1_D02.log

pandaseq -f C11_06102014_R1_D03_CAGTGCATATGC_L001_R1_001.fastq.gz -r C11_06102014_R1_D03_CAGTGCATATGC_L001_R2_001.fastq.gz -A simple_bayesian -B -F -w pandaseq_merged_reads/ C11_06102014_R1_D03.fasta -l 253 -L 253 -o 47 -O 47 -t 0.9 -g pandaseq_merged_reads/ C11_06102014_R1_D03.log

#C12
pandaseq -f C12_06102014_R2_D01_TCACGGGAGTTG_L001_R1_001.fastq.gz -r C12_06102014_R2_D01_TCACGGGAGTTG_L001_R2_001.fastq.gz -A simple_bayesian -B -F -w pandaseq_merged_reads/ C12_06102014_R1_D01.fasta -l 253 -L 253 -o 47 -O 47 -t 0.9 -g pandaseq_merged_reads/ C12_06102014_R1_D01.log

pandaseq -f C12_06102014_R2_D02_CTGCTAACGCAA_L001_R1_001.fastq.gz -r C12_06102014_R2_D02_CTGCTAACGCAA_L001_R2_001.fastq.gz -A simple_bayesian -B -F -w pandaseq_merged_reads/ C12_06102014_R1_D02.fasta -l 253 -L 253 -o 47 -O 47 -t 0.9 -g pandaseq_merged_reads/ C12_06102014_R1_D02.log

pandaseq -f C12_06102014_R2_D03_TTAGGGCTCGTA_L001_R1_001.fastq.gz -r C12_06102014_R2_D03_TTAGGGCTCGTA_L001_R2_001.fastq.gz -A simple_bayesian -B -F -w pandaseq_merged_reads/ C12_06102014_R1_D03.fasta -l 253 -L 253 -o 47 -O 47 -t 0.9 -g pandaseq_merged_reads/ C12_06102014_R1_D03.log

#C13
pandaseq -f C13_06102014_R2_D10_CGCAGCGGTATA_L001_R1_001.fastq.gz -r C13_06102014_R2_D10_CGCAGCGGTATA_L001_R2_001.fastq.gz -A simple_bayesian -B -F -w pandaseq_merged_reads/ C13_06102014_R10_D01.fasta -l 253 -L 253 -o 47 -O 47 -t 0.9 -g pandaseq_merged_reads/ C13_06102014_R10_D01.log

pandaseq -f C13_06102014_R2_D11_AATGCCTCAACT_L001_R1_001.fastq.gz -r C13_06102014_R2_D11_AATGCCTCAACT_L001_R2_001.fastq.gz -A simple_bayesian -B -F -w pandaseq_merged_reads/ C13_06102014_R11_D02.fasta -l 253 -L 253 -o 47 -O 47 -t 0.9 -g pandaseq_merged_reads/ C13_06102014_R11_D02.log

pandaseq -f C13_06102014_R2_D12_GGTGTCTATTGT_L001_R1_001.fastq.gz -r C13_06102014_R2_D12_GGTGTCTATTGT_L001_R2_001.fastq.gz -A simple_bayesian -B -F -w pandaseq_merged_reads/ C13_06102014_R12_D03.fasta -l 253 -L 253 -o 47 -O 47 -t 0.9 -g pandaseq_merged_reads/ C13_06102014_R12_D03.log

#C14
pandaseq -f C14_06102014_R1_D01_AAGAGATGTCGA_L001_R1_001.fastq.gz -r C14_06102014_R1_D01_AAGAGATGTCGA_L001_R2_001.fastq.gz -A simple_bayesian -B -F -w pandaseq_merged_reads/ C14_06102014_R1_D01.fasta -l 253 -L 253 -o 47 -O 47 -t 0.9 -g pandaseq_merged_reads/ C14_06102014_R1_D01.log

pandaseq -f C14_06102014_R1_D02_TCCAAAGTGTTC_L001_R1_001.fastq.gz -r C14_06102014_R1_D02_TCCAAAGTGTTC_L001_R2_001.fastq.gz -A simple_bayesian -B -F -w pandaseq_merged_reads/ C14_06102014_R1_D02.fasta -l 253 -L 253 -o 47 -O 47 -t 0.9 -g pandaseq_merged_reads/ C14_06102014_R1_D02.log

pandaseq -f C14_06102014_R1_D03_TACAGATGGCTC_L001_R1_001.fastq.gz -r C14_06102014_R1_D03_TACAGATGGCTC_L001_R2_001.fastq.gz -A simple_bayesian -B -F -w pandaseq_merged_reads/ C14_06102014_R1_D03.fasta -l 253 -L 253 -o 47 -O 47 -t 0.9 -g pandaseq_merged_reads/ C14_06102014_R1_D03.log

#C15
pandaseq -f C15_06102014_R2_D01_ACGTGTACCCAA_L001_R1_001.fastq.gz -r C15_06102014_R2_D01_ACGTGTACCCAA_L001_R2_001.fastq.gz -A simple_bayesian -B -F -w pandaseq_merged_reads/ C15_06102014_R1_D01.fasta -l 253 -L 253 -o 47 -O 47 -t 0.9 -g pandaseq_merged_reads/ C15_06102014_R1_D01.log

pandaseq -f C15_06102014_R2_D02_AAGGAGCGCCTT_L001_R1_001.fastq.gz -r C15_06102014_R2_D02_AAGGAGCGCCTT_L001_R2_001.fastq.gz -A simple_bayesian -B -F -w pandaseq_merged_reads/ C15_06102014_R1_D02.fasta -l 253 -L 253 -o 47 -O 47 -t 0.9 -g pandaseq_merged_reads/ C15_06102014_R1_D02.log

pandaseq -f C15_06102014_R2_D03_CGATCCGTATTA_L001_R1_001.fastq.gz -r C15_06102014_R2_D03_CGATCCGTATTA_L001_R2_001.fastq.gz -A simple_bayesian -B -F -w pandaseq_merged_reads/ C15_06102014_R1_D03.fasta -l 253 -L 253 -o 47 -O 47 -t 0.9 -g pandaseq_merged_reads/ C15_06102014_R1_D03.log

#C16
pandaseq -f C16_06102014_R1_D01_GTCTAATTCCGA_L001_R1_001.fastq.gz -r C16_06102014_R1_D01_GTCTAATTCCGA_L001_R2_001.fastq.gz -A simple_bayesian -B -F -w pandaseq_merged_reads/ C16_06102014_R1_D01.fasta -l 253 -L 253 -o 47 -O 47 -t 0.9 -g pandaseq_merged_reads/ C16_06102014_R1_D01.log

pandaseq -f C16_06102014_R1_D02_TCCGAATTCACA_L001_R1_001.fastq.gz -r C16_06102014_R1_D02_TCCGAATTCACA_L001_R2_001.fastq.gz -A simple_bayesian -B -F -w pandaseq_merged_reads/ C16_06102014_R1_D02.fasta -l 253 -L 253 -o 47 -O 47 -t 0.9 -g pandaseq_merged_reads/ C16_06102014_R1_D02.log

pandaseq -f C16_06102014_R1_D03_ACGCCACGAATG_L001_R1_001.fastq.gz -r C16_06102014_R1_D03_ACGCCACGAATG_L001_R2_001.fastq.gz -A simple_bayesian -B -F -w pandaseq_merged_reads/ C16_06102014_R1_D03.fasta -l 253 -L 253 -o 47 -O 47 -t 0.9 -g pandaseq_merged_reads/ C16_06102014_R1_D03.log

#C17
pandaseq -f C17_06102014_R1_D01_GGCCACGTAGTA_L001_R1_001.fastq.gz -r C17_06102014_R1_D01_GGCCACGTAGTA_L001_R2_001.fastq.gz -A simple_bayesian -B -F -w pandaseq_merged_reads/ C17_06102014_R1_D01.fasta -l 253 -L 253 -o 47 -O 47 -t 0.9 -g pandaseq_merged_reads/ C17_06102014_R1_D01.log

pandaseq -f C17_06102014_R1_D02_TAGGAACTGGCC_L001_R1_001.fastq.gz -r C17_06102014_R1_D02_TAGGAACTGGCC_L001_R2_001.fastq.gz -A simple_bayesian -B -F -w pandaseq_merged_reads/ C17_06102014_R1_D02.fasta -l 253 -L 253 -o 47 -O 47 -t 0.9 -g pandaseq_merged_reads/ C17_06102014_R1_D02.log

pandaseq -f C17_06102014_R1_D03_CTAGCGAACATC_L001_R1_001.fastq.gz -r C17_06102014_R1_D03_CTAGCGAACATC_L001_R2_001.fastq.gz -A simple_bayesian -B -F -w pandaseq_merged_reads/ C17_06102014_R1_D03.fasta -l 253 -L 253 -o 47 -O 47 -t 0.9 -g pandaseq_merged_reads/ C17_06102014_R1_D03.log

#C18
pandaseq -f C18_06102014_RE1_D04_GACAGGAGATAG_L001_R1_001.fastq.gz -r C18_06102014_RE1_D04_GACAGGAGATAG_L001_R2_001.fastq.gz -A simple_bayesian -B -F -w pandaseq_merged_reads/ C18_06102014_R1_D04.fasta -l 253 -L 253 -o 47 -O 47 -t 0.9 -g pandaseq_merged_reads/ C18_06102014_R1_D01.log

pandaseq -f C18_06102014_RE1_D05_ATTCCTGTGAGT_L001_R1_001.fastq.gz -r C18_06102014_RE1_D05_ATTCCTGTGAGT_L001_R2_001.fastq.gz -A simple_bayesian -B -F -w pandaseq_merged_reads/ C18_06102014_R1_D05.fasta -l 253 -L 253 -o 47 -O 47 -t 0.9 -g pandaseq_merged_reads/ C18_06102014_R1_D02.log

pandaseq -f C18_06102014_RE1_D06_GAGGCTCATCAT_L001_R1_001.fastq.gz -r C18_06102014_RE1_D06_GAGGCTCATCAT_L001_R2_001.fastq.gz -A simple_bayesian -B -F -w pandaseq_merged_reads/ C18_06102014_R1_D06.fasta -l 253 -L 253 -o 47 -O 47 -t 0.9 -g pandaseq_merged_reads/ C18_06102014_R1_D03.log

### Sequence quality check quality scores (based on PRHED +33) using fastqc
Command: 
fastqc C01_05102014_R1_D01.fasta
fastqc C01_05102014_R1_D02.fasta
fastqc C01_05102014_R1_D03.fasta
fastqc C02_05102014_R1_D01.fasta
fastqc C02_05102014_R1_D02.fasta
fastqc C02_05102014_R1_D03.fasta
fastqc C03_05102014_R1_D01.fasta
fastqc C03_05102014_R1_D02.fasta
fastqc C03_05102014_R1_D03.fasta
fastqc C04_05102014_R1_D01.fasta
fastqc C04_05102014_R1_D02.fasta
fastqc C04_05102014_R1_D03.fasta
fastqc C05_05102014_R1_D01.fasta
fastqc C05_05102014_R1_D02.fasta
fastqc C05_05102014_R1_D03.fasta
fastqc C06_05102014_R1_D01.fasta
fastqc C06_05102014_R1_D02.fasta
fastqc C06_05102014_R1_D03.fasta
fastqc C07_05102014_R1_D01.fasta
fastqc C07_05102014_R1_D02.fasta
fastqc C07_05102014_R1_D03.fasta
fastqc C08_05102014_R1_D01.fasta
fastqc C08_05102014_R1_D02.fasta
fastqc C08_05102014_R1_D03.fasta
fastqc C09_05102014_R1_D04.fasta
fastqc C09_05102014_R1_D05.fasta
fastqc C09_05102014_R1_D06.fasta
fastqc C10_05102014_R1_D01.fasta
fastqc C10_05102014_R1_D02.fasta
fastqc C10_05102014_R1_D03.fasta
fastqc C11_06102014_R1_D01.fasta
fastqc C11_06102014_R1_D02.fasta
fastqc C11_06102014_R1_D03.fasta
fastqc C12_06102014_R1_D01.fasta
fastqc C12_06102014_R1_D02.fasta
fastqc C12_06102014_R1_D03.fasta
fastqc C13_06102014_R1_D10.fasta
fastqc C13_06102014_R1_D11.fasta
fastqc C13_06102014_R1_D12.fasta
fastqc C14_06102014_R1_D01.fasta
fastqc C14_06102014_R1_D02.fasta
fastqc C14_06102014_R1_D03.fasta
fastqc C15_06102014_R1_D01.fasta
fastqc C15_06102014_R1_D02.fasta
fastqc C15_06102014_R1_D03.fasta
fastqc C16_06102014_R1_D01.fasta
fastqc C16_06102014_R1_D02.fasta
fastqc C16_06102014_R1_D03.fasta
fastqc C17_06102014_R1_D01.fasta
fastqc C17_06102014_R1_D02.fasta
fastqc C17_06102014_R1_D03.fasta
fastqc C18_06102014_R1_D04.fasta
fastqc C18_06102014_R1_D05.fasta
fastqc C18_06102014_R1_D06.fasta


### Correcting of mapping file.
Command : validate_mapping_file.py -m Cen_full_mapping.txt   
-m  --mapping_fp
          ; Metadata mapping filepath


### split fasta and qual file from fastq file.
Command: convert_fastaqual_fastq.py -f pandaseq_merged_reads/[filename].fasta -c fastq_to_fastaqual -o split_fasta_qual/
-f, --fasta_file_path; Input FASTA or FASTQ file.
-c, --conversion_type
                        Type of conversion: fastaqual_to_fastq or fastq_to_fastaqual 
                        [default: fastaqual_to_fastq]
-o, --output_dir
                        Output directory. Will be created if does not exist. [default: .]


convert_fastaqual_fastq.py -f pandaseq_merged_reads/ C01_05102014_R1_D01.fasta -c fastq_to_fastaqual -o split_fasta_qual/
convert_fastaqual_fastq.py -f pandaseq_merged_reads/ C01_05102014_R1_D02.fasta -c fastq_to_fastaqual -o split_fasta_qual/
convert_fastaqual_fastq.py -f pandaseq_merged_reads/ C01_05102014_R1_D03.fasta -c fastq_to_fastaqual -o split_fasta_qual/
convert_fastaqual_fastq.py -f pandaseq_merged_reads/ C02_05102014_R1_D01.fasta -c fastq_to_fastaqual -o split_fasta_qual/
convert_fastaqual_fastq.py -f pandaseq_merged_reads/ C02_05102014_R1_D02.fasta -c fastq_to_fastaqual -o split_fasta_qual/
convert_fastaqual_fastq.py -f pandaseq_merged_reads/ C02_05102014_R1_D03.fasta -c fastq_to_fastaqual -o split_fasta_qual/
convert_fastaqual_fastq.py -f pandaseq_merged_reads/ C03_05102014_R1_D01.fasta -c fastq_to_fastaqual -o split_fasta_qual/
convert_fastaqual_fastq.py -f pandaseq_merged_reads/ C03_05102014_R1_D02.fasta -c fastq_to_fastaqual -o split_fasta_qual/
convert_fastaqual_fastq.py -f pandaseq_merged_reads/ C03_05102014_R1_D03.fasta -c fastq_to_fastaqual -o split_fasta_qual/
convert_fastaqual_fastq.py -f pandaseq_merged_reads/ C04_05102014_R1_D01.fasta -c fastq_to_fastaqual -o split_fasta_qual/
convert_fastaqual_fastq.py -f pandaseq_merged_reads/ C04_05102014_R1_D02.fasta -c fastq_to_fastaqual -o split_fasta_qual/
convert_fastaqual_fastq.py -f pandaseq_merged_reads/ C04_05102014_R1_D03.fasta -c fastq_to_fastaqual -o split_fasta_qual/
convert_fastaqual_fastq.py -f pandaseq_merged_reads/ C05_05102014_R1_D01.fasta -c fastq_to_fastaqual -o split_fasta_qual/
convert_fastaqual_fastq.py -f pandaseq_merged_reads/ C05_05102014_R1_D02.fasta -c fastq_to_fastaqual -o split_fasta_qual/
convert_fastaqual_fastq.py -f pandaseq_merged_reads/ C05_05102014_R1_D03.fasta -c fastq_to_fastaqual -o split_fasta_qual/
convert_fastaqual_fastq.py -f pandaseq_merged_reads/ C06_05102014_R1_D01.fasta -c fastq_to_fastaqual -o split_fasta_qual/
convert_fastaqual_fastq.py -f pandaseq_merged_reads/ C06_05102014_R1_D02.fasta -c fastq_to_fastaqual -o split_fasta_qual/
convert_fastaqual_fastq.py -f pandaseq_merged_reads/ C06_05102014_R1_D03.fasta -c fastq_to_fastaqual -o split_fasta_qual/
convert_fastaqual_fastq.py -f pandaseq_merged_reads/ C07_05102014_R1_D01.fasta -c fastq_to_fastaqual -o split_fasta_qual/
convert_fastaqual_fastq.py -f pandaseq_merged_reads/ C07_05102014_R1_D02.fasta -c fastq_to_fastaqual -o split_fasta_qual/
convert_fastaqual_fastq.py -f pandaseq_merged_reads/ C07_05102014_R1_D03.fasta -c fastq_to_fastaqual -o split_fasta_qual/
convert_fastaqual_fastq.py -f pandaseq_merged_reads/ C08_05102014_R1_D01.fasta -c fastq_to_fastaqual -o split_fasta_qual/
convert_fastaqual_fastq.py -f pandaseq_merged_reads/ C08_05102014_R1_D02.fasta -c fastq_to_fastaqual -o split_fasta_qual/
convert_fastaqual_fastq.py -f pandaseq_merged_reads/ C08_05102014_R1_D03.fasta -c fastq_to_fastaqual -o split_fasta_qual/
convert_fastaqual_fastq.py -f pandaseq_merged_reads/ C09_05102014_R1_D04.fasta -c fastq_to_fastaqual -o split_fasta_qual/
convert_fastaqual_fastq.py -f pandaseq_merged_reads/ C09_05102014_R1_D05.fasta -c fastq_to_fastaqual -o split_fasta_qual/
convert_fastaqual_fastq.py -f pandaseq_merged_reads/ C09_05102014_R1_D06.fasta -c fastq_to_fastaqual -o split_fasta_qual/
convert_fastaqual_fastq.py -f pandaseq_merged_reads/ C10_05102014_R1_D01.fasta -c fastq_to_fastaqual -o split_fasta_qual/
convert_fastaqual_fastq.py -f pandaseq_merged_reads/ C10_05102014_R1_D02.fasta -c fastq_to_fastaqual -o split_fasta_qual/
convert_fastaqual_fastq.py -f pandaseq_merged_reads/ C10_05102014_R1_D03.fasta -c fastq_to_fastaqual -o split_fasta_qual/
convert_fastaqual_fastq.py -f pandaseq_merged_reads/ C11_06102014_R1_D01.fasta -c fastq_to_fastaqual -o split_fasta_qual/
convert_fastaqual_fastq.py -f pandaseq_merged_reads/ C11_06102014_R1_D02.fasta -c fastq_to_fastaqual -o split_fasta_qual/
convert_fastaqual_fastq.py -f pandaseq_merged_reads/ C11_06102014_R1_D03.fasta -c fastq_to_fastaqual -o split_fasta_qual/
convert_fastaqual_fastq.py -f pandaseq_merged_reads/ C12_06102014_R1_D01.fasta -c fastq_to_fastaqual -o split_fasta_qual/
convert_fastaqual_fastq.py -f pandaseq_merged_reads/ C12_06102014_R1_D02.fasta -c fastq_to_fastaqual -o split_fasta_qual/
convert_fastaqual_fastq.py -f pandaseq_merged_reads/ C12_06102014_R1_D03.fasta -c fastq_to_fastaqual -o split_fasta_qual/
convert_fastaqual_fastq.py -f pandaseq_merged_reads/ C13_06102014_R1_D10.fasta -c fastq_to_fastaqual -o split_fasta_qual/
convert_fastaqual_fastq.py -f pandaseq_merged_reads/ C13_06102014_R1_D11.fasta -c fastq_to_fastaqual -o split_fasta_qual/
convert_fastaqual_fastq.py -f pandaseq_merged_reads/ C13_06102014_R1_D12.fasta -c fastq_to_fastaqual -o split_fasta_qual/
convert_fastaqual_fastq.py -f pandaseq_merged_reads/ C14_06102014_R1_D01.fasta -c fastq_to_fastaqual -o split_fasta_qual/
convert_fastaqual_fastq.py -f pandaseq_merged_reads/ C14_06102014_R1_D02.fasta -c fastq_to_fastaqual -o split_fasta_qual/
convert_fastaqual_fastq.py -f pandaseq_merged_reads/ C14_06102014_R1_D03.fasta -c fastq_to_fastaqual -o split_fasta_qual/
convert_fastaqual_fastq.py -f pandaseq_merged_reads/ C15_06102014_R1_D01.fasta -c fastq_to_fastaqual -o split_fasta_qual/
convert_fastaqual_fastq.py -f pandaseq_merged_reads/ C15_06102014_R1_D02.fasta -c fastq_to_fastaqual -o split_fasta_qual/
convert_fastaqual_fastq.py -f pandaseq_merged_reads/ C15_06102014_R1_D03.fasta -c fastq_to_fastaqual -o split_fasta_qual/
convert_fastaqual_fastq.py -f pandaseq_merged_reads/ C16_06102014_R1_D01.fasta -c fastq_to_fastaqual -o split_fasta_qual/
convert_fastaqual_fastq.py -f pandaseq_merged_reads/ C16_06102014_R1_D02.fasta -c fastq_to_fastaqual -o split_fasta_qual/
convert_fastaqual_fastq.py -f pandaseq_merged_reads/ C16_06102014_R1_D03.fasta -c fastq_to_fastaqual -o split_fasta_qual/
convert_fastaqual_fastq.py -f pandaseq_merged_reads/ C17_06102014_R1_D01.fasta -c fastq_to_fastaqual -o split_fasta_qual/
convert_fastaqual_fastq.py -f pandaseq_merged_reads/ C17_06102014_R1_D02.fasta -c fastq_to_fastaqual -o split_fasta_qual/
convert_fastaqual_fastq.py -f pandaseq_merged_reads/ C17_06102014_R1_D03.fasta -c fastq_to_fastaqual -o split_fasta_qual/
convert_fastaqual_fastq.py -f pandaseq_merged_reads/ C18_06102014_R1_D04.fasta -c fastq_to_fastaqual -o split_fasta_qual/
convert_fastaqual_fastq.py -f pandaseq_merged_reads/ C18_06102014_R1_D05.fasta -c fastq_to_fastaqual -o split_fasta_qual/
convert_fastaqual_fastq.py -f pandaseq_merged_reads/ C18_06102014_R1_D06.fasta -c fastq_to_fastaqual -o split_fasta_qual/


### input the mapping file to the combined file.
Command: add_qiime_labels.py -i split_fasta_qual/ -m Cen_full_mapping_corrected.txt -c Description -o AddQiimeLabels/
-i, --fasta_dir
       Directory of fasta files to combine and label.
-m, --mapping_fp
          SampleID to fasta file name mapping file filepath
-c, --filename_column
        Specify column used in metadata mapping file for fasta file names.
-o, --output_dir
         Required output directory for log file and corrected mapping file, log file, and html file. [default: .]


### Check sequence number
Command : count_seqs.py -i AddQiimeLabels/combined_seqs.fna
-i, --input_fps 
      The input filepaths (comma-separated)


### picking OTUs using open reference algorithm
Command: pick_open_reference_otus.py -i AddQiimeLabels/combined_seqs.fna -m usearch61 -o usearch61_openref_prefilter0_90/ -f

-i, --input_fps
       The input sequences filepath or comma-separated list of filepaths 
-o, --output_dir. 
       The output directory
-m, --otu_picking_method
       The OTU picking method to use for reference and de novo steps. 
       usearch61, for example, means that usearch61 will be used for the de novo steps and usearch61_ref will be used for reference steps. [default: uclust]

### Align representative sequences
Command: align_seqs.py -i usearch61_openref_prefilter0_90/rep_set.fna -o pynast_aligned/ -e 100
-i, --input_fasta_fp
       Path to the input fasta file
-o --output_dir
                       Path to store result file [default: <ALIGNMENT_METHOD>_aligned]
-e --min_length
                      Minimum sequence length to include in alignment 
                     [default: 75% of the median input sequence length]


### Assign taxonomy to representative sequences
Command : assign_taxonomy.py -i usearch61_openref_prefilter0_90/rep_set.fna -m rdp -c 0.8
-i, --input_fasta_fp 
       Path to the input fasta file 
-c --confidence Minimum confidence to record an assignment, only used for rdp and mothur methods [default: 0.5]


### Make an OTU table, append the assigned taxonomy, and exclude failed alignment OTUs
Commnad: biom summarize_table -i usearch61_openref_prefilter0_90/otu_table_mc2_w_tax.biom -o summary_otu_table_mc2_w_tax_biom.txt
-i, --input_fps 
      The input sequences filepath or comma-separated list of filepaths 
-o, --output_dir. 
       The output directory


### Rarefaction (subsampling)
      (Subsample to an equal sequencing depth across all samples (rarefaction) to make a new “even" OTU table)
Command: single_rarefaction.py -i usearch61_openref_prefilter0_90/otu_table_mc2_w_tax.biom -o Subsampling_otu_table_even2998.biom -d 2998
-i, --input_path 
       Input OTU table filepath. 
-o, --output_path 
       Output OTU table filepath. 
-d, --depth 
        Number of sequences to subsample per sample.


### Calculation of Alphadiversity
Command:
> mkdir alphadiversity_even2998 
> alpha_diversity.py -i Subsampling_otu_table_even73419.biom -m observed_species,PD_whole_tree -o alphadiversity_even73419/subsample_usearch61_alphadiversity_even73419.txt  -t usearch61_openref_prefilter0_90/rep_set.tre
-i, --input_path 
      Input OTU table filepath or input directory containing OTU tables for batch processing. [default: None]
-o, --output_path 
       Output filepath to store alpha diversity metric(s) for each sample in a tab-separated format or output directory when batch processing. [default: None] 
-m, --metrics
         Alpha-diversity metric(s) to use. A comma-separated list should be provided when multiple metrics are specified. [default: PD_whole_tree,chao1,observed_otus] 
-t, --tree_path 
       Input newick tree filepath. [default: None; REQUIRED for phylogenetic metrics]


### make area, and bar chart from subsampled dataset + summary tables for taxonomic level.
Command: summarize_taxa_through_plots.py -o alphadiversity_even73419/taxa_summary73419/ -i Subsampling_otu_table_even73419.biom

-i, --otu_table_fp 
      The input otu table [REQUIRED] 
-o, --output_dir 
       The output directory [REQUIRED]


### Make resemblance matrices to analyze comparative (beta) diversity
Command: beta_diversity.py -i Subsampling_otu_table_even73419.biom -m unweighted_unifrac,weighted_unifrac,binary_sorensen_dice,bray_curtis -o beta_div_even73419/ -t usearch61_openref_prefilter0_90/rep_set.tre

-i, --input_path
       Input OTU table in biom format or input directory containing OTU tables in biom format for batch processing. 
-m, --metrics
        Beta-diversity metric(s) to use. A comma-separated list should be provided when multiple metrics are specified. [default: unweighted_unifrac,weighted_unifrac] 
-t, --tree_path
       Input newick tree filepath, which is required when phylogenetic metrics are specified. [default: None]


### Creat PCoA plot
Command: principal_coordinates.py -i beta_div_even73419/ -o beta_div_even73419_PCoA/

-i, --input_path Path to the input distance matrix file(s) (i.e., the output from beta_diversity.py). Is a directory for batch processing and a filename for a single file operation. -o, --output_path Output path. Directory for batch processing, filename for single file operation



Make 2D plot
Command: make_2d_plots.py -i beta_div_even73419_PCoA/pcoa_weighted_unifrac_Subsampling_otu_table_even73419.txt -m Cen_simple_mapping_corrected.txt -o PCoA_2D_plot/
-i, --coord_fname 
      Input principal coordinates filepath (i.e., resulting file from principal_coordinates.py). Alternatively, a directory containing multiple principal coordinates files for jackknifed PCoA results. 
-m, --map_fname 
      Input metadata mapping filepath


### Creat NMDS plot
Command: nmds.py -i bray_curtis_otu_table_mc2_w_tax.txt -o BC_coords.txt
-i, --input_path 
      Path to the input distance matrix file(s) (i.e., the output from beta_diversity.py). Is a directory for batch processing and a filename for a single file operation. 
-o, --output_path
        Output path. directory for batch processing, filename for single file operation


### Convert biom table to txt
Command : biom convert -i Subsampling_otu_table_even73419.biom -o biom_converted/table.from_biom.txt --table-type "OTU table" --to-tsv
-i, --input_path 
      Path to the input distance matrix file(s) 
-o, --output_path
        Output path. directory for batch processing, filename for single file operation


### Averaging replicates
Command: collapse_samples.py -b Subsampling_otu_table_even73419.biom -m Cen_simple_mapping_corrected.txt --output_biom_fp collapsed_OTU_table.biom --output_mapping_fp collapsed_map_new_rep.txt --collapse_mode mean --collapse_fields GPS_pt
-b, --input_biom_fp 
        The biom table containing the samples to be collapsed 
-m, --mapping_fp 
        The sample metdata mapping file 
      --output_biom_fp 
        Path where collapsed biom table should be written 
      --output_mapping_fp 
              Path where collapsed mapping file should be written 
        --collapse_fields 
              Comma-separated list of fields to collapse on


### Analyses using R script
## T-test
- Using Sigmaplot
- input values and select “

## Heatmap
Script: in GitHub repository (https://github.com/ShadeLab/Centralia_16S_analysis)

## PCoA plot
Command: principal_coordinates.py -i beta_div_even73419/ -o beta_div_even73419_PCoA/
Command: make_2d_plots.py -i beta_div_even73419_PCoA/pcoa_weighted_unifrac_Subsampling_otu_table_even73419.txt -m Cen_simple_mapping_corrected.txt -o PCoA_2D_plot/

## Correlation analysis between environmental factors and axis 1, 2
CCA R script

## ANOSIM
Script: in GitHub repository (https://github.com/ShadeLab/Centralia_16S_analysis)
R script

## CCA and RDA plotting
Script: in GitHub repository (https://github.com/ShadeLab/Centralia_16S_analysis)
R script

## Heatmap
Script: in GitHub repository (https://github.com/ShadeLab/Centralia_16S_analysis)
R script

## Network analysis
- Used ELSA (Extended Local Similarity Analysis) under linux (Virtual BOX)
- Homepage: https://bitbucket.org/charade/elsa/wiki/Home 
- git clone https://bitbucket.org/charade/elsa.git
- should use rpy2-2.3.10, not most recent version.
- check datafile (remove special character “\M”)

Command: 
lsa_compute Cen_OTUs_nosigs_env_L5_converted_ELSA.txt test/ARISA_CenL4.lsa -d 0 -r 1 -s 18 -p perm

