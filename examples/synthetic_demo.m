function results = synthetic_demo
%SYNTHETIC_DEMO Run a deterministic, non-clinical HyNaPT smoke example.

repoRoot = fileparts(fileparts(mfilename('fullpath')));
addpath(repoRoot);
startup;
rng(42, 'twister');

sampleRate = 1024;
durationSeconds = 5;
time = (0:(sampleRate * durationSeconds - 1)) / sampleRate;
numChannels = 6;
signal = zeros(numChannels, numel(time));

sharedTheta = sin(2 * pi * 6 * time);
sharedHfo = 0.25 * sin(2 * pi * 45 * time);
for channel = 1:numChannels
    phase = (channel - 1) * pi / 12;
    signal(channel, :) = sin(2 * pi * 10 * time + phase) + ...
        0.35 * sharedTheta + (0.05 * channel) * sharedHfo + ...
        0.08 * randn(size(time));
end

cfg = struct('sampleRate', sampleRate, 'windowSeconds', 3, ...
    'stepSeconds', 1, 'zonePrior', zeros(numChannels, 1));
results = run_feature_pipeline(signal, cfg);

fprintf('Synthetic demo completed: %d channels, %d windows.\n', ...
    numChannels, numel(results.hypergraphs));
fprintf('First window: %d hyperedges; similarity size %d x %d.\n', ...
    numel(results.hypergraphs{1}.edges), size(results.similarity{1}, 1), ...
    size(results.similarity{1}, 2));
end
