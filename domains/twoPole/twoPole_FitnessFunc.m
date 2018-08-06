function [fitness, pop] = twoPole_FitnessFunc(pop,p,d)
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
%    pop - population struct with filled 'fitness' field
%
% Other m-files required: twoPole_test
% See also: twoPole_test, twoPole_Domain, twoPole_StopCriteria

% Author: Adam Gaier
% Bonn-Rhein-Sieg University of Applied Sciences (BRSU)
% email: adam.gaier@h-brs.de
% Aug 2015; Last revision: 25-Sep-2017

%------------- BEGIN CODE --------------

parfor iInd = 1:length(pop)
    ind = pop(iInd);
    fitness(iInd) = twoPole_test(ind.wMat,ind.aMat,p,d);    
    pop(iInd).fitness = fitness(iInd);
end

%------------- END OF CODE --------------

