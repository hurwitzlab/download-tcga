#!/usr/bin/env bash

#PBS -W group_list=bhurwitz
#PBS -q standard
#PBS -l place=free:shared
#PBS -l select=1:ncpus=2:mem=3gb
#PBS -l walltime=72:00:00
#PBS -l cput=72:00:00
#PBS -M scottdaniel@email.arizona.edu
#PBS -m ea
#PBS -j oe
#PBS -o out/

export WD=$PBS_O_WORKDIR

cd $WD

if [ -e config.sh ]; then
    source config.sh
else
    echo NO config file!
    exit 12345
fi

if [ ! -d "$TCGA_DIR" ]; then
    mkdir -p $TCGA_DIR
fi

cd $TCGA_DIR
OUT=$(basename $CART .txt)
echo Downloading files in $CART
echo to $OUT

mkdir -p $OUT

gdc-client download --token-file $KEY \
    --manifest $CART \
    --dir $OUT \
    --log-file $SCRIPT_DIR/out/download-progress.txt

