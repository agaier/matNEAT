#!/bin/bash
#SBATCH --partition=any         # partition (queue)
#SBATCH --nodes=1               # number of nodes
#SBATCH --ntasks-per-node=12    # number of cores per node
#SBATCH --mem=32G               # memory per node in MB (different units with suffix K|M|G|T)
#SBATCH --time=2:00             # total runtime of job allocation (format D-HH:MM:SS; first parts optional)
#SBATCH --output=neat.%j.out    # filename for STDOUT (%N: nodename, %j: job-ID)
#SBATCH --error=neat.%j.err     # filename for STDERR

# load necessary modules
module load java/default # for parallel computing
module load cuda/default # for parallel computing
alias matlab=/usr_local_old/MATLAB/R2017a/bin/matlab

# move to appropriate folder
cd /home/agaier2m/Code/matNEAT


# run experiment
matlab -nodisplay -nosplash -nodesktop -r "hpc_neat('test','1')"

# ---------
# run: sbatch slurm_neat.sh
