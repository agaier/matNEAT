function [fitness, pop] = swingUp_FitnessFunc(pop,p,d)
%swingUp_FitnessFunc - Evaluates fitness of population on Swingup problem
%
% Syntax:  pop = xor_FitnessFunc(pop,d);
%
% Inputs:
%    pop - population struct with empty 'fitness' field
%    d   - domain hyperparameter script
%
% Outputs:
%    fitness - fitness of each individual
%    pop - population struct with filled 'fitness' field
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

% ANN Output pattern
parfor iInd = 1:length(pop)
    ind = pop(iInd);
    fitness(iInd) = swingUp_test(ind.wMat,ind.aMat,p,d);    
    pop(iInd).fitness = fitness(iInd);
end


