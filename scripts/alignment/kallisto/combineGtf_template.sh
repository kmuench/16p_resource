#!/bin/bash     
# combineGtf_template.sh
# By Kristin Muench
# 2018.05.18
#
# In order to align to plasmid DNA, you will need to create a gtf file for the additional plasmid sequences you are treating as
# extra "chromosomes".
# This script takes in a gtf file (e.g. of the sort you would download from ftp.ensembl.org, GRCh38 etc.) and concatenates it to a gtf you 
# have made for your additional gtf.
# Pretty straightforward, but it's an important step.
# Often, I found issues with alignment came down to issues with the formatting of the gtf file.

originalGtf="/path/to/GRCh38_transcriptome/ftp.ensembl.org/pub/release-93/gtf/homo_sapiens/Homo_sapiens.GRCh38.93.gtf"
plasmidGtf="/path/to/myPlasmidGenes.gtf"
outputFile="/path/to/GRCh38_plasmid.gtf"

cat $originalGtf $plasmidGtf > $outputFile
