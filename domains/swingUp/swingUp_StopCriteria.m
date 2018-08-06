function [shouldYouStop] = swingUp_StopCriteria(best,p,d)
%shouldYouStop = false;
shouldYouStop = best.fitness > 100;
%[~,~,~, shouldYouStop] = swingUp_test(best.wMat,best.aMat,p,d);
