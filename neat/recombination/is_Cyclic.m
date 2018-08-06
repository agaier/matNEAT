function [cyclic, Q] = is_Cyclic(connG, nodeG)
%% is_Cyclic.m - True if connection genes define a graph with cycles.
% This is determined by success/failure of a topological sort. 
%
% NOTE: To avoid having to check again when a connection is reenabled,
% disabled connections are included.
%
% Syntax:  [cyclic, Q] = is_Cyclic(connG, nodeG)
%
% Inputs:
%    connG      - [5×N]     - connection genes
%    nodeG      - [3×N]     - node genes
%
% Outputs:
%    cyclic     - [bool]    - true if connections define a cycle
%    Q          - [1×N]     - Topologically sorted node order
%
%
% Other m-files required: none
% See also: mut_addConn

% Author: Adam Gaier
% Bonn-Rhein-Sieg University of Applied Sciences (BRSU)
% email: adam.gaier@h-brs.de
% Feb 2018; Last revision: 06-Mar-2018

%------------- BEGIN CODE --------------
%% Build connection matrix
connMat = zeros(size(nodeG,2));
hidden      = nodeG(2,:) == 3;
hidlookup   = nodeG(1,hidden);
lookup      = [1:(size(nodeG,2) - length(hidlookup)), hidlookup];

for i=1:size(connG,2)
    in = lookup == connG(2,i);
    out= lookup == connG(3,i);
    w  = connG(4,i);
    connMat(in, out) = w;    
end
connMat(connMat~=0) = 1; 
%% Topological Sort
incoming_edges = sum(connMat,1);
Q = find(incoming_edges==0); % Start with nodes with no connection to them

for i=1:length(connMat)
    if isempty(Q) || i > length(Q)
       Q = []; % Cycle found!!!
       break;
    end
    outgoing_edges = connMat(Q(i),:);
    incoming_edges = incoming_edges - outgoing_edges;
    Q = [Q , quickSetDiff(find(incoming_edges==0),Q)];
    if sum(incoming_edges) == 0
        break;
    end
end

cyclic = isempty(Q);

end