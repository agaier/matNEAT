function d = halfCheetah_Initialize(p,d)

fprintf('Starting Matlab clients\n');
%% Setup clients
base = 'http://127.0.0.1:5000';
client = gym_http_client(base);
env_id = 'HalfCheetah-v1';
outdir = pwd;
for i=1:(1+p.popSize*2)
    a = client.env_create(env_id);
    instanceId{i} = a;
    client.env_monitor_start(instanceId{i}, outdir, true);
end

d.client = client;
d.instanceId = instanceId;
