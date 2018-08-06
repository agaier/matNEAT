function [value] = afunct(func, x )
%% afunct - Look up for activation functions encoded as ints
% Syntax:  [value] = afunct(func, x )
%
% Inputs:
%    func       - [int]     - activation function ID number
%    x          - [1×N]     - raw output activation 
%
% Outputs:
%    value      - [1×N]     - value of after activation function is applied
%
% See also: express, FFNet

% Author: Adam Gaier
% Bonn-Rhein-Sieg University of Applied Sciences (BRSU)
% email: adam.gaier@h-brs.de
% Feb 2018; Last revision: 06-Mar-2018

%------------- BEGIN CODE --------------

switch func
    case 1 % Linear
        value = x;
    case 2 % Unsigned Step Function
        value = (x>0.5);
    case 3 % Unsigned higher slope sigmoid
        value = (1./(1+exp(-4.9*x)));
    case 4 % Gausian with mean 0 and sigma 1
        value = (exp(-(x-0).^2/(2*1^2)));
    case 5 % Signed higher slope sigmoid
        value = (2./(1+exp(-4.9*x)))-1;
    otherwise
        disp('ERROR in afunct - you did not select a valid activation function. ... Please check the fctPool configuration parameter')
end
%------------- END OF CODE --------------