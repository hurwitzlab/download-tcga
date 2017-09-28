export CWD=$PWD
export SCRIPT_DIR=$CWD
#root project dir
export PRJ_DIR="/rsgrps/bhurwitz/scottdaniel/download-dbgap"
#where the worker scripts are (PBS batch scripts and their python/perl workdogs)
export WORKER_DIR="$SCRIPT_DIR/workers"

#encryption key, change to whatever yours is
export KEY="prj_9499.ngc"

#cart downloaded from dbgap "run browser" container list of files to download
export CART="cart_prj9499_phs000374.krt"

#main download / working directory
export SRA_DIR="/rsgrps/bhurwitz/hurwitzlab/data/raw/Doetschman_20111007/human/phs000374"
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
