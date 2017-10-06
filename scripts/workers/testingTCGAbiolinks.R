# source("https://bioconductor.org/biocLite.R")
# biocLite("TCGAbiolinks")

#working with R version 3.4.2 (2017-09-28)

library(TCGAbiolinks)
library(dplyr)
library(DT)

#these commands are from the tutorial here:
#https://bioconductor.org/packages/devel/bioc/vignettes/TCGAbiolinks/inst/doc/tcgaBiolinks.html#gdcquery:_searching_gdc_data_for_download

#query <- GDCquery(project = "TARGET-AML",
                  # data.category = "Transcriptome Profiling",
                  # data.type = "Gene Expression Quantification",
                  # workflow.type = "HTSeq - Counts")

clin.query <- GDCquery(project = "TCGA-BLCA", data.category = "Clinical", barcode = "TCGA-FD-A5C0")

clinical.patient <- GDCprepare_clinic(clin.query, clinical.info = "patient")
clinical.patient.followup <- GDCprepare_clinic(clin.query, clinical.info = "follow_up")
clinical.index <- GDCquery_clinic("TCGA-BLCA")
