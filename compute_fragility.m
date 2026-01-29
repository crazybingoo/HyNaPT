function fragility_scores = compute_fragility(EZ_nodes, G)
    % COMPUTE_FRAGILITY
    % Compute node fragility scores based on the loss of reachability
    % from epileptogenic zone (EZ) nodes after node removal.
    %
    % Input:
    %   EZ_nodes : vector containing indices of EZ region nodes
    %   G        : MATLAB graph object representing the network
    %
    % Output:
    %   fragility_scores : column vector of node fragility scores

    num_nodes = numnodes(G);                 % Number of nodes in the graph
    fragility_scores = zeros(num_nodes, 1);  % Initialize fragility scores

    %% ===================== Initial Reachability =====================
    % Count the number of nodes reachable from at least one EZ node
    reachable_nodes = 0;

    for i = 1:num_nodes
        for ez = EZ_nodes
            [~, dist] = shortestpath(G, ez, i);
            if dist ~= Inf
                reachable_nodes = reachable_nodes + 1;
                break;  % Node i is reachable from at least one EZ node
            end
        end
    end

    %% ===================== Node Removal Test =====================
    for i = 1:num_nodes
        % Remove node i from the graph
        G_removed = rmnode(G, i);

        reachable_nodes_removed = 0;

        for j = 1:num_nodes
            for ez = EZ_nodes
                [~, dist_removed] = shortestpath(G_removed, ez, j);
                if dist_removed ~= Inf
                    reachable_nodes_removed = reachable_nodes_removed + 1;
                    break;  % Node j remains reachable after removal
                end
            end
        end

        % Proportion of lost propagation paths
        lost_paths = reachable_nodes - reachable_nodes_removed;
        fragility_scores(i) = lost_paths / reachable_nodes;
    end
end
