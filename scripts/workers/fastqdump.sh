#!/usr/bin/env bash

#fastq dumping the rest of phs000790 - Comparative Sequence Analysis Between Primary and Metastatic Colorectal Cancer Lesions

#PBS -W group_list=bhurwitz
#PBS -q standard
#PBS -l select=1:ncpus=2:mem=3gb
#PBS -l walltime=72:00:00
#PBS -l cput=72:00:00
#PBS -M scottdaniel@email.arizona.edu
#PBS -m bea

unset module
set -u

COMMON="$WORKER_DIR/common.sh"

if [ -e $COMMON ]; then
  . "$COMMON"
else
  echo Missing common \"$COMMON\"
  exit 1
fi

cd $SRA_DIR

TMP_FILES=$(mktemp)

get_lines $TODO $TMP_FILES $PBS_ARRAY_INDEX $STEP_SIZE

NUM_FILES=$(lc $TMP_FILES)

if [[ $NUM_FILES -lt 1 ]]; then
    echo Something went wrong or no files to process
    exit 1
else
    echo Found \"$NUM_FILES\" files to process
fi

#get the fastq for all the sra files

for NAME in $(cat $TMP_FILES); do     
    echo Working on $NAME
    fastq-dump -W -F --gzip --split-files $NAME
done
#-W clips adapters (supposedly), --gzip keep compressed to save space, --split-files split into Read1 and Read2 since these are supposed to be paired end and the interleaved file didn't look like it, --unaligned because we want bacteria

#Usage:
#  fastq-dump [options] <path> [<path>...]
#  fastq-dump [options] <accession>
#
#INPUT
#  -A|--accession <accession>       Replaces accession derived from <path> in
#                                   filename(s) and deflines (only for single
#                                   table dump)
#  --table <table-name>             Table name within cSRA object, default is
#                                   "SEQUENCE"
#
#PROCESSING
#
#Read Splitting                     Sequence data may be used in raw form or
#                                     split into individual reads
#  --split-spot                     Split spots into individual reads
#
#Full Spot Filters                  Applied to the full spot independently
#                                     of --split-spot
#  -N|--minSpotId <rowid>           Minimum spot id
#  -X|--maxSpotId <rowid>           Maximum spot id
#  --spot-groups <[list]>           Filter by SPOT_GROUP (member): name[,...]
#  -W|--clip                        Clip adapter sequences
#
#Common Filters                     Applied to spots when --split-spot is not
#                                     set, otherwise - to individual reads
#  -M|--minReadLen <len>            Filter by sequence length >= <len>
#  -R|--read-filter <[filter]>      Split into files by READ_FILTER value
#                                   optionally filter by value:
#                                   pass|reject|criteria|redacted
#  -E|--qual-filter                 Filter used in early 1000 Genomes data: no
#                                   sequences starting or ending with >= 10N
#  --qual-filter-1                  Filter used in current 1000 Genomes data
#
#Filters based on alignments        Filters are active when alignment
#                                     data are present
#  --aligned                        Dump only aligned sequences
#  --unaligned                      Dump only unaligned sequences
#  --aligned-region <name[:from-to]>  Filter by position on genome. Name can
#                                   either be accession.version (ex:
#                                   NC_000001.10) or file specific name (ex:
#                                   "chr1" or "1"). "from" and "to" are 1-based
#                                   coordinates
#  --matepair-distance <from-to|unknown>  Filter by distance between matepairs.
#                                   Use "unknown" to find matepairs split
#                                   between the references. Use from-to to limit
#                                   matepair distance on the same reference
#
#Filters for individual reads       Applied only with --split-spot set
#  --skip-technical                 Dump only biological reads
#
#OUTPUT
#  -O|--outdir <path>               Output directory, default is working
#                                   directory '.' )
#  -Z|--stdout                      Output to stdout, all split data become
#                                   joined into single stream
#  --gzip                           Compress output using gzip
#  --bzip2                          Compress output using bzip2
#
#Multiple File Options              Setting these options will produce more
#                                     than 1 file, each of which will be suffixed
#                                     according to splitting criteria.
#  --split-files                    Dump each read into separate file.Files
#                                   will receive suffix corresponding to read
#                                   number
#  --split-3                        Legacy 3-file splitting for mate-pairs:
#                                   First biological reads satisfying dumping
#                                   conditions are placed in files *_1.fastq and
#                                   *_2.fastq If only one biological read is
#                                   present it is placed in *.fastq Biological
#                                   reads and above are ignored.
#  -G|--spot-group                  Split into files by SPOT_GROUP (member name)
#  -R|--read-filter <[filter]>      Split into files by READ_FILTER value
#                                   optionally filter by value:
#                                   pass|reject|criteria|redacted
#  -T|--group-in-dirs               Split into subdirectories instead of files
#  -K|--keep-empty-files            Do not delete empty files
#
#FORMATTING
#
#Sequence
#  -C|--dumpcs <[cskey]>            Formats sequence using color space (default
#                                   for SOLiD),"cskey" may be specified for
#                                   translation
#  -B|--dumpbase                    Formats sequence using base space (default
#                                   for other than SOLiD).
#
#Quality
#  -Q|--offset <integer>            Offset to use for quality conversion,
#                                   default is 33
#  --fasta <[line width]>           FASTA only, no qualities, optional line
#                                   wrap width (set to zero for no wrapping)
#  --suppress-qual-for-cskey        suppress quality-value for cskey
#
#Defline
#  -F|--origfmt                     Defline contains only original sequence name
#  -I|--readids                     Append read id after spot id as
#                                   'accession.spot.readid' on defline
#  --helicos                        Helicos style defline
#  --defline-seq <fmt>              Defline format specification for sequence.
#  --defline-qual <fmt>             Defline format specification for quality.
#                                   <fmt> is string of characters and/or
#                                   variables. The variables can be one of: $ac
#                                   - accession, $si spot id, $sn spot
#                                   name, $sg spot group (barcode), $sl spot
#                                   length in bases, $ri read number, $rn
#                                   read name, $rl read length in bases. '[]'
#                                   could be used for an optional output: if
#                                   all vars in [] yield empty values whole
#                                   group is not printed. Empty value is empty
#                                   string or for numeric variables. Ex:
#                                   @$sn[_$rn]/$ri '_$rn' is omitted if name
#                                   is empty
#
#OTHER:
#  --disable-multithreading         disable multithreading
#  -h|--help                        Output brief explanation of program usage
#  -V|--version                     Display the version of the program
#  -L|--log-level <level>           Logging level as number or enum string One
#                                   of (fatal|sys|int|err|warn|info) or (0-5)
#                                   Current/default is warn
#  -v|--verbose                     Increase the verbosity level of the program
#                                   Use multiple times for more verbosity
#  --ncbi_error_report              Control program execution environment
#                                   report generation (if implemented). One of
#                                   (never|error|always). Default is error
#  --legacy-report                  use legacy style 'Written spots' for tool
#
#fastq-dump : 2.8.2
#
