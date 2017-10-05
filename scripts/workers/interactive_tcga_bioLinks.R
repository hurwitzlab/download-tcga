# source("https://bioconductor.org/biocLite.R")
# biocLite("TCGAbiolinks")

library("TCGAbiolinks")

query <- GDCquery(project = "TCGA-READ",
                 data.category = "Transcriptome Profiling",
                 data.type = "Gene Expression Quantification",
                 workflow.type = "HTSeq - Counts")
