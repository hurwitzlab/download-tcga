# source("https://bioconductor.org/biocLite.R")
# biocLite("TCGAbiolinks")

#working with R version 3.4.2 (2017-09-28)

library(TCGAbiolinks)
library(dplyr)
library(DT)

queryCOAD <- GDCquery(project = "TCGA-COAD",
                  data.category = "Transcriptome Profiling",
                  data.type = "Gene Expression Quantification",
                  workflow.type = "HTSeq - Counts")
