function xor_IndVis(ind,p,d)
%swingUp_indVis - Visualize individual performance in swing-up domain
%
%
% Syntax:  dswingUp_indVis(ind)
%
% Author: Adam Gaier
% Bonn-Rhein-Sieg University of Applied Sciences (BRSU)
% email: adam.gaier@h-brs.de
% Dec 2017; Last revision: 05-Dec-2017

%------------- Input Parsing ------------

%------------- BEGIN CODE --------------

%% Elite Trajectory

%% Elite Network
subplot(3,2,6);
G = digraph(ind.wMat);
h = plot(G,'Layout','layered','Direction','right','Sources',1:d.inputs+1);
h.NodeLabel(1:d.inputs+1) = {'Bias', 'X1', 'X2'};
h.NodeLabel(end) = {'Classification'};
yticks('');xticks('');
title('ANN');

%------------- END OF CODE --------------