#!/bin/sh
#PBS -N GenericSubmissionName
#PBS -q default
#PBS -l nodes=1:ppn=12
#PBS -l walltime=36:00:00
#PBS -l vmem=36gb

#---------------
# -N          == Name of script
# -q          == Queue (e.g. default, hpc, wr5, hpc2) [use default!]
# -- nodes    == #number of nodes
# -- ppn      == #processors per node
# -- walltime == time till it cuts off automatically
# -- vmem     == RAM to use (see http://wr0.wr.inf.h-brs.de/wr/hardware/hardware.html) for each nodes capability
#---------------

# usage: qsub -N Original_Neat -t 1-2 -v hypName=oNeat sb_hpc_neat.sh
# usage: qsub -N Original_Neat -v hypName=oNeat,runNumber=1 sb_hpc_neat.sh

# Necessary to pseudo-revert to old memory allocation behaviour
export MALLOC_ARENA_MAX=4

# Load Java, needed for parallel computing toolbox
# java/7, java/8 no noticable difference in terms of stability
module load java/default
module load cuda/default

# Run experiment
cd $PBS_O_HOME/Code/matNeat/
#echo ${PBS_ARRAYID}
#matlab -nodisplay -nosplash -nodesktop -r "hpc_neat('$hypName','${PBS_ARRAYID}')" 
matlab -nodisplay -nosplash -nodesktop -r "hpc_neat('$hypName','$runNumber')" 
