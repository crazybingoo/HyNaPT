function weightsBetweenEdges = compute_hyperedge_adj_weight(hyperEdges, edgeWeights)
%COMPUTE_HYPEREDGE_ADJ_WEIGHT Compute weights between intersecting hyperedges.

numEdges = numel(hyperEdges);
edgeWeights = edgeWeights(:);
if numel(edgeWeights) ~= numEdges
    error('HyNaPT:InvalidEdgeWeights', ...
        'edgeWeights must contain one value for each hyperedge.');
end

weightsBetweenEdges = zeros(numEdges);
if numEdges == 0
    return;
end

allNodes = unique([hyperEdges{:}]);
nodeDegree = zeros(1, max(allNodes));
for edgeIndex = 1:numEdges
    nodeDegree(hyperEdges{edgeIndex}) = nodeDegree(hyperEdges{edgeIndex}) + 1;
end

observedDegrees = nodeDegree(allNodes);
lambda = 1 / max(mean(observedDegrees) + std(observedDegrees), eps);
maxDegree = max(observedDegrees);

for firstEdge = 1:numEdges
    for secondEdge = firstEdge + 1:numEdges
        commonNodes = intersect(hyperEdges{firstEdge}, hyperEdges{secondEdge});
        value = 0;
        for node = commonNodes
            attenuation = exp(-lambda * nodeDegree(node) / maxDegree);
            relatedEdges = find(cellfun(@(edge) ismember(node, edge), hyperEdges));
            contribution = sum(edgeWeights(relatedEdges) ./ ...
                cellfun(@numel, hyperEdges(relatedEdges))');
            value = value + attenuation * contribution;
        end
        weightsBetweenEdges(firstEdge, secondEdge) = value;
        weightsBetweenEdges(secondEdge, firstEdge) = value;
    end
end
end
