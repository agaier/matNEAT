function [ fitness, simData, force, solved ] = swingUp_test( wMat, aMat, p, d, varargin)
%function [ fitness, simData, force, solved ] = swingUp_test( wMat, aMat, p, d, varargin)
%swingUp_test
%   state = [ x           <- the cart position
%             theta       <- the angle of the pole
%             x_dot       <- the cart velocity
%             theta_dot   <- the angular velocity of the pole.            
%
%

% Set system parameters
maxForce = 10;         % Maximum actuator forces

duration = 5;          % Time for testing
timestep = 0.025;      % Time constant

trackLength = 3;
scaling  = [1 1 1 1]';  % For ANN activation input
bias     = 1;

inputScaling = @(x) [x(1); cos(x(2)); x(3); x(4)] .* scaling;

systemParams.m1 = 2.0;  % (kg) Cart mass
systemParams.m2 = 0.5;  % (kg) Pole mass
systemParams.g  = 9.81; % (m/s^2) gravity
systemParams.l  = 0.5;  % (m) pendulum (pole) length

% Initialize Simulation
simSteps = duration/timestep; 
force(1,simSteps) = nan;
state = zeros(4,simSteps); state(2) = 0;
%state = state + randn(1,4)*0.1;
force(1) = 0;

state_d = cartPoleDynamics(state(:,1),force(1),systemParams);
state(:,1)   = state(:,1) + state_d * timestep;


%% Run Simulation
for i=2:simSteps
    % Compute activation
    input(:,i)   = [bias; inputScaling(state(:,i-1))];
    output  = FFNet(wMat,aMat,input(:,i),d);
    force(i)= output.*maxForce;
    
    % Compute state transition
    state_d = cartPoleDynamics(state(:,i-1),force(i),systemParams);
    state(:,i)   = state(:,i-1) + state_d * timestep;
    
    % Cancel if off the track
    if abs(state(1,i)) > trackLength;break;end    
end

% Award Fitness
%    We reward the controller whenever the pole is upright. To further
%    reward controllers which maintain balance, these positive rewards are
%    cumulative, with the controller recieving a larger reward the longer
%    the pole is balanced at a stretch.

up =-cos(state(2,101:end)) > -cos(pi-.25); % Time steps when the pole is upright

% Solved if balanced for final 100 timesteps
solved = all(up);
aUPa        = [0,up,0];             % Make padded matrix
onesStart   = strfind(aUPa, [0 1]); % Find where ones start
onesEnd     = strfind(aUPa, [1 0]); % Find where ones end
onesLength  = onesEnd - onesStart;  % Length of each sequence of ones
fitness = 1+sum( onesLength.^1);      % Reward length geometrically
%fitness = sum( onesLength.^2);      % Reward length geometrically

% Save Simulation Result
simData.t = 1:simSteps;
simData.state = state;
simData.systemParams = systemParams;





