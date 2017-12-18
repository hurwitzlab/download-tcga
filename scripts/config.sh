export CWD=$PWD
export SCRIPT_DIR=$CWD
#root project dir
export PRJ_DIR="/rsgrps/bhurwitz/scottdaniel/download-ebi"
#where the worker scripts are (PBS batch scripts and their python/perl workdogs)
export WORKER_DIR="$SCRIPT_DIR/workers"

export MASTERLIST="$PRJ_DIR/PRJEB12449.txt"
export CART="$PRJ_DIR/files_to_get_list"

#main download / working directory
export DL_DIR="/rsgrps/bhurwitz/hurwitzlab/data/controlled_access/PRJEB12449"
export DL_PAIRED_DIR="$DL_DIR/paired"
export DL_SINGLE_DIR="$DL_DIR/single"

