function results = run_feature_pipeline(signal, cfg)
%RUN_FEATURE_PIPELINE Run the public, path-independent HyNaPT workflow.
%   A single PLV threshold is selected from the elbow of the mean
%   density-threshold curve across windows. Exact retained-pair fractions
%   are not used by this primary workflow; they belong to sensitivity tests.

if nargin < 2
    cfg = struct;
end
cfg = apply_defaults(cfg, struct('sampleRate', 1024, ...
    'windowSeconds', 3, 'stepSeconds', 1, 'alpha', 0.5, ...
    'thresholdGrid', 0:0.0025:1));
validateattributes(signal, {'double'}, {'2d', 'nonempty', 'finite'});
validateattributes(cfg.alpha, {'double'}, {'scalar', '>=', 0, '<=', 1});

if cfg.sampleRate ~= 1024
    error('HyNaPT:UnsupportedSampleRate', ...
        ['The current feature implementations reproduce the reference ' ...
         '1024-Hz analysis only. Resample the signal or use 1024 Hz.']);
end

windowSamples = round(cfg.sampleRate * cfg.windowSeconds);
stepSamples = round(cfg.sampleRate * cfg.stepSeconds);
numWindows = floor((size(signal, 2) - windowSamples) / stepSamples) + 1;
if numWindows < 1
    error('HyNaPT:SignalTooShort', ...
        'The signal is shorter than one analysis window.');
end

numChannels = size(signal, 1);
segments = cell(numWindows, 1);
plvStack = zeros(numChannels, numChannels, numWindows);
windowCfg = struct('sampleRate', cfg.sampleRate, ...
    'windowSeconds', cfg.windowSeconds, 'stepSeconds', cfg.stepSeconds);
for windowIndex = 0:numWindows - 1
    segments{windowIndex + 1} = get_sliding_window(signal, windowIndex, windowCfg);
    plvStack(:, :, windowIndex + 1) = get_plvMatrix(segments{windowIndex + 1});
end
[selectedThreshold, densityCurve] = ...
    select_density_elbow_threshold(plvStack, cfg.thresholdGrid);

results.config = cfg;
results.selectedThreshold = selectedThreshold;
results.densityCurve = densityCurve;
results.hypergraphs = cell(numWindows, 1);
results.features = cell(numWindows, 1);
results.similarity = cell(numWindows, 1);
results.transition = cell(numWindows, 1);
results.dynamicTransition = cell(max(numWindows - 1, 0), 1);

for windowIndex = 1:numWindows
    options = struct('PLVMatrix', plvStack(:, :, windowIndex), ...
        'Threshold', selectedThreshold, 'ThresholdGrid', cfg.thresholdGrid);
    hypergraph = build_hypergraph(segments{windowIndex}, options);
    features = extract_node_features(segments{windowIndex}, hypergraph);
    similarity = compute_node_similarity(features);
    transition = assemble_transition_matrix(segments{windowIndex}, ...
        hypergraph, similarity);

    results.hypergraphs{windowIndex} = hypergraph;
    results.features{windowIndex} = features;
    results.similarity{windowIndex} = similarity;
    results.transition{windowIndex} = transition;
end

for windowIndex = 1:numWindows - 1
    results.dynamicTransition{windowIndex} = fuse_transition_matrices( ...
        results.transition{windowIndex}, results.transition{windowIndex + 1}, ...
        cfg.alpha);
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
