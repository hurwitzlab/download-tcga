# source("https://bioconductor.org/biocLite.R")
# biocLite("TCGAbiolinks")

#working with R version 3.4.2 (2017-09-28)

library(TCGAbiolinks)
library(dplyr)
library(DT)

#The goal here is to separate out the files from READ (rectal adenocariconma) and COAD (colon adenocarcinoma)

#Manifest has the files that were already selected for the 5 mutated genes we have interest in: TGF-beta 2, TGF-beta receptor 2, SMAD2, "3, and "4
normaltiss <- read.delim("manifests/normaltiss-5genes.txt")

#cases is more like aliquot id which is associated with biospecimen
#the patient id ex: TCGA-AA-3663
#is the first part of biospecimen / aliquot id / that's how we can link things back to patient id and find which ones actually have tumor / normal rna expression pairs

queryCOAD <- GDCquery(project = "TCGA-COAD",
                  data.category = "Raw Sequencing Data",
                  sample.type = c("Solid Tissue Normal"))

COADdf <- data.frame(queryCOAD$results[[1]])
thingCOAD <- data.frame(filename=COADdf$file_name,project=COADdf$project)

queryREAD <- GDCquery(project = "TCGA-READ",
                      data.category = "Raw Sequencing Data",
                      sample.type = c("Solid Tissue Normal"))

READdf <- data.frame(queryREAD$results[[1]])
thingREAD <- data.frame(filename=READdf$file_name,project=READdf$project)

thing2 <- rbind(thingREAD,thingCOAD)

normaltiss <- merge(normaltiss,thing2,by="filename")
#they are all from COAD! for these 5 mutations anyways

query <- GDCquery(project = c("TCGA-READ","TCGA-COAD"),
                  data.category = "Raw Sequencing Data",
                  sample.type = c("Primary solid Tumor","Solid Tissue Normal"))

df = data.frame(query$results[[1]])

clin.query <- GDCquery(project = c("TCGA-READ","TCGA-COAD"),
                       data.category = "Clinical")

#actually downloads xml not json
#json  <- tryCatch(GDCdownload(clin.query),
                  # error = function(e) GDCdownload(clin.query, method = "client"))

#doesnt work unless you specify patient with "bar code"
#e.g. clin.query <- GDCquery(project = "TCGA-BLCA", data.category = "Clinical", barcode = "TCGA-FD-A5C0")
#clinical.patient <- GDCprepare_clinic(clin.query, clinical.info = "patient")

#this doesnt work, cant do two at once
clinical.index <- GDCquery_clinic(c("TCGA-READ","TCGA-COAD"))

#this works
clinical.index <- GDCquery_clinic("TCGA-READ")

