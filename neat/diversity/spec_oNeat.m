function [pop, species, p] = spec_oNeat(pop,species,p)
%% spec_oNEAT - Original NEAT speciation, i.e. first compatible seed
%   Procedure:
%       1. Take first individual from each previous gens species as seeds
%           1.1 If no seeds are given the first individual will be taken as
%           the only seed
%       2. Assign each member of population to first species within
%       compatibility distance
%           2.1 If no seed within cdist, that ind becomes a new seed
%
% Syntax:  [pop, species] = spec_oNeat(pop,species,p)
%
% Inputs:
%    pop           - [1×M]    - population struct
%    species       - {1×M}    - cell array of species structs
%     .members     - [1×M]    - struct of individuals in species
%     .distance    - [1×M]    - distance from seed to each individual
%     .prevBest    - [1×1]    - best fitness found so far
%     .lastImp     - [int]    - gen of last improvement
%     .offspring   - [int]    - number of awarded offspring
%   p              - [struct] - Hyperparameters for algorithm
%     .speciate    - [mfile]  - procedure to assign individuals to species
%     .excess      - [1×1]    - weighting of newer non matching genes
%     .disjoint    - [1×1]    - weighting of older non matching genes
%     .weightDif   - [1×1]    - weighting of difference in matching genes
%     .specThresh  - [1×1]    - threshold for belonging to a species
%     .dropOffAge  - [1×1]    - generations before species is 'stagnant'
%     .targetSpec  - [1×1]    - desired number of species
%
%
% Outputs:
%    species       - {1×M}    - cell array of species structs
%     .members     - [1×M]    - struct of individuals in species
%
% See also: speciate, spec_cmdKmeans

% Author: Adam Gaier
% Bonn-Rhein-Sieg University of Applied Sciences (BRSU)
% email: adam.gaier@h-brs.de
% Feb 2018; Last revision: 06-Mar-2018

%------------- BEGIN CODE --------------
%% Adjust compatibility threshold to track desired number of species
% [see NEAT user's page: https://www.cs.ucf.edu/~kstanley/neat.html]
if length(species)<p.targetSpec
    p.specThresh = p.specThresh - p.compatMod;   else
    p.specThresh = p.specThresh + p.compatMod;
end
p.specThresh(p.specThresh<p.minSpThresh)=p.minSpThresh; % Bind to minimum value

    %% Get Previous Seeds
if isempty(species)
    seed(1) = pop(1);
    species{1}.members(1) = pop(1);
    species{1}.members(1).species = 1;
    species{1}.distance(1) = 0;
    species{1}.prevBest = 0;
    species{1}.lastImp = 0;
    prevSpecies = species{1};
else
    prevSpecies = species;
    
    % Add species seeds from remaining species
    for i=1:length(prevSpecies)
       seed(i) = prevSpecies{i}.members(1);
       species{i}.members(2:end) = [];     % Clear older population
       species{i}.members = seed(i);    % Insert seeds into each species
       species{i}.members.species = i;
       species{i}.distance = 0;
    end
end
%% Assign Species
% Cycle through population, assigning individual to first species seed
% within compatibility difference
for i=1:length(pop)
    assigned = false;
    for s=1:length(seed)
        diff = species_diff(seed(s),pop(i), p);
        if diff < p.specThresh
            pop(i).species = s;
            species{s}.members(end+1) = pop(i);
            species{s}.distance(end+1) = diff;
            assigned = true;
            break;
        end
    end
    
    % If no seed is close enough, create new species centered on this
    % individual
    if ~assigned
        seed(end+1) = pop(i);
        species{end+1}.members = pop(i);
        pop(i).species = s+1;
        species{end}.seed = pop(i);
        
        species{end}.distance = 0;        
        species{end}.prevBest = 0;
        species{end}.lastImp = 0;
    end
end

% Remove prev gen seeds from species
extinct = [];
for i=1:length(prevSpecies)
   species{i}.distance(1) = []; 
   species{i}.members(1) = [];
   if isempty(species{i}.members)
       extinct = [extinct i];
   end
end
%------------- END OF CODE --------------