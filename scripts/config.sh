export CWD=$PWD
export SCRIPT_DIR=$CWD
#root project dir
export PRJ_DIR="/rsgrps/bhurwitz/scottdaniel/download-tcga"
#where the worker scripts are (PBS batch scripts and their python/perl workdogs)
export WORKER_DIR="$SCRIPT_DIR/workers"

#encryption key, change to whatever yours is
export KEY="gdc-user-token.2017-10-04T13-55-09-07-00.txt"

#cart downloaded from dbgap "run browser" container list of files to download
export CART="colorectal_normal_tissue_all_fastq.txt"

#main download / working directory
export TCGA_DIR="/rsgrps/bhurwitz/hurwitzlab/data/controlled_access/legacy"
# --------------------------------------------------
function init_dir {
    for dir in $*; do
        if [ -d "$dir" ]; then
            rm -rf $dir/*
        else
            mkdir -p "$dir"
        fi
    done
}

# --------------------------------------------------
function lc() {
    wc -l $1 | cut -d ' ' -f 1
}
