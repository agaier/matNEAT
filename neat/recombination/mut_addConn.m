function [connG, innovation] = mut_addConn(connG, nodeG, innovation, gen, p)
%% mut_addConn.m - Adds a new connection if possible, and adds it to innovation record.
%
% Syntax:  [connG, innovation] = mut_addConn(connG, nodeG, innovation, gen, p)
%
% Inputs:
%    connG      - [5×N]     - connection genes
%    nodeG      - [3×N]     - node genes
%    innovation - [5×N]     - innovation record
%    gen        - [int]     - current generation
%    p          - [struct]  - algorithm hyperparameters
%     .weightCap - [1×1]     - maximum absolute weight value
%
% Outputs:
%    connG      - [5×N]     - updated connection genes
%    innovation - [5×N]     - updated innovation record
%
%
% Other m-files required: is_Cyclic
% See also: recombineSpecies, xover, mut_addNode, is_Cyclic

% Author: Adam Gaier
% Bonn-Rhein-Sieg University of Applied Sciences (BRSU)
% email: adam.gaier@h-brs.de
% Feb 2018; Last revision: 06-Mar-2018

%------------- BEGIN CODE --------------
nextInnov = innovation(1,end)+1;

%% Create set of possible connections
% Possible connections in FFNN are from any node but output to any
% nodes but input
outputs = find(nodeG(2,:)==2);
inputs  = union(find(nodeG(2,:)==1), find(nodeG(2,:)==4)); % and bias

from_nodes  = setxor(nodeG(1,:), outputs);
to_nodes    = setxor(nodeG(1,:),inputs);

[r,q]       = meshgrid(from_nodes, to_nodes);
all_conns   = [r(:) q(:)];

% Remove already existing connections from set of possible connections
current_conns = connG([2 3],:)';
pos_conns     = setxor(all_conns,current_conns,'rows');

if ~isempty(pos_conns)    
    % Random order to try connections
    [~,newConnIndex] = sort(rand(1,size(pos_conns,1)));
    
    %% Add connection and test for cycles
    for i=1:length(newConnIndex)
        new_conn = [    nextInnov;...
                        pos_conns(newConnIndex(i),:)';...
                        ...
                        (rand-0.5)*p.weightCap*2;...
                        1];
        connG = [connG new_conn];
        
        if    is_Cyclic(connG, nodeG);  connG(:,end) = []; % Remove and try again
        else;                           break;             % Got one
        end
    end
    
    %% Record Innovation if it is truly new
    new_conns_this_gen = innovation(:,find(innovation(5,:)==gen));
    [already_added,~,IB] = intersect(new_conn([2 3])',new_conns_this_gen([2 3],:)','rows');
    
    if isempty(already_added) % Add to record if truly new
        new_innovation =    [new_conn([1:3]);0;gen];
        innovation = [innovation, new_innovation];
    else % Reassign
        connG(1,end) = new_conns_this_gen(1,IB);
    end
    
end




