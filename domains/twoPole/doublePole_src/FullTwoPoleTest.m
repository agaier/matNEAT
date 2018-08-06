%% Double Pole Balancing Stopping Criteria
champ = elite(end);
if champ.steps > 999 && champ.fitness > p.oldFit + 1E-2
    %% Full stability tests and generalization performance
    if ~headless; display (['Pole balanced for 1000 timesteps, testing if truly stable.']);end
    %twoPole_test(champ,p,'vis'); % Visualize performance

    % Truly Stable?
    [champSteps, champSteps] = twoPole_test(champ,p,'full');
    stable = false;
    if champSteps < p.maxFitness;
        if ~headless; display (['Lost balance after ' int2str(champSteps) ' timesteps.']);end
    else
        stable = true;
        if ~headless; display (['Kept balance for ' int2str(champSteps) ' timesteps.']);end
    end
    % Generalization?
    if stable
        if ~headless; display (['Checking generalization performance...']);end
        success = generalizationTest(champ,p);
        if  success >= p.generalization
            if ~headless; display (['Solution found! Generalized over ' int2str(success) ' solutions!']);end
            
            if p.velInfo == false
                if ~headless; display (['Solution found in ' int2str(p.popSize*gen) ' evaluations. (Published NEAT avg: 33,184 | stdDev: 21,790)']);end;
            else
                if ~headless; display (['Solution found in ' int2str(p.popSize*gen) ' evaluations. (Published NEAT avg: 3,600 | stdDev: 2,704)']);end
            end
            solveGen = gen;
            break;
        else
            if ~headless; display (['Solution could only generalize over ' int2str(success) ' solutions.']);end
            if ~headless; display ('Continuing evolution...');end
        end
    end
    p.oldFit = champ.fitness;
end