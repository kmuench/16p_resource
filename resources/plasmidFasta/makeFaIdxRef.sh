#!/bin/bash
# By Kristin Muench
# 2018.09.11
#
# This script creates a reference index which may be necessary for aligners in order to incorporate it into a reference index.
# 
#
# Documentation: 
# http://www.htslib.org/doc/faidx.html
# http://www.htslib.org/doc/samtools.html
#
# # # #

# load samtools
module load samtools

# make the reference index
samtools faidx plas_shp_up.fa
