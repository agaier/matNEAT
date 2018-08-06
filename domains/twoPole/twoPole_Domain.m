function d = twoPole_Domain(nInputs)
%xor_Domain - Domain parameters for the XOR domain
%
%
% Syntax:  d = xor_Domain
%
% Inputs:
%    nInputs - number of inputs in XOR neural network
%    input2 - Description
%    input3 - Description
%
% Outputs:
%    output1 - Description
%    output2 - Description
%
% Example: 
%    Line 1 of example
%    Line 2 of example
%    Line 3 of example
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: OTHER_FUNCTION_NAME1,  OTHER_FUNCTION_NAME2

% Author: Adam Gaier
% Bonn-Rhein-Sieg University of Applied Sciences (BRSU)
% email: adam.gaier@h-brs.de
% Aug 2015; Last revision: 25-Sep-2017

%------------- Input Parsing ------------

%------------- BEGIN CODE --------------

d.name = 'twoPole';
rmpath( genpath('domains')); addpath(genpath(['domains/' d.name '/']));

% Functions
d.fitFun   = 'twoPole_FitnessFunc' ;
d.stop     = 'twoPole_StopCriteria';
d.indVis   = 'twoPole_IndVis';
d.init     = 'twoPole_Initialize';

% Initial Network Topology
d.inputs  = 6;
d.outputs = 1;
d.activations = [1 ones(1,d.inputs) 3]; % Bias, Linear inputs, Sigmoid output
d.actRange = 3; % sigmoidal hidden nodes

% Fitness parameters
d.targetFitness = 1000;
d.gruau = false;



%------------- END OF CODE --------------