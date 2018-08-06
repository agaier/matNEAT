function p = defaultParamSet
% defaultParamSet - Default parameters set as found in original NEAT paper
% Stanley 2009/2002 HyperNEAT/NEAT Publications
%
% Obviously DO change these to suit your problem and tweak them for best
% performance, but here is a good place to start. 
% 
% Popsize		100
% Gens          300
% Disjoint      2
% Excess		2
% Weight		1
% CompatThesh	6
% DropOffAge	15 gens
% SurvivThesh   20%
% AddNode		3%
% AddConn		10%
% MutConn		80%
% Min4Elite     5
% CrossPer      75%
% Reenable      25%
%
% Syntax:  p = defaultParamSet
%
% Outputs:
%     p  - [1×1 struct] - default hyperparameters
%
% Example: 
%    matNeat(defaultParamSet, twoPole_Domain)
%

% Author: Adam Gaier
% Bonn-Rhein-Sieg University of Applied Sciences (BRSU)
% email: adam.gaier@h-brs.de
% Feb 2018; Last revision: 06-Mar-2018

%------------- BEGIN CODE --------------

p.name = 'oNeat';

% Algorithm Parameters
p.maxGen = 1000;
p.popSize= 150;

% Speciation Parameters
p.speciate    = 'spec_oNeat'; %p.speciate='spec_cmdKmeans'; %p.speciate='spec_none';
p.excess      = 2.0;
p.disjoint    = 2.0;
p.weightDif   = 1.0;
p.specThresh  = 6.0;
p.dropOffAge  = 15;
p.targetSpec  = 4;
p.compatMod   = 0.5;
p.minSpThresh = 0.5;

% Selection Parameters
p.cullRatio= 0.2;
p.minForCull= ceil(1/p.cullRatio);
p.minForElitism = 5;
p.tournamentSize = 2;

% Recombination Parameters
p.crossoverProb =   0.75;
p.addNodeProb =     0.03;
p.addConnProb =     0.10;
p.mutConnProb    =  0.80;
p.enableProb =      0.05;
p.weightCap =       5;
p.mutWeightRange =  0.5;

% Visualization Parameters
p.displayMod = 5;

% Individual Fitness Information
p.sampleInd.fitness = 0;




    