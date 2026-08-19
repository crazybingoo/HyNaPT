function [P, diagnostics] = assemble_transition_matrix(signal, hyper, similarity, options)
%ASSEMBLE_TRANSITION_MATRIX Build the four-case HyNaPT transition matrix.
%   The implementation follows the manuscript definitions for hyper-direct,
%   hyper-adjacent, hyper-indirect, and hyper-disconnected ordered pairs.
%   Scores are assembled before source-row normalization. The resulting
%   direction is model-derived and must not be interpreted as causal.

if nargin < 4 || isempty(options)
    options = struct;
end
options = apply_defaults(options, struct( ...
    'MaxIndirectHops', 4, 'MaxIndirectPaths', 1000));
validateattributes(signal, {'double'}, {'2d', 'nonempty', 'finite'});
validateattributes(options.MaxIndirectHops, {'double'}, ...
    {'scalar', 'integer', 'positive'});
validateattributes(options.MaxIndirectPaths, {'double'}, ...
    {'scalar', 'integer', 'positive'});

n = hyper.dc;
validateattributes(similarity, {'double'}, {'size', [n, n], 'finite'});
if size(signal, 1) ~= n
    error('HyNaPT:ChannelCountMismatch', ...
        'signal rows must match the number of hypergraph nodes.');
end

if ~isfield(hyper, 'edgeWeights') || numel(hyper.edgeWeights) ~= numel(hyper.edges)
    error('HyNaPT:MissingEdgeWeights', ...
        'hyper.edgeWeights must contain one non-negative weight per hyperedge.');
end

edgeWeights = max(double(hyper.edgeWeights(:)), 0);
similarity = max(similarity, 0);
similarity(1:n+1:end) = 0;
if isfield(hyper, 'pairwisePLV')
    plv = max(double(hyper.pairwisePLV), 0);
else
    plv = get_plvMatrix(signal);
end

[connectionType, ~, ~, nodeToEdges] = ...
    find_node_pair_connections(hyper.edges, n);
edgeAdjacencyWeight = compute_hyperedge_adj_weight(hyper.edges, edgeWeights);
degree = double(hyper.degree(:));
maxDegree = max(degree);
if maxDegree <= eps
    sourceDecay = ones(n, 1);
else
    sourceDecay = max(0, 1 - degree ./ maxDegree);
end

scores = zeros(n);
oneHop = zeros(n);
caseCounts = zeros(1, 4);

for u = 1:n
    for v = 1:n
        if u == v
            continue;
        end
        relation = connectionType(u, v);
        caseCounts(relation) = caseCounts(relation) + 1;
        switch relation
            case 1
                shared = intersect(incident_edges(nodeToEdges, u), ...
                    incident_edges(nodeToEdges, v));
                support = sum(edgeWeights(shared));
                scores(u, v) = similarity(u, v) * support;
                oneHop(u, v) = scores(u, v);
            case 2
                support = adjacent_support(u, v, nodeToEdges, ...
                    hyper.edges, edgeAdjacencyWeight);
                scores(u, v) = sourceDecay(u) * similarity(u, v) * support;
                oneHop(u, v) = scores(u, v);
            case 4
                meanDegree = max(mean(degree), 1);
                scores(u, v) = similarity(u, v) * ...
                    (1 - exp(-plv(u, v))) / meanDegree;
        end
    end
end

indirectMask = connectionType == 3;
for u = 1:n
    targets = find(indirectMask(u, :));
    for v = targets
        scores(u, v) = sum_simple_path_products(oneHop, u, v, ...
            options.MaxIndirectHops, options.MaxIndirectPaths);
    end
end

P = make_row_stochastic(scores);
diagnostics = struct( ...
    'rawScores', scores, ...
    'connectionType', connectionType, ...
    'caseCounts', caseCounts, ...
    'sourceDecay', sourceDecay, ...
    'edgeAdjacencyWeight', edgeAdjacencyWeight);
end

function edges = incident_edges(nodeToEdges, node)
if nodeToEdges.isKey(node)
    edges = nodeToEdges(node);
else
    edges = [];
end
end

function support = adjacent_support(u, v, nodeToEdges, hyperEdges, edgeWeights)
support = 0;
sourceEdges = incident_edges(nodeToEdges, u);
targetEdges = incident_edges(nodeToEdges, v);
for first = sourceEdges
    for second = targetEdges
        if first ~= second && ~isempty(intersect(hyperEdges{first}, hyperEdges{second}))
            support = support + edgeWeights(first, second);
        end
    end
end
end

function total = sum_simple_path_products(weights, source, target, maxHops, maxPaths)
% Sum products over simple paths in the one-hop support graph.
n = size(weights, 1);
visited = false(1, n);
visited(source) = true;
pathCount = 0;
total = walk(source, 0, 1);

    function value = walk(current, hops, product)
        value = 0;
        if hops >= maxHops || pathCount >= maxPaths
            return;
        end
        nextNodes = find(weights(current, :) > 0);
        for next = nextNodes
            if visited(next)
                continue;
            end
            nextProduct = product * weights(current, next);
            if next == target
                if hops + 1 >= 2
                    value = value + nextProduct;
                    pathCount = pathCount + 1;
                end
            else
                visited(next) = true;
                value = value + walk(next, hops + 1, nextProduct);
                visited(next) = false;
            end
            if pathCount >= maxPaths
                return;
            end
        end
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
