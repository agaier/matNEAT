function d = swingUp_Domain
%xor_Domain - Domain parameters for the XOR domain
%
%
% Syntax:  d = swingUp_Domain
%

% Author: Adam Gaier
% Bonn-Rhein-Sieg University of Applied Sciences (BRSU)
% email: adam.gaier@h-brs.de
% Dec 2017; Last revision: 05-Dec-2017

%------------- Input Parsing ------------

%------------- BEGIN CODE --------------

d.name = 'swingUp';
rmpath( genpath('domains')); addpath(genpath(['domains/' d.name '/']));

% Functions
d.fitFun   = 'swingUp_FitnessFunc' ;
d.stop     = 'swingUp_StopCriteria';
d.indVis   = 'swingUp_IndVis';
d.init     = 'swingUp_Initialize';

% Initial Network Topology
d.inputs  = 4;
d.outputs = 1;
d.activations = [1 ones(1,d.inputs) 5]; % Bias, Linear inputs, Sigmoid output
d.actRange = 5; % signed sigmoidal hidden nodes

% Fitness parameters
% d.targetFitness = 1000;
% d.gruau = false;



%------------- END OF CODE --------------