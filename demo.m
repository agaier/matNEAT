%demo - Demonstrates usage of matNEAT

% Author: Adam Gaier
% Bonn-Rhein-Sieg University of Applied Sciences (BRSU)
% email: adam.gaier@h-brs.de
% Feb 2018; Last revision: 06-Mar-2018

%------------- BEGIN CODE --------------


%% Run NEAT once
clear;
addAllToPath;   % We add all folders to path, when a problem domain is 
                % loaded we exclude other domain files to ensure no overlap
                % in functions. When we change domains these new domain's 
                % folder have to be put back in the path.

% Load default hyperparameters
p = defaultParamSet; % defaults from ECJ 2002 article
p.popSize = 2^7;     % Change hyperparameters as you like

% Load domain hyperparameters
d = twoPole_Domain;

% View progress every 5 generations
p.displayMod = 5;

% Run NEAT
a = matNeat(p,d);

%% Change domain and hyperparameters
addAllToPath; d = swingUp_Domain;
p.maxGen = 50;    % Let's not make this demo last too long 
matNeat(p,d);

%% Run NEAT experiments on single computer
addAllToPath; d = twoPole_Domain; % Define domain

% Default Hyperparameters
p1 = matNeat;       % Calling without arguments will return default parameters
p1.displayMod = 0;  % Don't waste time plotting
p1.name = 'default';

% Create another set of hyperparameters
p2 = p1;         
p2.addConnProb = p2.addConnProb/2;
p2.addNodeProb = p2.addNodeProb/2;
p2.mutConnProb = p2.mutConnProb/2;
p2.name = 'halfMut';

% Run multiple experiments and save results
nExp = 3;
for iExp = 1:nExp
    rec1(iExp) = matNeat(p1,d); %#ok<SAGROW>
    rec2(iExp) = matNeat(p2,d); %#ok<SAGROW>
end
save('data.mat','p1','p2','rec1','rec2') % Save data for analyis

%% Run NEAT experiments on cluster
% Save hyperparameter and domain structs to file
d = twoPole_Domain;
p = p1; save([p.name '.mat'], 'p','d');
p = p2; save([p.name '.mat'], 'p','d');

% Run this function through your clusters scheduler, it will save the
% results to disk when the experiment is completed.
% e.g.: qsub -N NeatExperiment -v hypName=halfMut,jobID=1 sb_hpc_neat.sh 
hpc_neat(p1.name,'1')

%% Run using OpenAI gym domains
% OpenAI Gym environments can be used through an http interface, though it
% is quite slow. When/if MuJuCo begins supporting MATLAB natively this
% can be fixed. For now, follow the installation instructions on:
%   https://github.com/openai/gym
%   https://github.com/openai/gym-http-api
%   https://github.com/openai/mujoco-py
%
% Once installed, before starting optimization in MATLAB you must first
% start a http server. In a terminal from the halfCheetah_src folder run:
%   python gym_http_server.py
%   
% Then continue normally:
addAllToPath; d = halfCheetah_Domain;
matNeat(p,d);

%------------- END OF CODE --------------