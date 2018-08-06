function [pop, species] = spec_cmdKmeans(pop,species,p)
%% cmdKmeans_speciation.m - Divide population into species with classic multidimensional scaling and kmeans
%   Procedure:
%       1. Produce compatibility distance matrix of all individuals in
%       population
%           1.1 'getSpecDist_ltd' only computes top corner (only if excess
%           and disjoint values are equal!)
%           1.2 'getSpecDist' computes all values
%       2. Perform classic multidimensional scaling to assign each
%       individual coordinates in n-d space
%       3. Perform kmeans clustering using euclidean distance between n-d
%       coordinates produced in (2), to group each individual into the
%       desired number of species
%
%   Note: Computing the full species matrix can be expensive with a large
%   population if you must do it serially. 
%
% Syntax:  [pop, species] = spec_cmdKmeans(pop,species,p)
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
% See also: speciate, spec_oNeat

% Author: Adam Gaier
% Bonn-Rhein-Sieg University of Applied Sciences (BRSU)
% email: adam.gaier@h-brs.de
% Feb 2018; Last revision: 06-Mar-2018

%------------- BEGIN CODE --------------
if isempty(species)
    %% Build first set of species
    speciesDist = zeros(p.popSize);
    parfor i = 1:p.popSize
        speciesDist(i,:) = getSpecDist_ltd(pop,i,p);
    end
    speciesDist = speciesDist+speciesDist'; % Copy upper half to lower
       
    % Multidimensional Scaling into n-d coordinates
    indCoords = cmdscale(speciesDist);
    [specIndex] = kmeans(indCoords,p.targetSpec);
    
    for s=1:p.targetSpec
        prevSpecies{s}.prevBest = 0; %#ok<AGROW>
        prevSpecies{s}.lastImp = 0; %#ok<AGROW>
    end
    
else
    %% Get Previous Seeds
    prevSpecies = species;
    for i=1:length(prevSpecies)
        seed(i) = prevSpecies{i}.members(1); %#ok<AGROW>
        % These values will be removed later, but MATLAB gets cranky with
        % uninitialized structs
        species{i}.members(1) = seed(i);
        species{i}.members(1).species = i;
        species{i}.distance(1) = 0;
        
    end
    pop_with_seeds = [seed(:); pop(:)];
    fullPopSize = length(pop_with_seeds);
    
    % Create distance matrix
    speciesDist = zeros(fullPopSize);
    
    parfor i = 1:fullPopSize
        speciesDist(i,:) = getSpecDist_ltd(pop_with_seeds,i,p);
    end
    
    speciesDist = speciesDist+speciesDist'; % Copy upper half to lower
    
    % Multidimensional Scaling into n-d coordinates
    indCoords = cmdscale(speciesDist);
    
    % Get coordinates of previous seeds and remove them from population
    prevSeedCoords = indCoords(1:length(prevSpecies),:);
    indCoords(1:length(prevSpecies),:) = [];
    
    % Random individuals as species seeds
    [~, randRows] = sort(rand(1,p.popSize));
    startMat = indCoords(randRows(1:p.targetSpec),:);
    startMat(1:length(prevSpecies),:) = prevSeedCoords;
    
    % Group into species via kmeans around previous seeds
    [specIndex] = kmeans(indCoords,p.targetSpec,'Start',startMat);
    
    clear species;
end

%% Assign members to species
for i=1:p.targetSpec
    species{i}.members = pop(specIndex==i);
    if length(prevSpecies) < i
        species{i}.prevBest = 0;
        species{i}.lastImp = 0;
    else
        species{i}.prevBest = prevSpecies{i}.prevBest;
        species{i}.lastImp = prevSpecies{i}.lastImp;
    end
end

for i=1:length(pop)
    pop(i).species = specIndex(i);
end
