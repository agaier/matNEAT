%% twoPole Stopping Criteria
function [shouldYouStop] = twoPole_StopCriteria(elite,~,~)
shouldYouStop = (elite(1).fitness == 1000);
