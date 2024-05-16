#!/bin/bash   
#SBATCH --job-name=p_tree       ### Job Name
#SBATCH --output=p_tree.out   ### File in which to store job output
#SBATCH --error=p_tree.err   ### File in which to store job error messages
#SBATCH --partition=workshop   ### partition for Cypress- default "defq"
#SBATCH --qos=workshop   ### Quality of service parameter- default "normal"
#SBATCH --time=0-00:10:00   ### Wall clock time limit in Days-HH:MM:SS
#SBATCH --nodes=1   ### Number of nodes to use
#SBATCH --ntasks-per-node=1   ### Number of tasks to run per node
#SBATCH --cpus-per-task=20  ### Number of cpus available for task

# Make sure muscle 5.1.linux64 is available
module load muscle/5.1

# Make sure FastTree version 2.1.10 is available
module load qiime2/2018.2

# Set up directory for output files
mkdir primate_tree

# Align sequences
muscle -align mammal_data/primate_cytb.fna -output primate_tree/aln.fna -threads 1 -log primate_tree/muscle_aln.log

# Build tree
FastTree -log primate_tree/fasttree.log -nt primate_tree/aln.fna > primate_tree/p_tree.nwk
