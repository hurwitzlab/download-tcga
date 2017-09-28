#!/usr/bin/env bash

#fastq dumping the rest of phs000790 - Comparative Sequence Analysis Between Primary and Metastatic Colorectal Cancer Lesions

set -u
source ./config.sh
export CWD="$PWD"
export STEP_SIZE=1

PROG=`basename $0 ".sh"`
STDOUT_DIR="$CWD/out/$PROG"

init_dir "$STDOUT_DIR" 

#get the fastq for all the sra files
#were ok with human alignment because
#centrifuge will sort it all out
#https://trace.ncbi.nlm.nih.gov/Traces/sra/?run=SRR1592383

cd $SRA_DIR

export LIST="sra_file_list"

find ./ -iname "*.sra" > $LIST

export TODO="files_todo"

if [ -e $TODO ]; then
    rm $TODO
fi

while read SRA; do
    
    if [ ! -e $(basename $SRA .sra)_1.fastq.gz ]; then
        echo $SRA >> $TODO
    fi

done < $LIST

NUM_FILES=$(lc $TODO)

echo Found \"$NUM_FILES\" files in \"$SRA_DIR\" to work on

JOB=$(qsub -J 1-$NUM_FILES:$STEP_SIZE -V -N fastqdump -j oe -o "$STDOUT_DIR" $WORKER_DIR/fastqdump.sh)

if [ $? -eq 0 ]; then
  echo Submitted job \"$JOB\" for you in steps of \"$STEP_SIZE.\" Remember: Kids say the darnedst things.
else
  echo -e "\nError submitting job\n$JOB\n"
fi

