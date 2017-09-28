#!/usr/bin/env bash

#Decrypting and fastq dumping phs000374 

set -u
source ./config.sh
export CWD="$PWD"
export STEP_SIZE=2

PROG=`basename $0 ".sh"`
STDOUT_DIR="$CWD/out/$PROG"

init_dir "$STDOUT_DIR" 

#check that all files are decrypted
#get the fastq for all the sra files
#were ok with human alignment because
#centrifuge will sort it all out

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

JOB=$(qsub -J 1-$NUM_FILES:$STEP_SIZE -V -N fastqdump -j oe -o "$STDOUT_DIR" $WORKER_DIR/decrypt_n_dump.sh)

if [ $? -eq 0 ]; then
  echo "Submitted job \"$JOB\" for you in steps of \"$STEP_SIZE.\"
  Naeser's Law: You can make it foolproof, but you can't make it damnfoolproof."
else
  echo -e "\nError submitting job\n$JOB\n"
fi

