function F = compute_Refined_Connectivity(N, all_hyperEdges)
    % COMPUTEREFINEDCONNECTIVITY
    % Compute a refined connectivity measure based on hypergraph
    % connected components using a Union-Find (Disjoint Set) structure.
    %
    % Input:
    %   N              : number of nodes in the network
    %   all_hyperEdges : cell array, each cell contains a vector of node indices
    %                    representing one hyperedge
    %
    % Output:
    %   F : refined connectivity measure reflecting component size distribution

    %% ===================== Union-Find Initialization =====================
    parent = 1:N;

    % Find operation with path compression
    function p = find_set(x)
        while parent(x) ~= x
            parent(x) = parent(parent(x));  % Path compression
            x = parent(x);
        end
        p = x;
    end

    % Union operation
    function union_set(x, y)
        px = find_set(x);
        py = find_set(y);
        if px ~= py
            parent(py) = px;  % Merge component py into px
        end
    end

    %% ===================== Merge Nodes Within Hyperedges =====================
    % Nodes belonging to the same hyperedge are merged into one component
    for i = 1:length(all_hyperEdges)
        he = all_hyperEdges{i};
        for j = 2:length(he)
            union_set(he(1), he(j));
        end
    end

    %% ===================== Path Compression =====================
    for i = 1:N
        parent(i) = find_set(i);
    end

    %% ===================== Component Size Statistics =====================
    % Count the size of each connected component
    component_counts = histcounts(parent, 0.5:1:N+0.5);

    % Number of connected components
    numComponents = sum(component_counts > 0);

    % Sizes of all components
    component_sizes = component_counts(component_counts > 0);

    %% ===================== Refined Connectivity Measure =====================
    % Measure based on the distribution of component sizes
    component_size_ratio = sum(component_sizes.^2) / N^2;

    % Refined connectivity score
    F = 1 - component_size_ratio;

    % Incorporate the number of components for additional fine-graining
    if numComponents > 1
        F = F * (1 + log(numComponents));
    end
end
