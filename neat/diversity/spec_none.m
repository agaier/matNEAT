function [pop, species] = spec_none(pop,species,p)
%% spec_none - All individuals belong to the same species
% For testing a debugging purposes only
%
% Syntax:  [pop, species] = spec_oNeat(pop,species,p)
%
% See also: speciate, spec_oNeat, spec_cmdKmeans

% Author: Adam Gaier
% Bonn-Rhein-Sieg University of Applied Sciences (BRSU)
% email: adam.gaier@h-brs.de
% Feb 2018; Last revision: 06-Mar-2018

%------------- BEGIN CODE --------------
species{1}.members = pop;
for i=1:length(pop); pop(i).species = 1; end
%------------- END OF CODE --------------

