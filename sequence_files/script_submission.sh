#!/bin/bash
#SBATCH --job-name=h_tree
#SBATCH --output=h_tree.out
#SBATCH --error=h_tree.err
#SBATCH --partition=defq
#SBATCH --qos=normal
#SBATCH --time=0-00:05:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mail-user=YOUREMAIL@tulane.edu  
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END

# muscle 5.1.linux64 
module load muscle/5.1

# FastTree version 2.1.10 Double precision
module load qiime2/2018.2

# Align sequences
muscle -align hominid_cytb.fna -output hominid_tree/aln.fna -threads 1 -log hominid_tree/muscle_aln.log 

# FastTree version 2.1.10 Double precision
FastTree -log hominid_tree/fasttree.log -nt hominid_tree/aln.fna > hominid_tree/h_tree.nwk
