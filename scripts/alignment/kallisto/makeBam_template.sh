#!/bin/bash
# By Kristin Muench (with some input from John Hanks)
# 2018.05.28
#
# This code performs alignment with kallisto. It detects directories containing .fastq files in the same directory as the script.
# It requires a kallisto index and a gtf file, both of which must be created including the plasmid .fa and .gtf (which you make yourself)

# warning to detect for fastq files
if [[ -z $1 || ! -d $(pwd)/$1 ]]; then
  echo "usage: $0 directory"
  echo "Must give me a directory to search for fastq files,"
  echo "directory must exist in current working directory."
  echo "e.g., run this from the location which will contain"
  echo "all inputs and outputs. We assume direcotry has no "
  echo "subdirectories."
  echo "Run this as 'DRYRUN=true $0 directory' to skip job"
  echo "submission."
fi

# Gather our list of samples, in an array. In order,
# find - finds all files under the fastq directory with end in .fastq
# sed - pulls out everything between the last / in the path and '_Rn_nnn.fastq'
# sort - sorts the entries
# uniq - removes duplicates

echo "Detected input:"
echo "$1"

echo "Samples:"
samples=( $(find $1 -maxdepth 1 -name *.fastq | sed -e 's#^.*/\(.*\)_R[12]_[0-9]*\.fastq$#\1#g' | sort | uniq ) )
echo "$samples"

# Set up out output location, unique id is submission time.
echo "OutputFileLoc:"
outputFileLoc="/path/to/desired/output/file" # !! user should change path to desired output file
echo "$outputFileLoc"

workingDir=$(pwd)

# make a directory for output if none exists
if [[ ! -d $outputFileLoc ]]; then
  mkdir $outputFileLoc
fi

#declare Variables                                                                                                                          
kallistoIdx="/path/to/idx" # !! user should change path to kallisto index (.idx)
expt="makeBam"
myGtf="/path/to/GRCh38_plasmid.gtf" # !! user should change path to .gtf file

for sample in ${samples[*]}; do
  
  echo "Reads:"
  Read1="${1}/${sample}_R1_001.fastq"
  Read2="${1}/${sample}_R2_001.fastq"
  echo $Read1 $Read2


  # Create job script, the whitespace at the front of each line must be a tab
  # so that the <<- operator will ignore it. 

  cat > $outputFileLoc/${sample}.sbatch <<- EOF 
	#!/bin/bash
	#SBATCH --chdir="$(pwd)"
	#SBATCH --account=tpalmer
	#SBATCH --time=6-16:00:00
	#SBATCH --job-name="0911_bam"
	#SBATCH --output=kall_slurm_%j.out
	#SBATCH --nodes=1
	#SBATCH --ntasks=1
	#SBATCH --cpus-per-task=4
	#SBATCH --mem=164G
	#SBATCH --mail-user=kmuench@stanford.edu
	#SBATCH --mail-type=BEGIN,END,FAIL

	# load kallisto
	module load kallisto/0.44.0 
	module load samtools/1.7

	# make directory for sample
	if [[ ! -d $outputFileLoc/$sample ]]; then
	  mkdir $outputFileLoc/$sample
	fi

	# run index gen
	kallisto quant -i $kallistoIdx -o $outputFileLoc/$sample --genomebam --gtf $myGtf $Read1 $Read2

	EOF

  if ! ${DRYRUN:-false}; then
    # Submit that job script.
    echo "Submitting job ${expt}_${sample}."
    sbatch ${outputFileLoc}/${sample}.sbatch
  fi

done

