function [IA, IB] = quickIntersectIndex(A,B)
%% quickIntersectIndex - Custom fast intersect for positive integers (returns only indices)
% Inspired by: http://www.mathworks.com/matlabcentral/answers/53796-speed-up-intersect-setdiff-functions
%
% Syntax:  [IA, IB] = quickIntersectIndex(A,B)
%
% Inputs:
%    A     - [1×N]    - vector of integers
%    B     - [1×N]    - vector of integers
%
% Outputs:
%    IA    - [1×M]    - indices of intersecting values in A
%    IB    - [1×M]    - indices of intersecting values in B
%
% See also: quickIntersect, quickIntersectVals, quickSetDiff

% Author: Adam Gaier
% Bonn-Rhein-Sieg University of Applied Sciences (BRSU)
% email: adam.gaier@h-brs.de
% Feb 2018; Last revision: 06-Mar-2018

%------------- BEGIN CODE --------------
P = false(1, max(max(A),max(B)) ) ;
P(A) = true;
IB = P(B);

P(A) = false; % back to zeros without creating new matrix
P(B) = true;
IA = P(A);
%------------- END OF CODE --------------