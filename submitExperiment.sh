#!/bin/bash

for iID in `seq 1 3`
do
	sbatch --export=param=$iParam,runId=$iID,ALL sb_matNeat.sh
done


