function [shouldYouStop] = halfCheetah_StopCriteria(best,p,d)
%% TODO
shouldYouStop = (best.fitness == d.max_steps);

