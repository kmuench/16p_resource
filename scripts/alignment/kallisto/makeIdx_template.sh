#!/bin/bash     
# makeIdx_template.sh
# By Kristin Muecnh
# 2018.09.28
#
# This script uses the .fa files for the transcriptome and plasmids and creates the index that kallisto needs for alignment

# !! user gives experiment a name
expt="kallidx"

#declare Variables                                                                                                                          
humFa="/path/to/GRCh38_transcriptome/ftp.ensembl.org/pub/release-93/fasta/homo_sapiens/cdna/*.fa" # !! user defined path
plasFa="/path/to/plasmidFasta/*.fa" # !! user defined path
outputIdx="GRCh38_plas.idx" 

cat > $expt.sbatch <<- EOF 
	#!/bin/bash
	#SBATCH --chdir="$(pwd)"
	#SBATCH --account=tpalmer
	#SBATCH --time=1-00:00:00
	#SBATCH --job-name="idx0824"
	#SBATCH --output=idx2_%j.out
	#SBATCH --nodes=1
	#SBATCH --ntasks=1
	#SBATCH --cpus-per-task=4
	#SBATCH --mem=164G
	#SBATCH --mail-user=kmuench@stanford.edu
	#SBATCH --mail-type=BEGIN,END,FAIL

	# load kallisto
	module load kallisto/0.43.1

	# run index gen
	kallisto index --index=$outputIdx $humFa $plasFa --make-unique

	EOF


if ! ${DRYRUN:-false}; then
  # Submit that job script.                                                                                                   
  echo "Submitting job star_${sample}."
  sbatch $expt.sbatch
fi

