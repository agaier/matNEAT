function [totalReward, done] = halfCheetah_test(wMat, aMat, client, d, instanceId)
%% OpenAiEval
totalReward = 0;
done = false;
obs = client.env_reset(instanceId);
torqueVector = zeros(1,6);
maxForce = 0.5;
for j=1:150%d.max_steps
%while true
    %obs = [sin(j)/8 obs'];    
    obs = [1 obs'];    
    action = FFNet(wMat,aMat,[1 obs],d);
    torqueVector = tanh(torqueVector + maxForce.*action);
    t(j,:) = torqueVector;
    o(j,:) = obs;
    
    [obs, reward, done, info] = ...
        client.env_step(instanceId, torqueVector, d.render);
    totalReward = totalReward+reward;
    if done; break; end    
    %pause(0.025);
end
client.env_monitor_close(instanceId);
