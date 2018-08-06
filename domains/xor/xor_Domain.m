function d = xor_Domain(nInputs)
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
if nargin==0; nInputs = 2; end
%------------- BEGIN CODE --------------

d.name = 'xor';
rmpath( genpath('domains')); addpath(genpath(['domains/' d.name '/']));

% Functions
d.fitFun   = 'xor_FitnessFunc' ;
d.stop     = 'xor_StopCriteria';
d.indVis   = 'xor_IndVis';
d.init     = 'xor_Initialize';

% Network Topology
d.inputs  = nInputs;
d.outputs = 1;
d.activations = [1 ones(1,nInputs) 2]; % All linear until end, then step
d.actRange = 3;

%
d.targetFitness = 16;



%------------- END OF CODE --------------