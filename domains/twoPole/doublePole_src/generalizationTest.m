%% Generalization Test
%
% Tests from how many initial states a network can maintain balance for
% 1000 timesteps.
%
%   Taken from ESP 2 pole testing: http://nn.cs.utexas.edu/?esp

function success = generalizationTest(ind,p)

    testMax = p.targetFitness;
    
    %% Create test set of initial states
    interval = [0.05 0.25 0.5 0.75 0.95]';
    
    state1 = (interval*4.32)-2.16;
    state2 = (interval*2.70)-1.35;
    state3 = (interval*0.12566304) - 0.06283152;
    state4 = (interval*0.30019504) - 0.15009752;
    state5 = (interval*0);
    state6 = (interval*0);
    
    totalStates = length(interval).^4;
    allStates = zeros(totalStates,6);
    numInt = length(interval);
    
    % TODO: replace this with like 1 line of real MATLAB code...  
    stateCount = 1;
    for s1=1:numInt
        for s2=1:numInt
            for s3=1:numInt
                for s4=1:numInt
                    allStates(stateCount,:) = [...
                        state1(s1) state2(s2) state3(s3) state4(s4) ...
                        0 0 ];
                    stateCount = stateCount+1;
                end
            end
        end
    end
        
    %% Test individual on all tests
    success = false(1,totalStates);
    parfor i=1:totalStates
       [fitness, steps] = twoPole_test(ind, p, 'setInit', allStates(i,:)');
       if steps >= testMax
          success(i) = true; 
       end
    end
    
    success = sum(success);
end