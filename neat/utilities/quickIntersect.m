function [IA, IB, vals] = quickIntersect(A,B)
%% quickIntersect - Custom fast intersect for positive integers (index and values)
% Inspired by: http://www.mathworks.com/matlabcentral/answers/53796-speed-up-intersect-setdiff-functions
%
% Syntax:  [IA, IB] = quickIntersect(A,B)
%
% Inputs:
%    A     - [1×N]    - vector of integers
%    B     - [1×N]    - vector of integers
%
% Outputs:
%    IA    - [1×M]    - indices of intersecting values in A
%    IB    - [1×M]    - indices of intersecting values in B
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
IB = logical(P(B));
P(A) = 0; % back to zeros without creating new matrix
P(B) = 1;
IA = logical(P(A));
vals = B(IB);
%------------- END OF CODE --------------
