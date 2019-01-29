#!/bin/bash
# star_submitter_template.sh
# By Kristin Muench
# 2018.02.11
# John Hanks of the SCGPM cluster helped me write this. Thanks John!
#
# This script will submit a job for each file in a list of files.
# It takes one argument, a directory in the current directory, from
# which fastq files will be processed.

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
samples=( $(find $1 -maxdepth 1 -name *.fastq | sed -e 's#^.*/\(.*\)_R[12]_[0-9]*\.fastq$#\1#g' | sort | uniq) )

# Set up out output location, unique id is submission time.
outputFileLoc="$(echo $1 | tr '/' '_')output"
workingDir=$(pwd)
destinationDir="/destination/dir" # !! user should change to desired destination directory
gtfLoc="/gtf/loc" # !! user should change to location of .gtf file


if [[ ! -d $destinationDir/$outputFileLoc ]]; then
  mkdir $destinationDir/$outputFileLoc
fi

for sample in ${samples[*]}; do
   
  Read1="${1}/${sample}_R1_001.fastq"
  Read2="${1}/${sample}_R2_001.fastq"

  # Create job script, the whitespace at the front of each line must be a tab
  # so that the <<- operator will ignore it. 
  cat > ${destinationDir}/${outputFileLoc}/${sample}.sbatch <<- EOF
	#!/bin/bash
	#SBATCH --chdir="$(pwd)"
	#SBATCH --account=your_account
	#SBATCH --time=1-00:00:00
	#SBATCH --job-name="star_${sample}"
	#SBATCH --output=${destinationDir}/${outputFileLoc}/${sample}_slurm_%j.out
	#SBATCH --nodes=1
	#SBATCH --ntasks=1
	#SBATCH --cpus-per-task=4
	#SBATCH --mem=32G
	#SBATCH --mail-user=$USER@stanford.edu
	#SBATCH --mail-type=BEGIN,END,FAIL

	# load needed modules
	module load STAR/2.5.3a
	module load HTSeq/0.9.1

	# run STR
	STAR --runThreadN ${SLURM_NPROCS:-1} \\
	     --genomeDir \$STAR_HG19_GENOME \\
	     --readFilesIn ${workingDir}/$Read1 ${workingDir}/$Read2 \\
	     --outSAMtype BAM SortedByCoordinate \\
	     --outFileNamePrefix ${destinationDir}/${outputFileLoc}/${sample}

	# run htseq-count to count STAR reads

        module load HTSeq/0.9.1
	htseq-count -f bam ${destinationDir}/${outputFileLoc}/${sample}*.bam $gtfLoc > ${destinationDir}/${outputFileLoc}/${sample}.counts



	EOF

  if ! ${DRYRUN:-false}; then
    # Submit that job script.
    echo "Submitting job star_${sample}."
    sbatch ${destinationDir}/${outputFileLoc}/${sample}.sbatch
  fi
done 
 
## Note: add these to STAR command to include unmapped reads in output:
#--outSAMunmapped Within \\
#--outReadsUnmapped Fastx \\
