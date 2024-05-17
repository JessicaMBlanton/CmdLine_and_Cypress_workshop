## Example file of code to retrieve sequences from NCBI
Nearly all steps were done from the command line. 
This is I record what I've done for myself, so while it's not elegant, it's real :)
_______

#### Getting sequences for workshop demo
- Jessica Blanton 
- Last modified 051024

Purpose: Retrieve a reasonable number of sequences to build a phyogenetic tree for the cmd line workshop next week. Make the sequence headers look pretty but still trustworthy and informative (keep NCBI accessions).

Drawn from:

Tobe, Shanan S., Andrew C. Kitchener, and Adrian MT Linacre. "Reconstructing mammalian phylogenies: a detailed comparison of the cytochrome b and cytochrome oxidase subunit I mitochondrial genes." PloS one 5.11 (2010): e14156. https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0014156

---

Download NCBI mitochondrial info as searchable list, index with list from Tobe et al

```
# Working directory
cd /Users/good_deeds/Dropbox/REB_Tulane/maywkshp/gene_downloads

# Manually save flatfile of mitochondrial genome references from publication supplemental materials as .txt file
# Authors did a beautiful job [prayer hands emoji], no need to do any cleaning.
Tobe_2010_mito_ST1.txt

# Download ALL CYTB records from NCBI gene "database" (https://www.ncbi.nlm.nih.gov/gene/?term=cytb)
# File is a bit big (17,860 records) , delete when finished
gene_result.txt
ll -h gene_result.txt
	# -rw-r--r-- 1 good_deeds 2.1M May  7 06:49 gene_result.txt

# Intersect mito genomes list from publication with NCBI records to get CYTB records of interest
grep "\tx\t" Tobe_2010_mito_ST1.txt | cut -f1 - | grep -f - gene_result.txt > tobe_2010_CYTB_target.txt

# Select out just the ID numbers
cut -f3 tobe_2010_CYTB_target.txt > tobe_2010_CYTB_ID.txt

```

Download specific cytochrome b gene sequenceces from NCBI
```
# Setup NCBI datasets environment
conda create -n ncbi_datasets
conda activate ncbi_datasets
mamba install -c conda-forge ncbi-datasets-cli

# Format IDs list as single line, space separated, for download script
cat tobe_2010_CYTB_ID.txt | tr "\n" " "

	# 807858 808227 808467 808182 807889 807882 807904 6742684 3337208 808703 808483 803405 5522496 5522482 804506 803520 3332201 803083 803066 4171546 4171516 805147 804988 3112551 4097500 2717279 808319 803055 4171583 804976 26192 17711

# Add Homo sequences manually:
		# ID: 6775065
		# cytochrome b [Homo sapiens neanderthalensis (Neandertal)]	
		# ID: 4519
		# mitochondrially encoded cytochrome b [Homo sapiens (human)]	

# Download these target primate+ sequences.  Might need either DNA or amino acid sequences for best tree? Get both.
datasets download gene gene-id 807858 808227 808467 808182 807889 807882 807904 6742684 3337208 808703 808483 803405 5522496 5522482 804506 803520 3332201 803083 803066 4171546 4171516 805147 804988 3112551 4097500 2717279 808319 803055 4171583 804976 26192 17711 6775065 4519 --include 'gene,protein'

# Un-archive resulting file and check results
unzip ncbi_dataset.zip
grep ">" ncbi_dataset/data/gene.fna -c
grep ">" ncbi_dataset/data/protein.faa -c
wc -l tobe_2010_CYTB_ID.txt
		34
		34
		32 tobe_2010_CYTB_ID.txt
# Looks good, 2 sequences were manually added to the indexed list

# Exit NCBI datasets environment
 conda deactivate

```

Edit names to be more "human readable" 
```
################################################################################################
## Started to script this, but felt in this case to be a dumb use of time, unlikely to re-use
## Ended up setting up the tip_label_hr.sh script with regex find/replace in BBedit
#cut -f 6,4,3 Tobe_2010_mito_ST1.txt | head \
#| sed 's;\t;\t\t;' \
#| sed 's; ;_;g' \
################################################################################################

# Remove distracting characters, and concatenate header information
# Unwrap sequence lines with program seqtk (probably should have used awk one-liner for demonstration purposes)
sed 's;:.*\[organism=;_cytb__;g' ncbi_dataset/data/gene.fna \
| sed 's;\].*$;;g' | tr " " "_" \
| seqtk seq -l 0  - > ncbi_dataset/data/gene_species.fna

# Created simple bash script to switch to common names instead of linnaean
# Script outputs new sequence file as "gene_labled.fna"
chmod +x tip_label_hr.sh
bash tip_label_hr.sh

# Check sequence headers
grep ">" ncbi_dataset/data/gene_species.fna
grep ">" ncbi_dataset/data/gene_labled.fna 

# Give this a more informative name
cp ncbi_dataset/data/gene_labled.fna primate_cytb.fna

```
