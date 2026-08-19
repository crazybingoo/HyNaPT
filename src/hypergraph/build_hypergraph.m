function hyper = build_hypergraph(datanew, options)
%BUILD_HYPERGRAPH Backward-compatible entry point for current construction.

if nargin < 2
    options = struct;
end
hyper = construct_hypergraph(datanew, options);
end
