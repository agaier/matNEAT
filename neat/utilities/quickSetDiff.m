function Z = quickSetDiff(A,B)
%% Custom fast setdiff for positive integers which (returns only values)
% Inspired by: http://www.mathworks.com/matlabcentral/answers/53796-speed-up-intersect-setdiff-functions
%
% Syntax:  [IA, IB] = quickIntersectVals(A,B)
%
% Inputs:
%    A     - [1×N]    - vector of integers
%    B     - [1×N]    - vector of integers
%
% Outputs:
%    Z     - [1×M]    - set difference between A and B
%
% See also: quickIntersectIndex, quickIntersectVals, quickSetDiff

% Author: Adam Gaier
% Bonn-Rhein-Sieg University of Applied Sciences (BRSU)
% email: adam.gaier@h-brs.de
% Feb 2018; Last revision: 06-Mar-2018

%------------- BEGIN CODE --------------
check = false(1, max(max(A), max(B)));
check(A) = true;
check(B) = false;
Z = A(check(A));
%------------- END OF CODE --------------


