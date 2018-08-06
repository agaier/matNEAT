function d = halfCheetah_Domain
%halfCheetah_Domain - Courtesy OpenAI Gym
%
% 17 inputs:
%     State-Space (name/joint/parameter):
%         - rootx     slider      position (m)
%         - rootz     slider      position (m)
%         - rooty     hinge       angle (rad)
%         - bthigh    hinge       angle (rad)
%         - bshin     hinge       angle (rad)
%         - bfoot     hinge       angle (rad)
%         - fthigh    hinge       angle (rad)
%         - fshin     hinge       angle (rad)
%         - ffoot     hinge       angle (rad)
%         - rootx     slider      velocity (m/s)
%         - rootz     slider      velocity (m/s)
%         - rooty     hinge       angular velocity (rad/s)
%         - bthigh    hinge       angular velocity (rad/s)
%         - bshin     hinge       angular velocity (rad/s)
%         - bfoot     hinge       angular velocity (rad/s)
%         - fthigh    hinge       angular velocity (rad/s)
%         - fshin     hinge       angular velocity (rad/s)
%         - ffoot     hinge       angular velocity (rad/s)
%
% 6 outputs:
%     Actuators (name/actuator/parameter):
%         - bthigh    hinge       torque (N m)
%         - bshin     hinge       torque (N m)
%         - bfoot     hinge       torque (N m)
%         - fthigh    hinge       torque (N m)
%         - fshin     hinge       torque (N m)
%         - ffoot     hinge       torque (N m)
%
% Fitness Reward:
%         reward_ctrl = - 0.1 * np.square(action).sum()
%         reward_run = (xposafter - xposbefore)/self.dt
%         reward = reward_ctrl + reward_run

% Author: Adam Gaier
% Bonn-Rhein-Sieg University of Applied Sciences (BRSU)
% email: adam.gaier@h-brs.de
% Dec 2017; Last revision: 17-Dec-2017

%------------- BEGIN CODE --------------

d.name = 'halfCheetah';
rmpath( genpath('domains')); addpath(genpath(['domains/' d.name '/']));

% Functions
d.peFitFun = 'halfCheetah_FitnessFunc' ;
d.stop     = 'halfCheetah_StopCriteria';
d.indVis   = 'halfCheetah_IndVis';
d.init     = 'halfCheetah_Initialize';

% Initial Network Topology
d.inputs  = 18; % [see above]
d.outputs = 6;  % [see above]
d.activations = [1 1*ones(1,d.inputs) 5*ones(1,d.outputs)]; % Bias, Linear inputs, Signed Sigmoid Input
d.actRange = 5; % signed sigmoidal hidden nodes

% Fitness parameters
d.max_steps = 150;
d.render = false;




%------------- END OF CODE --------------