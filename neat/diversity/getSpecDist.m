function speciesDist = getSpecDist(population,i,p)
%% getSpecDist - returns one row of species distance matrix
% Should only be used if p.excess ~= p.disjoint, otherwise only one corner
% of the matrix must be calculated.
%
% Syntax:  speciesDist = getSpecDist(pop,i,p)
%
% Inputs:
%    pop           - [1×M]    - population struct
%    i             - [int]    - column to compare to
%    p             - [struct] - Hyperparameters for algorithm
%     .excess      - [1×1]    - weighting of newer non matching genes
%     .disjoint    - [1×1]    - weighting of older non matching genes
%     .weightDif   - [1×1]    - weighting of difference in matching genes
%
% Outputs:
%    speciesDist   - [1Xi]    - the ith row of the species distance matrix
%
% See also: getSpecDist

% Author: Adam Gaier
% Bonn-Rhein-Sieg University of Applied Sciences (BRSU)
% email: adam.gaier@h-brs.de
% Feb 2018; Last revision: 06-Mar-2018

%------------- BEGIN CODE --------------
speciesDist = zeros(1,p.popSize);
for j=1:p.popSize
    speciesDist(j) = species_diff(population(i),population(j),p);
end
%------------- END OF CODE --------------