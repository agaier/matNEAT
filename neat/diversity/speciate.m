function [species, p] = speciate(pop, species, p)
%% speciate - Divides pop in species; assign each a share of offspring
% Procedure:
%   1. Assign each member of population to species
%   2. Assign number of offspring to each species
%       2.1 Get normalized species fitness size of species
%       2.2 Assign offspring proportionate to this shared fitness
%   3. If species has not improved in p.dropOffAge generations set the
%      species fitness to 0 to award no offspring
%
% Syntax:  [species,pop] = speciate(pop, species, p)
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
%     .distance    - [1×M]    - distance from seed to each individual
%     .prevBest    - [1×1]    - best fitness found so far
%     .lastImp     - [int]    - gen of last improvement
%     .offspring   - [int]    - number of awarded offspring
%
% See also: spec_oNeat, spec_cmdKmeans, 

% Author: Adam Gaier
% Bonn-Rhein-Sieg University of Applied Sciences (BRSU)
% email: adam.gaier@h-brs.de
% Feb 2018; Last revision: 06-Mar-2018

%------------- BEGIN CODE --------------
%% Divide into Species
[pop, species, p] = feval(p.speciate, pop, species, p);

% Checks
for i=1:length(species); speciesDistrib(i) = length(species{i}.members);end
if sum(speciesDistrib) ~= length(pop);warning('Member of species ~= population');end
if any([pop.species]<1) || length([pop.species]) < length(pop);warning('Not all members of pop assigned species') ;end

%% Calculate Offspring
nSpecies = length(species);
if nSpecies == 1; species{1}.offspring = p.popSize;
else
    %% Explicit fitness sharing
    fitsum = zeros(1,nSpecies);
    fitnessFloor = 1 + -min([pop.fitness]); % Shift all fitness to avoid negative fitness (screws up 
    for s=1:nSpecies
        fitsum(s) = 0;
        members(s) = length(species{s}.members);
        if ~isempty(species{s}.members)
            species{s}.best = species{s}.members(1).fitness;
            for i=1:members(s)
                fitsum(s) = fitsum(s) + (fitnessFloor + species{s}.members(i).fitness).^2; % Favor better even more
                if species{s}.best < species{s}.members(i).fitness
                   species{s}.best = species{s}.members(i).fitness;
                end
            end
        end
        best(s) = species{s}.best;
    end
    
    %% Stagnation -- species that aren't getting better don't get kids
    for s=1:nSpecies
        if species{s}.best <= species{s}.prevBest
            species{s}.lastImp = species{s}.lastImp + 1;
            %disp(['Last Improvement for Species ' int2str(s) ' was ' int2str(species{s}.lastImp) ' gens ago.']);
        else 
            species{s}.prevBest = species{s}.best;
            species{s}.lastImp = 0;
            %disp(['Species ' int2str(s) ' improved!']);            
        end
        
        if species{s}.lastImp >= p.dropOffAge
            fitsum(s) = 0;
            disp('Stagnation');
        end
    end
    
    %% Assign Offspring
    % Error checking
    if(sum(fitsum) == 0);fitsum = ones(size(fitsum)); warning('All Species Fitness equals 0'); end
    if(any(fitsum) <  1); fitsum(fitsum<1) = 1;  warning('Fit sum less than 1');   end
    
    speciesFit = fitsum./members;                  % calculate species fitness [reward consistently good offspring]
    %speciesFit = (fitsum~=0).*(best+fitnessFloor)./members;        % calculate species fitness [reward discovery of peaks]
    speciesFit(or(isnan(speciesFit),isinf(speciesFit))) = 0;              % empty or horrible species have 0 fitness
    speciesFit = speciesFit./sum(speciesFit);       % normalize over all species
    earnedKids = speciesFit.*p.popSize;             % real value earned offspring
    offspring  = floor(earnedKids);                 % integer earned offspring
    remainder  = p.popSize-sum(offspring);          % extra offspring to award
    [~,deserving] = sort(earnedKids-offspring,'descend'); % rank most cheated by rounding down
    
    % Give extra offspring to the species most cheated by rounding
    if remainder > 0
        offspring(deserving(1:remainder)) = offspring(deserving(1:remainder)) + 1;
    end
    
    for s=1:nSpecies; species{s}.offspring = offspring(s); end
    
    if sum(offspring) ~= p.popSize; warning('Offspring not equal to popsize)');end
end

%% Stagnation
% Remove extinct species or stagnating or with 0 total fitness
nextSpecies = species;
extinct = [];
for i=1:length(nextSpecies)
    if (nextSpecies{i}.offspring == 0)
        extinct = [extinct i];
    end
end

if ~isempty(extinct)
    nextSpecies(extinct) = [];   
    % Reassign IDs
    for i=1:length(nextSpecies)
        for iMember = 1:length([nextSpecies{i}.members])
            nextSpecies{i}.members(iMember).species = i;
        end
    end
end

species = nextSpecies;
%------------- END OF CODE --------------