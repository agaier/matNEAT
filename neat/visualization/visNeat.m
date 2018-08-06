%% Vis Neat
function visNeat(rec,gen)
clf;
if ~exist('m','var');m.useSA = false;end

% Unpack struct
names = fieldnames(rec); 
for i=1:length(names); eval( [names{i},'= rec.', names{i}, ';'] ); end

%% Fitness
subplot(3,2,1);
plotMedMax(fitness);
title('Fitness Progress','FontSize',14);
ylabel('Fitness'); xlabel('Generations'); 

%% Nodes and Connections
subplot(6,2,5);
plotMedMax(nodes);
title('Topology Development','FontSize',14)
ylabel('Nodes'); xticks('')

subplot(6,2,7);
plotMedMax(conns);
xlabel('Generations'); ylabel('Conns');

%% Species Distribution
subplot(3,2,5);
for iSpec=1:length(species);offspring(iSpec) = species{iSpec}.offspring;end
h = pie(offspring);
title('Species Distribution','FontSize',14);

%% View Elite
if nargin == 2; best = elite(gen); end  % Current best
feval(d.indVis, best(end),p,d);
%%
drawnow;


    
    
    
    
    
    
    