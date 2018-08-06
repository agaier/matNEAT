function [newpop, species, innovation, p] = evolveNeatGen(pop, species, innovation, gen, p, d)
%% evolveNeatGen - Creates new population through NEAT evolution rules
%
% Syntax:  [newpop, species, innovation] = evolveNeatGen(pop, species, innovation, gen, p, d)
%
% Inputs:
%    pop        - [1×M] - population struct
%    species    - {1×M} - cell array of species structs
%    innovation - [5×nUniqueGenes] - innovation record
%    gen        - [int] - current generation
%    p  - struct - Hyperparameters for algorithm, visualization, and data gathering
%    d  - struct - Domain definition
%
% Outputs:
%    newpop     - [1×M] - new population struct
%    species    - {1×M} - new array of species structs
%    innovation - [5×nUniqueGenes] - updated innovation record
%
% Other m-files required: speciate, recombine
%
% See also: matNeat

% Author: Adam Gaier
% Bonn-Rhein-Sieg University of Applied Sciences (BRSU)
% email: adam.gaier@h-brs.de
% Feb 2018; Last revision: 06-Mar-2018

%------------- BEGIN CODE --------------
[species,p]             = speciate(pop, species, p);
[newpop, innovation]    = recombine(species, innovation, gen, p, d);
%------------- END OF CODE --------------