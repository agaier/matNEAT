function hpc_neat(hypName, runID)
% Sample matlab script to be run on cluster - [RUN THROUGH QSUB]
%
% Syntax:  qsub -N Neat -t 1-3 -v hypName=NeatParams sb_hpc_neat.sh
%
% See also: sb_hpc_matlab.sh below
%
%%
% Author: Adam Gaier
% Bonn-Rhein-Sieg University of Applied Sciences (BRSU)
% email: adam.gaier@h-brs.de
% Nov 2017; Last revision: 02-Nov-2017

%%

%% Ensure Randomness of Randomness
% Otherwise all your replicate jobs will be the same. 
RandStream.setGlobalStream(RandStream('mt19937ar','Seed','shuffle'));

%% Add all files to path
currentPath = mfilename('fullpath'); 
addpath(genpath(currentPath(1:end-length(mfilename)))); % All files above this mfile
addpath(genpath('~/Code/matlabExtensions/'));           % Add some other folder

%% Run Algorithm
runTime = tic;
disp('Running Job')

% Load hyperparameters
load([hypName '.mat'],'p','d');
p.name = [hypName 'Trial_' runID];
p.vis = false;

% Run Algorithm
disp(['Starting experiment: ' p.name]);
rec = matNeat(p,d);

% Save results
save(p.name, 'rec','p','d')

%%
disp(['Runtime: ' seconds2human(toc(runTime))]);

end

%------------- END OF CODE --------------
% Syntax:  qsub -N Original_Neat -t 1-3 -v hypName=oNeat sb_hpc_neat.sh
