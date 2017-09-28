#!/usr/bin/env bash

#PBS -W group_list=bhurwitz
#PBS -q standard
#PBS -l select=1:ncpus=2:mem=3gb
#PBS -l walltime=72:00:00
#PBS -l cput=72:00:00
#PBS -M scottdaniel@email.arizona.edu
#PBS -m ea
#PBS -j oe
#PBS -o out/
export WD=$PBS_O_WORKDIR

if [ ! -d "$SRA_DIR" ]; then
    mkdir -p $SRA_DIR
fi

cd $SRA_DIR

#Downloading phs000374 - Genomic Sequencing of Colorectal Adenocarcinomas 

vdb-config --import $KEY ./ &>$WD/out/dbgap_download.log

prefetch --max-size 1T $CART \
    &>>$WD/out/dbgap_download.log

