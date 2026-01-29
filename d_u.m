function hyperdegree = d_u(hyperEdges, num_nodes)
    % D_U
    % Compute the hyperdegree of each node in a hypergraph.
    % All nodes are considered, including isolated nodes.
    %
    % Input:
    %   hyperEdges : cell array, where each cell contains a vector
    %                of node indices forming a hyperedge
    %   num_nodes  : total number of nodes in the hypergraph
    %
    % Output:
    %   hyperdegree : 1 × num_nodes vector of hyperdegrees

    % Initialize hyperdegree vector
    hyperdegree = zeros(1, num_nodes);

    % Accumulate hyperdegree for each node
    for i = 1:length(hyperEdges)
        nodes_in_edge = hyperEdges{i};
        hyperdegree(nodes_in_edge) = hyperdegree(nodes_in_edge) + 1;
    end
end
