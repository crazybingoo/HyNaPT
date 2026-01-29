function connection_coc = compute_hyperedge_weight(datanew)
    % COMPUTE_HYPEREDGE_WEIGHT
    % Compute hyperedge weights based on Phase Locking Value (PLV)
    % and Cross-Ordinal Coupling (COC) for second-order hyperedges.
    %
    % Input:
    %   datanew : [channels × time] signal matrix
    %
    % Output:
    %   connection_coc : matrix where each row contains
    %                    [node1, node2, node3, COC_weight]

    [dc, ~] = size(datanew);

    %% ===================== 1. PLV Matrix =====================
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

    %% ===================== 2. Threshold Selection =====================
    plvMatrix = plvMatrix - eye(dc);
    plvMatrix_upper = triu(plvMatrix);
    plvVector = reshape(plvMatrix_upper, [], 1);
    sorted_plv = sort(plvVector, 'descend');
    nonZero_sorted_plv = sorted_plv(sorted_plv ~= 0);

    % 50th percentile threshold
    threshold = nonZero_sorted_plv( ...
        round(size(nonZero_sorted_plv, 1) * 0.50), 1);

    plvMatrix = plvMatrix + eye(dc);

    %% ===================== 3. Binary Connection Matrix =====================
    % Scale to avoid floating-point precision issues
    plvMatrix_big = floor(plvMatrix * 10000);
    is_symmetric = isequal(plvMatrix_big, plvMatrix_big'); %#ok<NASGU>

    threshold_big = floor(threshold * 10000);

    % Connections above threshold are set to 1
    connection_matrix = plvMatrix_big >= threshold_big;
    connection_matrix = connection_matrix - eye(dc);

    %% ===================== 4. Second-Order Hyperedge Construction =====================
    % Identify fully connected triangles
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

    % Sort node indices within each hyperedge and remove duplicates
    connection_initial_index = unique(sort(triangle_list, 2), ...
                                      'rows', 'stable');

    %% ===================== 5. Hyperedge Weight Computation (COC) =====================
    COC = [];

    for i = 1:size(connection_initial_index, 1)
        % Extract multivariate signal for the hyperedge
        Z = datanew(connection_initial_index(i,:), :)';

        % Compute cross-ordinal coupling
        COC_value = measure_COC(Z);

        COC = [COC; COC_value]; %#ok<AGROW>
    end

    % Combine hyperedge indices and corresponding weights
    connection_coc = [connection_initial_index, COC];

end
