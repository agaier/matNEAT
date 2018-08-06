function [fitness, pop] = xor_FitnessFunc(pop,p,d)
%xor_FitnessFunc - Evaluates fitness of population on XOR test problem
%
% Syntax:  pop = xor_FitnessFunc(pop,d);
%
% Inputs:
%    pop - population struct with empty 'fitness' field
%    d   - domain hyperparameter script
%
% Outputs:
%    fitness - fitness of each individual
%    pop     - population struct with filled 'fitness' field
%
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: OTHER_FUNCTION_NAME1,  OTHER_FUNCTION_NAME2

% Author: Adam Gaier
% Bonn-Rhein-Sieg University of Applied Sciences (BRSU)
% email: adam.gaier@h-brs.de
% Aug 2015; Last revision: 25-Sep-2017

%------------- BEGIN CODE --------------

% Input Patter with bias
input = [0 0; 0 1; 1 0; 1 1;];
input = [ones(size(input,1),1), input];

% ANN Output pattern
for iInd = 1:length(pop)
    ind = pop(iInd);
    for iInput=1:size(input,1)
        output(iInput) = FFNet(ind.wMat,ind.aMat,input(iInput,:),d);
    end
    target = [1 0 0 1];
    
    fitness(iInd) = sum(abs( output - target ),2).^2;
    pop(iInd).fitness = fitness(iInd);
end


