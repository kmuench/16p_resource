# 16p_resource

[ Introduction ](#intro) | [ Getting Started ](#getstart) | [ Additional Info ](#misc) | [ Versioning ](#ver) | [ Authors ](#authors) | [ Acknowledgements ](#acknow)

<a name="intro"></a>
# Introduction

This repo contains the code used to generate analyses and generate figures for Roth, Muench et. al. This paper describes a new resource of patient-derived iPSCs bearing a 16p11.2 copy number variant, explores the potential utility of these clones, and describes the possible impact of clonal integration on iPSC-derived tissue models. I have written this README with other biologists in mind who might be interested in following up on our analyses or investigating their own integration effects.

It is divided into two sections. The names are a bit of a misnomer, and left over from an earlier revision:
- **"figure5"**: contains a differential expression analysis of the **integration-negative clones** aligned with STAR and counted with htseq-count. 
- **"figure6"**: contains an independent bioinformatic **comparison of integration-negative and Integration-positive clones** aligned using kallisto.

<a name="getstart"></a>
## Getting Started

### Data
The data will be made available on GEO (under embargo during revisions as of October 12, 2020).

### Dependencies

#### Figure 5

setup.Rmd

* Install the following 

    + [DESeqAid Package](https://github.com/kmuench/DESeqAid)
    + [DESeq2 Package](http://bioconductor.org/packages/release/bioc/html/DESeq2.html)
    + [Pheatmap Package](https://cran.r-project.org/web/packages/pheatmap/index.html)
    + [ggplot2 Package](https://cran.r-project.org/web/packages/ggplot2/index.html)
    + [limma Package](https://bioconductor.org/packages/release/bioc/html/limma.html)
    + [SVA Package](https://www.bioconductor.org/packages/release/bioc/html/sva.html)


DESeq.Rmd

* In addition to the packages required for Setup, install the following 

    + [R ColorBrewer](https://www.rdocumentation.org/packages/RColorBrewer/versions/1.1-2/topics/RColorBrewer)

#### Figure 6

tximport_Setup.Rmd

* Install the following

    + [EnsDb.Hsapiens.v86](http://bioconductor.org/packages/release/data/annotation/html/EnsDb.Hsapiens.v86.html)
    + [tximport](http://bioconductor.org/packages/release/bioc/html/tximport.html)
    + [edgeR](https://bioconductor.org/packages/release/bioc/html/edgeR.html)
    + [DESeq2 Package](http://bioconductor.org/packages/release/bioc/html/DESeq2.html)
    + [limma Package](https://bioconductor.org/packages/release/bioc/html/limma.html)
    + [ggplot2 Package](https://cran.r-project.org/web/packages/ggplot2/index.html)
    + [genefilter Package](http://bioconductor.org/packages/release/bioc/html/genefilter.html)
    + [ggrepel Package](https://cran.r-project.org/web/packages/ggrepel/index.html)

deseq.Rmd

* Install the following 

    + [DESeqAid Package](https://github.com/kmuench/DESeqAid)
    + [DESeq2 Package](http://bioconductor.org/packages/release/bioc/html/DESeq2.html)

heatmaps.Rmd

* Install the following

    + [R ColorBrewer](https://www.rdocumentation.org/packages/RColorBrewer/versions/1.1-2/topics/RColorBrewer)

barPlots.Rmd

* In addition to the packages required for Setup, install the following 

    + [reshape2](https://cran.r-project.org/web/packages/reshape2/index.html)

GSEA.Rmd

* GSEA [.jar file](http://software.broadinstitute.org/gsea/login.jsp)

### How to run

#### 1. Fill out userVars.csv. I thought it might be easier to import and document variables using this spreadsheet rather than using a .bashrc file.

#### 2. Run the Rmd files. Within each figure directory, the code has been broken up into several parts. You should run the code in this order:

*Figure 5*

1. setup.Rmd
2. deseq.Rmd

*Figure 6*

1. tximport_setup.Rmd
2. deseq.Rmd
3. barPlots.Rmd OR heatmaps.Rmd OR GSEA.Rmd

This code is written to have a separate output file for each distinct date of run, when the date of run is defined within the userVars.csv file. This way, the user can maintain copies of all output as small tweaks are made to the code. 


<a name="misc"></a>
## Additional Info
For the alignment and counting steps, I used one of two different aligners

* [STAR](http://labshare.cshl.edu/shares/gingeraslab/www-data/dobin/STAR/STAR.posix/doc/STARmanual.pdf) (Figure 5) with [htseq-count](https://htseq.readthedocs.io/en/master/count.html)

* [kallisto](https://pachterlab.github.io/kallisto/about) (Figure 6)

I performed both of these on the [Stanford Center for Personalized Medicine Cluster](http://med.stanford.edu/scgpm.html). I recommend running STAR on a cluster. In theory, you should be able to run kallisto on a laptop.

I performed subsequent analyses using [R](https://www.r-project.org/) and [RStudio](https://www.rstudio.com/).

<a name="ver"></a>
## Versioning

For the versions available, see the [tags on this repository](https://github.com/kmuench/16p_resource/tags). 

<a name="authors"></a>
## Authors

* **Kristin Muench** - *Initial work* - kmuench@stanford.edu - GitHub: [kmuench](https://github.com/kmuench)

<a name="acknow"></a>
## Acknowledgments

* Thank you to [PurpleBooth](https://gist.github.com/PurpleBooth/109311bb0361f32d87a2#file-readme-template-md) for the README template
* Thank you to the Bader Lab for their [GSEA tutorial](https://baderlab.github.io/Cytoscape_workflows/EnrichmentMapPipeline/supplemental_protocol1_rnaseq.html).
* Thank you to John Hanks at the SCPGM cluster and the team at the Stanford Functional Genomics Facility for their help supporting this work.


