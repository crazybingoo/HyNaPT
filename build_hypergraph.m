function hyper = build_hypergraph(datanew)

hyper.edges = gain_hyperEdges(datanew);
hyper.dc = size(datanew,1);
hyper.degree = d_u(hyper.edges, hyper.dc)';
end
