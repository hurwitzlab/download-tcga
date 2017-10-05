# source("https://bioconductor.org/biocLite.R")
# biocLite("TCGAbiolinks")

library(TCGAbiolinks)
library(dplyr)
library(DT)

query <- GDCquery(project = "TARGET-AML",
                  data.category = "Transcriptome Profiling",
                  data.type = "Gene Expression Quantification",
                  workflow.type = "HTSeq - Counts")
