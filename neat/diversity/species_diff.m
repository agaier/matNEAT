function difference = species_diff(ref,ind,p)
%% species_diff.m - Returns compatibility distance between two individuals based on innovation numbers
% Should only be used if p.excess ~= p.disjoint, otherwise only one corner
% of the matrix must be calculated.
%
% Syntax:  speciesDist = getSpecDist(pop,i,p)
%
% Inputs:
%    ref           - [1×M]    - individual we are comparing _to_
%    ind           - [int]    - individual we are comparing
%    p             - [struct] - Hyperparameters for algorithm
%     .excess      - [1×1]    - weighting of newer non matching genes
%     .disjoint    - [1×1]    - weighting of older non matching genes
%     .weightDif   - [1×1]    - weighting of difference in matching genes
%
% Outputs:
%    difference    - [1×1]    - species difference between ref and ind
%
% Other m-files required: quickIntersectIndex
% See also: getSpecDist

% Author: Adam Gaier
% Bonn-Rhein-Sieg University of Applied Sciences (BRSU)
% email: adam.gaier@h-brs.de
% Feb 2018; Last revision: 06-Mar-2018

%------------- BEGIN CODE --------------
max_innov = max(ref.conns(1,:));

% Weight difference in matching connections
[IA,IB] = quickIntersectIndex(ind.conns(1,:), ref.conns(1,:));
weight_diff = sum(abs(ind.conns(4,IA)-ref.conns(4,IB)))/length(abs(ind.conns(4,IA)-ref.conns(4,IB)));

% Connections not in common
nonMatching = [ref.conns(1,~IB) ind.conns(1,~IA)];
excess =    nonMatching <  max_innov;
disjoint =  nonMatching >= max_innov;

difference = p.excess*sum(excess) + p.disjoint*sum(disjoint) + p.weightDif*weight_diff;
end