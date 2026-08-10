function avg_path_lengths = hypergraph_avg_shortest_path(hyperEdges, num_nodes)
    % HYPERGRAPH_AVG_SHORTEST_PATH
    % Compute the average shortest path length for each node in a hypergraph,
    % explicitly considering isolated nodes.
    %
    % Input:
    %   hyperEdges : cell array, where each cell contains the node indices
    %                forming a hyperedge
    %   num_nodes  : total number of nodes in the hypergraph (including isolated nodes)
    %
    % Output:
    %   avg_path_lengths : column vector of average shortest path lengths
    %                      for each node

    N = num_nodes;
    M = length(hyperEdges);    % Number of hyperedges

    %% ===================== Bipartite Graph Construction =====================
    % Construct a bipartite graph: nodes <-> hyperedges
    % Nodes are indexed as 1:N
    % Hyperedges are indexed as N+1:N+M
    adj_list = cell(N + M, 1);
    node_offset = N;

    for e = 1:M
        nodes = hyperEdges{e};
        hyperEdgeID = node_offset + e;
        for i = 1:length(nodes)
            node = nodes(i);
            adj_list{node} = [adj_list{node}, hyperEdgeID];
            adj_list{hyperEdgeID} = [adj_list{hyperEdgeID}, node];
        end
    end

    %% ===================== Shortest Path Computation =====================
    inf_val = 1e6;
    D = zeros(N, N);

    for src = 1:N
        % Breadth-first search (BFS)
        dist = inf_val * ones(N + M, 1);
        dist(src) = 0;
        queue = src;

        while ~isempty(queue)
            v = queue(1);
            queue(1) = [];
            for neighbor = adj_list{v}
                if dist(neighbor) == inf_val
                    dist(neighbor) = dist(v) + 1;
                    queue = [queue, neighbor]; %#ok<AGROW>
                end
            end
        end

        % Store distances to other nodes only
        D(src, :) = dist(1:N);
    end

    %% ===================== Average Path Length =====================
    % Ignore unreachable nodes (distance = inf_val)
    D(D == inf_val) = 0;

    % Average shortest path length for each node
    avg_path_lengths = sum(D, 2) ./ (sum(D > 0, 2) + eps);
end
