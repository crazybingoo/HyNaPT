function connectionCOC = compute_hyperedge_weight(signal, threshold)
%COMPUTE_HYPEREDGE_WEIGHT Return COC weights for closed PLV triplets.

if nargin < 2
    threshold = [];
end
options = struct('Threshold', threshold);
hyper = construct_hypergraph(signal, options);
tripletMask = hyper.edgeOrder == 3;
triplets = hyper.edges(tripletMask);
if isempty(triplets)
    connectionCOC = zeros(0, 4);
    return;
end
connectionCOC = [vertcat(triplets{:}), hyper.edgeWeights(tripletMask)];
end
