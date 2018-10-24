#!/bin/bash

paramName='swing.mat'
for iID in `seq 1 50`
do
	sbatch --export=runId=$iID,ALL sb_matNeat.sh
	#sbatch --export=param=$paramName,runId=$iID,ALL sb_matNeat.sh
done


