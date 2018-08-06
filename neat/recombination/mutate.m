function [mutant, innovation] = mutate(child,innovation,gen,p,d)
%% mutate - Alters existing solution through node and connection mutations
%
% Syntax:  [mutant, innovation] = mutate(child,innovation,gen,p,d)
%
% Inputs:
%    child      - [struct]  - newly created child ready for mutation
%    innovation - [5×N]     - innovation record
%    gen        - [int]     - current generation
%    p          - [struct]  - algorithm hyperparameters
%     .enableProb       - [1×1] - chance of reenabling a connection
%     .mutConnProb      - [1×1] - chance of mutating a connection
%     .mutWeightRange   - [1×1] - sigma of Gaussian weight mutation
%     .weightCap        - [1×1] - maximum absolute weight value
%    d          - [struct]  - used domain parameters
%     .actRange         - [int] - range of activation functions allowed
%
% Outputs:
%    mutant     - [struct]  - perturbed child solution
%    innovation - [5×N]     - updated innovation record
%
%
% Other m-files required: mut_addNode, mut_addConn
% See also: recombineSpecies,  xover, mut_addNode, mut_addConn

% Author: Adam Gaier
% Bonn-Rhein-Sieg University of Applied Sciences (BRSU)
% email: adam.gaier@h-brs.de
% Feb 2018; Last revision: 06-Mar-2018

%------------- BEGIN CODE --------------

%% Rename for readability
g_len = size(child.conns,2);
connG = child.conns;
nodeG = child.nodes;

%% ReEnable Connection
disabled_conns = find(connG(5,:) == 0);
reenabled = rand(1,length(disabled_conns)) < p.enableProb;
connG(5,disabled_conns) = reenabled;

%% Weight Mutation
mutated_weights = rand(1,g_len) < p.mutConnProb; % Choose weights to mutate
perturbed_weights = mutated_weights.*rand(1,length(mutated_weights));
perturbed_weights = perturbed_weights>0.9;  % 10percent of weight changes are fully random
weight_change   = mutated_weights .* randn(1,g_len) .* p.mutWeightRange;
connG(4,:) = connG(4,:) + weight_change; % Apply mutation
connG(4,perturbed_weights) = 2*(-0.5+rand(1,sum(perturbed_weights)));

% Cap weight strength
connG(4,connG(4,:) >  p.weightCap) =  p.weightCap;
connG(4,connG(4,:) < -p.weightCap) = -p.weightCap;

%% Add Node Mutation
if rand < p.addNodeProb && ~isempty(find(connG(5,:) == 1, 1))
    [connG, nodeG, innovation] = ...
        mut_addNode(connG, nodeG, d.actRange, innovation, gen);    
end

%% Add Connection Mutation
if rand < p.addConnProb
    [connG, innovation] = ...
        mut_addConn(connG, nodeG, innovation, gen, p);
end

%% Create mutated child
mutant = child;
mutant.fitness = [];
mutant.species = 0 ;
mutant.nodes = nodeG;
mutant.conns = connG;
