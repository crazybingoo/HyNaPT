function hyperEdges = gain_hyperEdges(datanew)
    % GAIN_HYPEREDGES
    % Construct hyperedge sets including:
    %   - First-order hyperedges (2 nodes)
    %   - Second-order hyperedges (3 nodes)
    %   - Third-order hyperedges (4 nodes)
    %
    % Input:
    %   datanew : [channels × time] signal matrix
    %
    % Output:
    %   hyperEdges : cell array containing hyperedges of different orders

    [dc, ~] = size(datanew);

    %% ===================== 1. PLV Matrix (Basis of First-Order Hyperedges) =====================
    plvMatrix = zeros(dc, dc);

    for ch1 = 1:dc
        for ch2 = 1:dc
            % Extract instantaneous phase sequences
            phase1 = angle(hilbert(datanew(ch1, :)));
            phase2 = angle(hilbert(datanew(ch2, :)));

            % Phase difference
            phaseDiff = phase1 - phase2;

            % Phase Locking Value (PLV)
            plv = abs(mean(exp(1i * phaseDiff)));

            % Store PLV
            plvMatrix(ch1, ch2) = plv;
        end
    end

    % Threshold selection (original 55th percentile strategy)
    plvMatrix = plvMatrix - eye(dc);
    plvMatrix_1 = triu(plvMatrix);
    plvMatrix_vec = reshape(plvMatrix_1, [], 1);
    sorted_plv = sort(plvMatrix_vec, 'descend');
    nonZero_sorted_plv = sorted_plv(sorted_plv ~= 0);

    threshold = nonZero_sorted_plv( ...
        round(size(nonZero_sorted_plv, 1) * 0.55), 1);

    plvMatrix = plvMatrix + eye(dc);

    %% ===================== 2. Binary Connection Matrix =====================
    % Scale to avoid floating-point precision issues
    plvMatrix_big = floor(plvMatrix * 10000);
    is_symmetric = isequal(plvMatrix_big, plvMatrix_big'); %#ok<NASGU>

    threshold_big = floor(threshold * 10000);

    % Connections above threshold are set to 1
    connection_matrix = plvMatrix_big >= threshold_big;
    connection_matrix = connection_matrix - eye(dc);

    %% ===================== 3. Second-Order Hyperedges: Closed Triangles =====================
    network = graph(connection_matrix); %#ok<NASGU>
    triangle_list = [];
    kk = size(connection_matrix, 1);

    for i = 1:kk
        for j = 1:kk
            for k = 1:kk
                if connection_matrix(i,j) && ...
                   connection_matrix(i,k) && ...
                   connection_matrix(j,k)
                    triangle_list = [triangle_list; i j k]; %#ok<AGROW>
                end
            end
        end
    end

    % Sort nodes within each hyperedge and remove duplicates
    connection_initial_index = unique(sort(triangle_list, 2), ...
                                      'rows', 'stable');
    % Each row corresponds to one second-order hyperedge (3 nodes)

    %% ===================== 4. First-Order Hyperedges: Node Pairs =====================
    [row, col] = find(triu(connection_matrix, 1)); % Upper triangle only
    hyperEdges_dim2 = arrayfun(@(i) [row(i), col(i)], ...
                               1:length(row), ...
                               'UniformOutput', false)';
    % Each cell contains a first-order hyperedge (2 nodes)

    %% ===================== 5. Third-Order Hyperedges: Fully Connected Tetrahedrons =====================
    % Strategy:
    % For a node set {a,b,c,d}, if all four second-order hyperedges
    % {a,b,c}, {a,b,d}, {a,c,d}, {b,c,d} exist,
    % then {a,b,c,d} forms a third-order hyperedge.

    comb4 = nchoosek(1:dc, 4);   % All 4-node combinations
    numComb4 = size(comb4, 1);

    third_order_list = [];

    % Ensure sorted indices for comparison
    connection_initial_index_sorted = sort(connection_initial_index, 2);

    for idx = 1:numComb4
        a = comb4(idx,1);
        b = comb4(idx,2);
        c = comb4(idx,3);
        d = comb4(idx,4);

        triples = [
            a b c;
            a b d;
            a c d;
            b c d
        ];

        if all(ismember(triples, ...
                        connection_initial_index_sorted, ...
                        'rows'))
            third_order_list = [third_order_list; a b c d]; %#ok<AGROW>
        end
    end

    if isempty(third_order_list)
        hyperEdges_dim4 = {};
    else
        hyperEdges_dim4 = mat2cell(third_order_list, ...
                                   ones(1, size(third_order_list,1)), ...
                                   4)';
    end

    %% ===================== 6. Merge All Hyperedges =====================
    hyperEdges_dim3 = mat2cell(connection_initial_index, ...
                               ones(1, size(connection_initial_index,1)), ...
                               3)';

    hyperEdges = [
        hyperEdges_dim2;   % First-order (2 nodes)
        hyperEdges_dim3;   % Second-order (3 nodes)
        hyperEdges_dim4    % Third-order (4 nodes)
    ];

end
