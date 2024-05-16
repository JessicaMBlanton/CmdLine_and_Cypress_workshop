## Example file of code to retrieve sequences from NCBI
Nearly all steps were done from the command line!

Drawn from:

Tobe, Shanan S., Andrew C. Kitchener, and Adrian MT Linacre. "Reconstructing mammalian phylogenies: a detailed comparison of the cytochrome b and cytochrome oxidase subunit I mitochondrial genes." PloS one 5.11 (2010): e14156. https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0014156

Download mitochondrial data:

```
cd /Users/good_deeds/Dropbox/REB_Tulane/maywkshp/gene_downloads


# Manually save flatfile of mitochondrial genome references from publication supplement
Tobe_2010_mito_ST1.txt

# Download all CYTB records from NCBI
ncbi_allcytb_info.txt

# Intersect mito genomes list from publication with NCBI records
# To get CYTB records of interest
grep "\tx\t" Tobe_2010_mito_ST1.txt | cut -f1 - | grep -f - gene_result.txt > tobe_2010_CYTB_target.txt

# Select out just the ID numbers
cut -f3 tobe_2010_CYTB_target.txt > tobe_2010_CYTB_ID.txt

###########################
# Download specific cytochrome b genes from NCBI
###########################

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
rm -rf ncbi_dataset*

# Download target primate sequences 
datasets download gene gene-id 807858 808227 808467 808182 807889 807882 807904 6742684 3337208 808703 808483 803405 5522496 5522482 804506 803520 3332201 803083 803066 4171546 4171516 805147 804988 3112551 4097500 2717279 808319 803055 4171583 804976 26192 17711 6775065 4519 --include 'gene,protein'
 
unzip ncbi_dataset.zip
grep ">" ncbi_dataset/data/gene.fna -c
grep ">" ncbi_dataset/data/protein.faa -c
wc -l tobe_2010_CYTB_ID.txt
		34
		34
		32 tobe_2010_CYTB_ID.txt
# Looks good, 2 sequences were manually added to the indexed list

conda deactivate

###########################
# Edit names to be more "human readable"

## Started to code, may be just dumb use of time
#cut -f 6,4,3 Tobe_2010_mito_ST1.txt | head \
#| sed 's;\t;\t\t;' \
#| sed 's; ;_;g' \
###########################


# Remove extraneous characters and concatenate
# unwrap sequence lines
sed 's;:.*\[organism=;_cytb__;g' ncbi_dataset/data/gene.fna \
| sed 's;\].*$;;g' | tr " " "_" \
| seqtk seq -l 0  - > ncbi_dataset/data/gene_species.fna

# create final gene_labled.fna file
chmod +x tip_label_hr.sh
bash tip_label_hr.sh

grep ">" ncbi_dataset/data/gene_species.fna
grep ">" ncbi_dataset/data/gene_labled.fna

cp ncbi_dataset/data/gene_labled.fna primate_cytb.fna
```
