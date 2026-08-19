function [hyperEdges, hyper] = gain_hyperEdges(signal, options)
%GAIN_HYPEREDGES Backward-compatible wrapper around construct_hypergraph.

if nargin < 2
    options = struct;
end
hyper = construct_hypergraph(signal, options);
hyperEdges = hyper.edges;
end
