function E = hypergraph_efficiency(all_hyperEdges)
    % HYPERGRAPH_EFFICIENCY
    % Compute the global efficiency of a hypergraph at the hyperedge level.
    % Hyperedges are treated as nodes, and two hyperedges are considered
    % adjacent if they share at least one common node.
    %
    % Input:
    %   all_hyperEdges : cell array, where each cell contains a vector
    %                    of node indices representing a hyperedge
    %
    % Output:
    %   E : scalar value representing hypergraph efficiency

    n = length(all_hyperEdges);   % Number of hyperedges
    adj = zeros(n);               % Hyperedge adjacency matrix

    %% ===================== Step 1: Hyperedge Adjacency Construction =====================
    % Two hyperedges are adjacent if they share at least one node
    for i = 1:n
        for j = i+1:n
            if ~isempty(intersect(all_hyperEdges{i}, all_hyperEdges{j}))
                adj(i, j) = 1;
                adj(j, i) = 1;
            end
        end
    end

    %% ===================== Step 2: Shortest Path Between Hyperedges =====================
    G = graph(adj);
    D = distances(G);   % D(i,j): shortest path length between hyperedges i and j

    %% ===================== Step 3: Efficiency Computation =====================
    eff_sum = 0;
    pair_count = 0;

    for i = 1:n
        for j = i+1:n
            d = D(i, j);
            if isfinite(d) && d > 0
                eff_sum = eff_sum + 1 / d;
                pair_count = pair_count + 1;
            end
        end
    end

    %% ===================== Step 4: Normalization =====================
    if pair_count == 0
        E = 0;
    else
        E = eff_sum / pair_count;
    end
end
