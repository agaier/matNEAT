#!/bin/bash
#SBATCH --partition=any         # partition (queue)
#SBATCH --nodes=1               # number of nodes
#SBATCH --ntasks-per-node=12    # number of cores per node
#SBATCH --mem=32G               # memory per node in MB (different units with suffix K|M|G|T)
#SBATCH --time=2:00:00             # total runtime of job allocation (format D-HH:MM:SS; first parts optional)
#SBATCH --output=log/neat.%j.out    # filename for STDOUT (%N: nodename, %j: job-ID)
#SBATCH --error=log/neat.%j.err     # filename for STDERR

# ---------
# run experiment
matlab -nodisplay -nosplash -nodesktop -r "hpc_neat('swing',$runId)"


