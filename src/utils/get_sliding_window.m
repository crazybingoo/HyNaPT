function window = get_sliding_window(signal, windowIndex, cfg)
%GET_SLIDING_WINDOW Extract one zero-based sliding window from a signal.

if nargin < 3
    cfg = struct;
end
cfg = apply_defaults(cfg, struct('sampleRate', 1024, ...
    'windowSeconds', 3, 'stepSeconds', 1));
validateattributes(signal, {'double'}, {'2d', 'nonempty'});
validateattributes(windowIndex, {'numeric'}, ...
    {'scalar', 'integer', 'nonnegative'});

windowSamples = round(cfg.sampleRate * cfg.windowSeconds);
stepSamples = round(cfg.sampleRate * cfg.stepSeconds);
firstSample = windowIndex * stepSamples + 1;
lastSample = firstSample + windowSamples - 1;

if lastSample > size(signal, 2)
    error('HyNaPT:WindowOutOfRange', ...
        'Window %d ends at sample %d, but the signal has %d samples.', ...
        windowIndex, lastSample, size(signal, 2));
end

window = signal(:, firstSample:lastSample);
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
