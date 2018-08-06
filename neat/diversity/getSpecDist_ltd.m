function speciesDist = getSpecDist_ltd(pop,i,p)
%% getSpecDist_ltd - returns row of species distance matrix up to point
% Should only be used if p.excess == p.disjoint, otherwise entire matrix
% must be calculated.
%
% Syntax:  speciesDist = getSpecDist_ltd(pop,i,p)
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
speciesDist = zeros(1,length(pop));
for j=i:length(pop)
    speciesDist(j) = species_diff(pop(i),pop(j),p);
end
%------------- END OF CODE --------------