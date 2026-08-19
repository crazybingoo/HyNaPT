function hyper = construct_hypergraph(signal, options)
%CONSTRUCT_HYPERGRAPH Build PLV pairs and COC-weighted closed triplets.

if nargin < 2 || isempty(options)
    options = struct;
end
options = apply_defaults(options, struct( ...
    'PLVMatrix', [], 'Threshold', [], 'ThresholdGrid', 0:0.0025:1));
validateattributes(signal, {'double'}, {'2d', 'nonempty', 'finite'});
n = size(signal, 1);
if isempty(options.PLVMatrix)
    plv = get_plvMatrix(signal);
else
    plv = options.PLVMatrix;
end
validateattributes(plv, {'double'}, {'size', [n, n], 'finite'});
plv = max((plv + plv') ./ 2, 0);
plv(1:n+1:end) = 0;

if isempty(options.Threshold)
    [threshold, densityCurve] = ...
        select_density_elbow_threshold(plv, options.ThresholdGrid);
else
    threshold = options.Threshold;
    [~, densityCurve] = select_density_elbow_threshold(plv, options.ThresholdGrid);
end

adjacency = plv >= threshold;
adjacency(1:n+1:end) = false;
adjacency = adjacency | adjacency';
[row, column] = find(triu(adjacency, 1));
pairEdges = arrayfun(@(index) [row(index), column(index)], ...
    (1:numel(row))', 'UniformOutput', false);
pairWeights = arrayfun(@(index) plv(row(index), column(index)), ...
    (1:numel(row))');

triplets = zeros(0, 3);
for first = 1:n-2
    for second = first+1:n-1
        if ~adjacency(first, second)
            continue;
        end
        for third = second+1:n
            if adjacency(first, third) && adjacency(second, third)
                triplets(end+1, :) = [first, second, third]; %#ok<AGROW>
            end
        end
    end
end

phase = angle(hilbert(signal')');
tripletWeights = zeros(size(triplets, 1), 1);
for index = 1:size(triplets, 1)
    tripletWeights(index) = phase_coc(phase(triplets(index, :), :)');
end
if isempty(triplets)
    tripletEdges = cell(0, 1);
else
    tripletEdges = mat2cell(triplets, ones(size(triplets, 1), 1), 3);
end

hyper = struct;
hyper.edges = [pairEdges; tripletEdges];
hyper.edgeWeights = [pairWeights; tripletWeights];
hyper.dc = n;
hyper.degree = d_u(hyper.edges, n)';
hyper.pairwisePLV = plv;
hyper.pairAdjacency = adjacency;
hyper.threshold = threshold;
hyper.densityCurve = densityCurve;
hyper.edgeOrder = [2 .* ones(numel(pairEdges), 1); ...
    3 .* ones(numel(tripletEdges), 1)];
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
