function child = xover(pA, pB)
%% xover - Create child from two individuals according to NEAT rules
%   Preconditions:
%       - ParentA has higher fitess than ParentB
%
%   Procedure:
%       - Copy node and connection genes from ParentA
%       - Identify matching connection genes in ParentA and ParentB
%       - With random chance take matching connection weights from ParentB
%
%   Output:
%       - Child individual
%       - Note: species ID is maintained because of copying
%
% Syntax:  child = xover(parentA, parentB)
%
% Inputs:
%    parentA - [struct] - individual with higher fitness
%    parentB - [struct] - individual with lower  fitness
%
% Outputs:
%    child   - [struct] - newly created child from combination of parents
%
% See also: recombineSpecies,  mutate

% Author: Adam Gaier
% Bonn-Rhein-Sieg University of Applied Sciences (BRSU)
% email: adam.gaier@h-brs.de
% Feb 2018; Last revision: 06-Mar-2018

%------------- BEGIN CODE --------------
% Inherit all nodes and connections from most fit parent
child = pA; child.fitness = [];

% Identify matching connection genes in ParentA and ParentB
aConns = pA.conns(1,:);
bConns = pB.conns(1,:);
[matching,IA,IB] = intersect(aConns,bConns); % Could be sped up w/quickIntersect...

% Replace weights with ParentB weights with some probability
bProb = 0.50;
bgenes = rand(1,length(matching))<bProb;
child.conns(:,IA(bgenes)) = pB.conns(:,IB(bgenes));
%------------- END OF CODE --------------