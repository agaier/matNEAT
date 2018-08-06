function state = cart_pole2( state, action )
% state = cart_pole( state, action )
% 
%     Takes as input a state and action and returns the next state
%   TAU seconds later. The state is defined to be a column vector
%   according to:
%
%   state = [ x           <- the cart position
%             x_dot       <- the cart velocity
%             theta       <- the angle of the pole
%             theta_dot   <- the angular velocity of the pole.
%             theta2      <- the angle of the 2nd pole
%             thet2a_dot  <- the angular velocity of the 2nd pole.

%   The action is force applied to the cart and can be positive or
%   negative. All units are standard SI: meters, meter/second,
%   radians, radians/second, and Newtons. Environment parameters,
%   such as gravity and friction, can be changed within the script
%   defining this function (cart_pole.m).
% 
%   Notes:
%    - A minor design consideration is whether to update velocity
%      changes or position changes first. In this implementation,
%      position (including angle) is updated before velocity.
%
%
% Originally written by Zhenzhen Liu
% Modified by Scott Livingston, October 2007
%
% Machine Intelligence Lab, EECS - Univ. of Tennessee
%
% Released under the GNU General Public License, version 3, see
% GPLv3.txt or README for details.
%
%**************************************************************************
% Additional Pole added by Adam Gaier
%
%

% state components (continuous-valued)
x         = state(1); % current position (units in m)
x_dot     = state(2); % current velocity (in m/s)
theta     = state(3); % current angle of the pole (in radians)
theta_dot = state(4); % current rate of change in angle of the pole (in radians/s)
theta2    = state(5); % current angle of the pole (in radians)
theta_dot2= state(6); % current rate of change in angle of the pole (in radians/s)

% parameters for simulation

g          =  9.8; % gravity (units are m/s^2)
mass_cart  =  1.0; % mass of the cart (in kg)
mass_pole  =  0.1; % mass of the pole (in kg)
mass_pole2 =  0.01;  
length     =  0.5; % half of the length (in m) of the pole;
length2    =  0.05; % second pole 
tau        =  0.01; % time interval (in seconds) for updating the values
mu_c       =  5e-04;    % coefficient of friction between cart and track
mu_p       =  2e-06;    % coefficient of friction at pole-cart joint.
total_mass = mass_cart + mass_pole + mass_pole2;

% calculate the acceleration of theta, given the current state and action
theta_acc = (g*sin(theta) + cos(theta)*( (-action - mass_pole*length*theta_dot*theta_dot*...
    ( sin(theta) + mu_c*sign(x_dot)*cos(theta) ))/total_mass + mu_c*sign(x_dot)*g ) - ...
    mu_p*theta_dot/(mass_pole*length)) / (length*( 4/3 - mass_pole*cos(theta)*...
    (cos(theta)-mu_c*sign(x_dot) )/total_mass ));

theta_acc2 = (g*sin(theta2) + cos(theta2)*( (-action - mass_pole2*length2*theta_dot2*theta_dot2*...
    ( sin(theta2) + mu_c*sign(x_dot)*cos(theta2) ))/total_mass + mu_c*sign(x_dot)*g ) - ...
    mu_p*theta_dot2/(mass_pole2*length2)) / (length2*( 4/3 - mass_pole2*cos(theta2)*...
    (cos(theta2)-mu_c*sign(x_dot) )/total_mass ));

% calculate the magnitude of normal force of the track on the cart;
% this is needed to account for friction in equation for cart acceleration.
Nc = abs(total_mass*g - ...
    (mass_pole*length*( theta_acc*sin(theta) + theta_dot*theta_dot*cos(theta) ) + ...
    mass_pole2*length2*( theta_acc2*sin(theta2) + theta_dot2*theta_dot2*cos(theta2) )));

% now, calculate the acceleration of x
x_acc = (action + mass_pole*length*(theta_dot*theta_dot*sin(theta) - theta_acc*cos(theta)) ...
                + mass_pole2*length2*(theta_dot2*theta_dot2*sin(theta2) - theta_acc2*cos(theta2))...
                - mu_c*Nc*sign(x_dot))/total_mass;

% update the state variables, using Euler method
x         = x + tau*x_dot;
x_dot     = x_dot + tau*x_acc;
theta     = theta + tau*theta_dot;
theta_dot = theta_dot + tau*theta_acc;
theta2    = theta2 + tau*theta_dot2;
theta_dot2 = theta_dot2 + tau*theta_acc2;

% handle special case: pole is parallel with the horizontal axis
if theta > pi/2, theta = pi/2; theta_dot = 0; end;
if theta < -pi/2, theta = -pi/2; theta_dot = 0; end;
if theta2 > pi/2, theta2 = pi/2; theta_dot2 = 0; end;
if theta2 < -pi/2, theta2 = -pi/2; theta_dot2 = 0; end;

% return the new state
state = [ x; x_dot; theta; theta_dot; theta2; theta_dot2 ];
