function [pop, innovation, p] = initializePop(p,d)
%initializePop - Create initial population and innovation record
%
% Syntax:  [pop,innovation, p] = initializePop(p,d);
%
% Inputs:
%    p - algorithm hyperparameter struct
%    d - domain hyperparameter struct
%
% Outputs:
%    pop        - [1 × popsize] - population struct
%       .fitness  [float]
%       .nodes    [3 × nNodes]       - see below
%                 (1,:) == Node ID
%                 (2,:) == Type (1=input, 2=output 3=hidden 4=bias)
%                 (3,:) == Activation Function (see 'afunct.m)
%       .conns    [5 × nConns]       - see below
%                 (1,:) == Innovation Number
%                 (2,:) == Source
%                 (3,:) == Destination
%                 (4,:) == Weight 
%                 (5,:) == Enabled?
%       .birth    [int]              - generation born
%       .species  [int]              - species ID
%       .pheno    [nNodes × nNodes]  - weight matrix
%    innovation - [5 × nUniqueGenes] - see below
%                 (1,:) == Innovation Number
%                 (2,:) == Source
%                 (3,:) == Destination
%                 (4,:) == New Node?
%                 (5,:) == Generation
%

% Author: Adam Gaier
% Bonn-Rhein-Sieg University of Applied Sciences (BRSU)
% email: adam.gaier@h-brs.de
% Aug 2015; Last revision: 06-Mar-2018

%------------- BEGIN CODE --------------
%% Create base individual
ind = p.sampleInd;

% Create Nodes
ind.nodes(1,:) = [1:(d.inputs+d.outputs+1)];
ind.nodes(2,:) = [4, ones(1,d.inputs), 2*ones(1,d.outputs)]; % Bias, Inputs, Outputs
ind.nodes(3,:) = d.activations;

% Create Connections
numberOfConnections = (d.inputs+1)*d.outputs;
ins = [1:d.inputs+1]; % IDs of input nodes
outs = d.inputs+1 + [1:d.outputs];

ind.conns(1,:) = [1:numberOfConnections];
ind.conns(2,:) = repmat(ins,1,length(outs)); % Once source for every destination
ind.conns(3,:) = sort(repmat(outs,1,length(ins)))';
ind.conns(4,:) = nan (1,numberOfConnections);
ind.conns(5,:) = ones(1,numberOfConnections);


% Initialize struct values
ind.birth = 1;
ind.species = 0;
ind.aMat = [];
ind.wMat = [];

%% Create Population of base individuals with varied weights
nConns = length(ind.conns(4,:));
ind.conns(1,:) = 1:nConns;

% Is the size of the initial population can set independently?
if ~isfield(p,'nInitialSamples'); p.nInitialSamples = p.popSize; end 

% Sobol sequence if you've got it (otherwise random) weights over 0 to 1
if exist('sobolset','file')
    sobSequence  = scramble(sobolset(nConns,'Skip',1e3),'MatousekAffineOwen');
    rawWeight = sobSequence(1:(p.nInitialSamples),:);
else
    rawWeight = rand(p.nInitialSamples, nConns);
end

% Assign weights to individuals and scale weights over allowed range
for iInd=1:p.nInitialSamples
    pop(iInd) = ind; % Base individuals all have same topology %#ok<*AGROW>
    pop(iInd).conns(4,:) = 2.*(rawWeight(iInd,:)-0.5).*p.weightCap;
end

%% Create Innovation Record
innovation          = zeros(5,nConns);
innovation(4,end)   = ind.nodes(1,end);
innovation([1:3],:) = ind.conns([1:3],:);

%------------- END OF CODE --------------