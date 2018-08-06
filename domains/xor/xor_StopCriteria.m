%% XOR Stopping Criteria
function [shouldYouStop] = xor_StopCriteria(best,~,d)

shouldYouStop = best.fitness == d.targetFitness;

