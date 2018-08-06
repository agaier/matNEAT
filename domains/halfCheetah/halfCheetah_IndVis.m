function fitness = halfCheetah_IndVis(ind,~,d)
%swingUp_indVis - Visualize individual performance in swing-up domain
%
% Syntax:  swingUp_indVis(ind,p,d)
%
% Author: Adam Gaier
% Bonn-Rhein-Sieg University of Applied Sciences (BRSU)
% email: adam.gaier@h-brs.de
% Dec 2017; Last revision: 05-Dec-2017

%------------- Input Parsing ------------

%------------- BEGIN CODE --------------

base = 'http://127.0.0.1:5000';
client = gym_http_client(base);

d.render = true;
env_id = 'HalfCheetah-v1';
instance_id = client.env_create(env_id);
fitness = halfCheetah_test(ind.wMat,ind.aMat,client,d,instance_id);
client.env_monitor_close(instance_id);


%% Elite Network
subplot(3,2,6);
G = digraph(ind.wMat);
h = plot(G,'Layout','layered','Direction','right','Sources',1:d.inputs+1);
h.NodeLabel(1:5) = {'Bias', 'X', 'Theta', 'dX', 'dTheta'};
h.NodeLabel(end) = {'Force'};
yticks('');xticks('');
title('ANN');

%------------- END OF CODE --------------