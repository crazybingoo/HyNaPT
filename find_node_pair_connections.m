function [connectionType, typeCounts, hyperEdgeGroups, node_to_edges] = ...
         find_node_pair_connections(hyperEdges, total_nodes)
    % FIND_NODE_PAIR_CONNECTIONS
    % Identify pairwise node connection types in a hypergraph, with full
    % support for isolated nodes.
    %
    % Connection types:
    %   1 - Nodes belong to the same hyperedge
    %   2 - Nodes are connected via adjacent hyperedges
    %   3 - Nodes are indirectly connected through a hyperedge path
    %   4 - Nodes are not connected
    %
    % Input:
    %   hyperEdges  : cell array, each cell contains node indices of a hyperedge
    %   total_nodes : (optional) scalar or vector specifying all nodes
    %
    % Output:
    %   connectionType   : matrix encoding pairwise connection types
    %   typeCounts       : structure containing counts of each connection type
    %   hyperEdgeGroups  : (reserved) container for hyperedge groupings
    %   node_to_edges    : mapping from nodes to associated hyperedge indices

    %% ===================== Node Initialization =====================
    if exist('total_nodes', 'var')
        if isscalar(total_nodes)
            all_nodes = 1:total_nodes;
        else
            all_nodes = unique(total_nodes(:)');
        end
    else
        all_nodes = unique([hyperEdges{:}]);
    end

    num_nodes = length(all_nodes);
    [~, node2idx] = ismember(all_nodes, all_nodes); %#ok<NASGU>

    %% ===================== Node-to-Hyperedge Mapping =====================
    node_to_edges = containers.Map( ...
        'KeyType', class(all_nodes(1)), ...
        'ValueType', 'any');

    for edge_idx = 1:length(hyperEdges)
        current_edge = hyperEdges{edge_idx};
        for node = current_edge
            if ~node_to_edges.isKey(node)
                node_to_edges(node) = [];
            end
            node_to_edges(node) = [node_to_edges(node), edge_idx];
        end
    end

    %% ===================== Initialization =====================
    % Default: not connected (type 4)
    connectionType = 4 * ones(num_nodes);
    connectionType(logical(eye(num_nodes))) = 0;

    typeCounts = struct( ...
        'sameHyperEdge',        0, ...
        'adjacentHyperEdge',    0, ...
        'indirectlyConnected',  0, ...
        'notConnected',         num_nodes * (num_nodes - 1) / 2);

    hyperEdgeGroups = containers.Map;

    %% ===================== Main Processing Loop =====================
    for i_idx = 1:num_nodes
        node_i = all_nodes(i_idx);
        has_edge_i = node_to_edges.isKey(node_i);

        for j_idx = (i_idx + 1):num_nodes
            node_j = all_nodes(j_idx);
            has_edge_j = node_to_edges.isKey(node_j);

            %% Case 0: Isolated nodes
            if ~has_edge_i || ~has_edge_j
                connectionType(i_idx, j_idx) = 4;
                connectionType(j_idx, i_idx) = 4;
                continue;
            end

            %% Case 1: Same hyperedge
            edges_i = node_to_edges(node_i);
            edges_j = node_to_edges(node_j);
            common_edges = intersect(edges_i, edges_j);

            if ~isempty(common_edges)
                connectionType(i_idx, j_idx) = 1;
                connectionType(j_idx, i_idx) = 1;
                typeCounts.sameHyperEdge = typeCounts.sameHyperEdge + 1;
                typeCounts.notConnected = typeCounts.notConnected - 1;
                continue;
            end

            %% Case 2: Adjacent hyperedges
            nodes_in_edges_i = unique([hyperEdges{edges_i}]);
            nodes_in_edges_j = unique([hyperEdges{edges_j}]);
            shared_nodes = intersect(nodes_in_edges_i, nodes_in_edges_j);
            shared_nodes = setdiff(shared_nodes, [node_i, node_j]);

            if ~isempty(shared_nodes)
                connectionType(i_idx, j_idx) = 2;
                connectionType(j_idx, i_idx) = 2;
                typeCounts.adjacentHyperEdge = typeCounts.adjacentHyperEdge + 1;
                typeCounts.notConnected = typeCounts.notConnected - 1;
                continue;
            end

            %% Case 3: Indirect hyperedge path
            visited = false(max([edges_i, edges_j]));
            queue = edges_i;
            found = false;

            while ~isempty(queue) && ~found
                current_edge = queue(1);
                queue(1) = [];

                if visited(current_edge)
                    continue;
                end
                visited(current_edge) = true;

                if ismember(node_j, hyperEdges{current_edge})
                    found = true;
                    break;
                end

                % Expand search to adjacent hyperedges
                connect_nodes = hyperEdges{current_edge};
                connected_edges = [];

                for n = connect_nodes
                    if node_to_edges.isKey(n)
                        connected_edges = [connected_edges, node_to_edges(n)];
                    end
                end

                queue = unique([queue, connected_edges]);
            end

            %% Update indirect connection
            if found
                connectionType(i_idx, j_idx) = 3;
                connectionType(j_idx, i_idx) = 3;
                typeCounts.indirectlyConnected = typeCounts.indirectlyConnected + 1;
                typeCounts.notConnected = typeCounts.notConnected - 1;
            end
        end
    end
end
