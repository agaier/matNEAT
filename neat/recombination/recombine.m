function [newpop, innovation] = recombine(species, innovation, gen, p, d)
%% recombine - Perform recombination within each species to produce new pop
%
% Syntax:  [newpop, innovation] = recombine(species, innovation, gen, p, d)
%
% Inputs:
%    species       - {1×M}  - cell array of species structs
%    innovation    - [5×N]  - innovation record
%    gen           - [int]  - current generation
%    p            - [struct]   - selection and recombination parameters
%    d            - [struct]   - used domain parameters
%     .actRange   - [int]      - range of activation functions allowed

% Outputs:
%    newpop     - [1×M] - new population struct
%    innovation - [5×nUniqueGenes] - updated innovation record
%
% Other m-files required: recombineSpecies
% See also: recombineSpecies

% Author: Adam Gaier
% Bonn-Rhein-Sieg University of Applied Sciences (BRSU)
% email: adam.gaier@h-brs.de
% Feb 2018; Last revision: 06-Mar-2018

%------------- BEGIN CODE --------------
    
newpop = [];
for i=1:length(species)
    if species{i}.offspring > 0
        [children, innovation] = recombineSpecies(species{i}, innovation, gen, p, d);
        newpop = [newpop children]; %#ok<AGROW>
    end
end

