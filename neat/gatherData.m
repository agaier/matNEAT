function rec = gatherData(pop,fitness,species,rec,gen)
%gatherData - Gathers data during NEAT run for visualization and analysis
%
% Syntax:  rec = gatherData(pop,fitness,species,rec,gen)
%
% Inputs:
%    pop        - [1×M] - population struct
%       .nodes    [3×N]      
%       .conns    [5×N]      
%    fitness    - [1×M] - fitness of individuals in current gen
%    species    - {1×M} - cell array of species structs
%       .members   - [1×M]          - struct of individuals in species
%       .distance  - [1×M]   - distance from seed to each individual
%       .prevBest  - [1×1]   - best fitness found so far
%       .lastImp   - [int]   - gen of last improvement
%       .offspring - [int]   - number of awarded offspring
%    rec        - [struct]      - recording struct with fields:
%       .p         - [1×1 struct] - used hyperparameters
%       .d         - [1×1 struct] - used domain parameters
%       .elite     - [1×N struct] - elite individuals at every gen
%       .best      - [1×N struct] - best individuals at every gen
%       .bestFit   - [1×N struct] - fitness of best ever at every gen
%       .eliteFit  - [1×N struct] - fitness of elite ever at every gen
%       .fitness   - [N×M double] - fitness of pop at every gen
%       .nodes     - [N×M double] - number of nodes of pop at every gen 
%       .conns     - [N×M double] - number of connections pop at every gen
%   gen         - [int] - current generation
%
% Outputs:
%    rec        - [struct]      - recording struct with fields:
%       .p         - [1×1 struct] - used hyperparameters
%       .d         - [1×1 struct] - used domain parameters
%       .elite     - [1×N struct] - elite individuals at every gen
%       .best      - [1×N struct] - best individuals at every gen
%       .bestFit   - [1×N struct] - fitness of best ever at every gen
%       .eliteFit  - [1×N struct] - fitness of elite ever at every gen
%       .fitness   - [N×M double] - fitness of pop at every gen
%       .nodes     - [N×M double] - number of nodes of pop at every gen 
%       .conns     - [N×M double] - number of connections pop at every gen
%
% See also: matNeat,  visNeat

% Author: Adam Gaier
% Bonn-Rhein-Sieg University of Applied Sciences (BRSU)
% email: adam.gaier@h-brs.de
% Feb 2018; Last revision: 06-Mar-2018

%------------- BEGIN CODE --------------
% Track elite and best solutions
[eliteFit, eliteIndx] = max(fitness); elite = pop(eliteIndx);
if isfield(rec,'bestFit')
    bestFit  = rec.bestFit(end);
    best     = rec.best(end);
else
    bestFit  = eliteFit;
    best     = elite;
end

if eliteFit > bestFit; bestFit = eliteFit; best = elite; end

rec.best    (gen) = best;
rec.bestFit (gen) = bestFit;
rec.elite   (gen) = elite;
rec.eliteFit(gen) = eliteFit;

% Track Fitness
rec.fitness(:,gen) = [pop.fitness];

% Track Structural Mutations
for i=1:length(pop)
    rec.nodes(i,gen) = size(pop(i).nodes,2);
    rec.conns(i,gen) = size(pop(i).conns,2);
end

% Track Species
rec.species = species;

%------------- END OF CODE --------------