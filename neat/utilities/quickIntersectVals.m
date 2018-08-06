function vals = quickIntersectVals(A,B)
%% Custom fast intersect for positive integers which (returns only values)
% Inspired by: http://www.mathworks.com/matlabcentral/answers/53796-speed-up-intersect-setdiff-functions
%
% Syntax:  [IA, IB] = quickIntersectVals(A,B)
%
% Inputs:
%    A     - [1×N]    - vector of integers
%    B     - [1×N]    - vector of integers
%
% Outputs:
%    vals  - [1×M]    - values which appear in both A and B
%
% See also: quickIntersectIndex, quickIntersectVals, quickSetDiff

% Author: Adam Gaier
% Bonn-Rhein-Sieg University of Applied Sciences (BRSU)
% email: adam.gaier@h-brs.de
% Feb 2018; Last revision: 06-Mar-2018

%------------- BEGIN CODE --------------
P = zeros(1, max(max(A),max(B)) ) ;
P(A) = 1;
vals = B(logical(P(B)));
%------------- END OF CODE --------------
