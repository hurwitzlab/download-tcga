#!/usr/bin/env bash

#PBS -W group_list=bhurwitz
#PBS -q standard
#PBS -l select=1:ncpus=6:mem=24gb
#PBS -l walltime=72:00:00
#PBS -l cput=72:00:00
#PBS -M scottdaniel@email.arizona.edu
#PBS -m ea
#PBS -j oe
#PBS -o out/

export N_PROCESSES="6" #number of threads

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

#Downloading tcga colorectal normal tissue (but still
# with mutations in TGFB2, TGFBR2, SMAD2/3/4

echo Downloading files in $CART
echo to $(basename $CART .txt)

mkdir -p $(basename $CART .txt)

gdc-client download --token-file $KEY \
    --manifest $CART \
    -n $N_PROCESSES
    --dir $(basename $CART .txt) \
    --log-file $SCRIPT_DIR/out/download-progress.txt

