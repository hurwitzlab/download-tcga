#!/usr/bin/env bash

#PBS -W group_list=bhurwitz
#PBS -q standard
#PBS -l select=1:ncpus=1:mem=1gb
#PBS -l walltime=4:00:00
#PBS -l cput=4:00:00
#PBS -M scottdaniel@email.arizona.edu
#PBS -m ea
#PBS -j oe
#PBS -N organize_fq
#PBS -o pbs_logs/
#PBS -e pbs_logs/

export WD=$PBS_O_WORKDIR

cd $WD

mkdir -p pbs_logs

if [ -e config.sh ]; then
    source config.sh
else
    echo NO config file!
    exit 12345
fi

echo "Started at $(date)"

mkdir -p $DL_CANCER
mkdir -p $DL_CONTROL

echo "Moving cancer files"

echo "Moving unpaired"

for prefix in $CANCER_LIST; do

    #cancer list includes paired and unpaired so we can ignore "file not found" errors
    mv "$DL_SINGLE_DIR"/"$prefix".fastq.gz "$DL_CANCER"/ 2> /dev/null

done

echo "Lets concatenate those"

cat "$DL_CANCER"/*.fastq.gz > $DL_DIR/all_cancer_unpaired.fq.gz

for prefix in $CANCER_LIST; do

    mv "$DL_PAIRED_DIR"/"$prefix"_1.fastq.gz "$DL_CANCER"/ 2> /dev/null
    mv "$DL_PAIRED_DIR"/"$prefix"_2.fastq.gz "$DL_CANCER"/ 2> /dev/null

done

echo "What the heck, lets do more concatenating"

cat "$DL_CANCER"/*_1.fastq.gz > "$DL_DIR"/all_cancer_1.fq.gz
cat "$DL_CANCER"/*_2.fastq.gz > "$DL_DIR"/all_cancer_2.fq.gz

echo "Moving control files"

echo "Moving unpaired"

for prefix in $CONTROL_LIST; do

    mv "$DL_SINGLE_DIR"/"$prefix".fastq.gz "$DL_CONTROL"/ 2> /dev/null

done

echo "Lets concatenate those"

cat "$DL_CONTROL"/*.fastq.gz > $DL_DIR/all_control_unpaired.fq.gz

echo "Moving paired"

for prefix in $CONTROL_LIST; do

    mv "$DL_PAIRED_DIR"/"$prefix"_1.fastq.gz "$DL_CONTROL"/ 2> /dev/null
    mv "$DL_PAIRED_DIR"/"$prefix"_2.fastq.gz "$DL_CONTROL"/ 2> /dev/null

done

echo "What the heck, lets do more concatenating"

cat "$DL_CONTROL"/*_1.fastq.gz > "$DL_DIR"/all_control_1.fq.gz
cat "$DL_CONTROL"/*_2.fastq.gz > "$DL_DIR"/all_control_2.fq.gz

echo "Finished at $(date)"
