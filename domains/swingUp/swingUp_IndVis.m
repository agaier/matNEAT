function swingUp_IndVis(ind,p,d)
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

%% Elite Trajectory
subplot(3,2,2);
%subplot(3,1,1);
[~,simData, force] = swingUp_test(ind.wMat,ind.aMat,p,d);
[p1,p2] = cartPoleKinematics(simData.state,simData.systemParams);
nFrame = 25;  %Number of frames to draw
drawCartPoleTraj(simData.t,p1,p2,nFrame);

title('Trajectory','FontSize',14)

%% Elite Behavior
subplot(3,2,4);
%subplot(3,1,2);
height      = -2+(1-(cos(simData.state(2,:))) ).^2;  
h = plot([simData.state; force./100; height]');
h(4).LineWidth = 3; h(6).LineWidth = 3;
legend('X','Theta','dX','dTheta','Force','Height','Location','SouthOutside','Orientation','Horizontal')
set(gca,'YLim',[-5 5]); yticks([-5 -1 0 1 5]); grid on;
title('State Variables','FontSize',14)

%% Elite Network
subplot(3,2,6);
%subplot(3,1,3);
G = digraph(ind.wMat);
h = plot(G,'Layout','layered','Direction','right','Sources',1:d.inputs+1);
h.NodeLabel(1:5) = {'Bias', 'X', 'Theta', 'dX', 'dTheta'};
h.NodeLabel(end) = {'Force'};
yticks('');xticks('');
title('ANN');

%------------- END OF CODE --------------