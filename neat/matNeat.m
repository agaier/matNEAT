function output = matNeat(p,d)
%matNeat - Neuroevolution of Augumenting Topologies main script
% Syntax:  [output] = matNeat(p,d) % Run algorithm
%          p = matNeat()           % Get default hyperparameters
%
% Inputs:
%   p  - struct - Hyperparameters for algorithm, visualization, and data gathering
%   d  - struct - Domain definition
%   * call with no arguments to return default hyperparameter (p) struct
%
% Outputs:
%    output - output struct with fields:
%     p         - [1×1 struct] - used hyperparameters
%     d         - [1×1 struct] - used domain parameters
%     elite     - [1×N struct] - elite individuals at every gen
%     best      - [1×N struct] - best individuals at every gen
%     bestFit   - [1×N struct] - fitness of best ever at every gen
%     eliteFit  - [1×N struct] - fitness of elite ever at every gen
%     fitness   - [N×M double] - fitness of pop at every gen
%     nodes     - [N×M double] - number of nodes of pop at every gen 
%     conns     - [N×M double] - number of connections pop at every gen
%

% Author: Adam Gaier
% Bonn-Rhein-Sieg University of Applied Sciences (BRSU)
% email: adam.gaier@h-brs.de
%
% Based on: "Evolving neural networks through augmenting topologies" by 
% Kenneth Stanley and Risto Miikkulainen in Evolutionary computation (2002)
%
% Oct 2015; Last revision: 25-Oct-2017

%------- Return default parameters  -----
if nargin==0; output = defaultParamSet; return; end

%------- Load parameters from disk  -----
if nargin==1; load(p,'p','d');end
rec.p = p; rec.d = d;

%------------- BEGIN CODE ---------------

%% Initialize
d = feval(d.init,p,d); % Initalize Environment (needed for OpenAI gym only)
[pop,innovation,p]= initializePop(p,d);
[fitness, pop] = feval(d.fitFun, express(pop), p, d);

% Keep track of elite and best ever found individual
[~,eliteIndx] = max(fitness); rec.elite = pop(eliteIndx); rec.best = rec.elite;

%% Evolution Loop
gen = 1; species = [];
rec = gatherData(pop,fitness,species,rec,gen);

while (gen < p.maxGen)
    gen = gen+1; loopStart = tic;
    
    %% Evolve one generation of NEAT
    [pop, species, innovation, p] = evolveNeatGen(pop, species, innovation, gen, p, d);
    [fitness, pop]                = feval(d.fitFun, express(pop), p, d);
        
    %% Data Gathering
    rec = gatherData(pop,fitness,species,rec,gen);
    
    %% Visualization
    if ~mod(gen,p.displayMod); visNeat(rec,gen);  end
    
    disp(['--------------------' newline 'Gen ' int2str(gen)         ...
          ' in ' seconds2human(toc(loopStart))             newline   ...
          'Elite fitness: '     num2str(rec.eliteFit(end))  ' -- '   ...
          'Best ever fitness: ' num2str(rec.bestFit (end)) newline]);

    %% Stopping Condition
    if feval(d.stop,rec.best(end),p,d)
        disp(['*** SOLUTION FOUND ***  Evaluations used: '...
            int2str(gen*p.popSize+p.nInitialSamples)]); break; 
    end   
    
end
output = rec;

%------------- END OF CODE --------------








