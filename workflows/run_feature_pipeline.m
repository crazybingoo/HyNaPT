function results = run_feature_pipeline(signal, cfg)
%RUN_FEATURE_PIPELINE Build temporal hypergraphs and node similarities.
% This public workflow intentionally stops before the manuscript transition
% model because the historical upload does not include all transition-rule
% functions or the external COC implementation required by that stage.

if nargin < 2
    cfg = struct;
end
cfg = apply_defaults(cfg, struct('sampleRate', 1024, ...
    'windowSeconds', 3, 'stepSeconds', 1, 'zonePrior', []));
validateattributes(signal, {'double'}, {'2d', 'nonempty', 'finite'});

if cfg.sampleRate ~= 1024
    error('HyNaPT:UnsupportedSampleRate', ...
        ['The current feature implementations reproduce the historical ' ...
         '1024-Hz analysis only. Resample the signal or use 1024 Hz.']);
end

numChannels = size(signal, 1);
if isempty(cfg.zonePrior)
    cfg.zonePrior = zeros(numChannels, 1);
else
    cfg.zonePrior = cfg.zonePrior(:);
end
if numel(cfg.zonePrior) ~= numChannels
    error('HyNaPT:InvalidZonePrior', ...
        'zonePrior must contain one value per channel.');
end

windowSamples = round(cfg.sampleRate * cfg.windowSeconds);
stepSamples = round(cfg.sampleRate * cfg.stepSeconds);
numWindows = floor((size(signal, 2) - windowSamples) / stepSamples) + 1;
if numWindows < 1
    error('HyNaPT:SignalTooShort', ...
        'The signal is shorter than one analysis window.');
end

results.config = cfg;
results.hypergraphs = cell(numWindows, 1);
results.features = cell(numWindows, 1);
results.similarity = cell(numWindows, 1);

windowCfg = struct('sampleRate', cfg.sampleRate, ...
    'windowSeconds', cfg.windowSeconds, 'stepSeconds', cfg.stepSeconds);
featureCfg = struct('R_zone', cfg.zonePrior);

for windowIndex = 0:numWindows - 1
    segment = get_sliding_window(signal, windowIndex, windowCfg);
    hypergraph = build_hypergraph(segment);
    features = extract_node_features(segment, hypergraph, featureCfg);

    results.hypergraphs{windowIndex + 1} = hypergraph;
    results.features{windowIndex + 1} = features;
    results.similarity{windowIndex + 1} = compute_node_similarity(features);
end
end

function output = apply_defaults(input, defaults)
output = input;
names = fieldnames(defaults);
for index = 1:numel(names)
    name = names{index};
    if ~isfield(output, name) || isempty(output.(name))
        output.(name) = defaults.(name);
    end
end
end
