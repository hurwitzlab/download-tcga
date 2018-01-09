#!/usr/bin/env python

#PBS -W group_list=bhurwitz
#PBS -q standard
#PBS -l select=1:ncpus=1:mem=1gb
#PBS -l walltime=72:00:00
#PBS -l cput=72:00:00
#PBS -M scottdaniel@email.arizona.edu
#PBS -m ea
#PBS -j oe
#PBS -N testpbspython
#PBS -o pbs_logs/
#PBS -e pbs_logs/

from __future__ import print_function
import os, sys

print("Current working directory is {:s}\n".format(os.getcwd))

print("Current arguments are {:s}\n".format(sys.argv))

print("Current environmental variable are {:s}\n".format(os.environ))
