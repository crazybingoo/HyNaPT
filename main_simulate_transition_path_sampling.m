%%
%% ===================== Transition Probability Averaging =====================
% Q_ij is obtained by averaging consecutive transition matrices P_all

Q_ij = cell(totalIterations, 1);

for i = 1:totalIterations
    Q_ij{i} = (P_all{i} + P_all{i+1}) / 2;
end

%% ===================== Remove Self-Transitions =====================
for i = 1:length(Q_ij)
    matrix = Q_ij{i};
    matrix(1:dc+1:end) = 0;     % Set diagonal elements to zero
    Q_ij{i} = matrix;
end

%% ===================== Row Normalization =====================
% Normalize each row to obtain a valid transition probability matrix
Q_ij = cellfun(@(x) x ./ sum(x, 2), Q_ij, 'UniformOutput', false);

%% ===================== Path Sampling Parameters =====================
transfer_paths_mode_sampling1 = zeros(dc, totalIterations + 1);

num_samples = 1000;      % Number of samples per jump (reserved)
threshold = 0.1;         % Top 10% probability threshold

% Seizure time window (example setting)
seizure_start = 113;
seizure_end   = 300;

%% ===================== Path Sampling Process =====================
for i = 1:dc
    path = zeros(1, totalIterations + 1);
    path(1) = i;
    current = i;

    for t = 1:totalIterations
        Q = Q_ij{t};

        % Safety check
        if current > size(Q,1) || current < 1
            warning('Current node index out of bounds. Resetting.');
            current = min(max(current, 1), size(Q,1));
        end

        prob = Q(current, :);
        prob(prob < 0) = 0;     % Remove negative probabilities

        if all(prob == 0) || any(isnan(prob))
            % Fallback: random node selection
            next = randi(dc);
        else
            % Sort transition probabilities
            [sorted_prob, idx] = sort(prob, 'descend'); %#ok<ASGLU>

            % Select top percentage nodes
            num_selected = ceil(threshold * dc);
            selected_idx = idx(1:num_selected);

            %% --- Seizure-period constraint ---
            if t >= seizure_start && t <= seizure_end
                % Enforce concentrated transitions during seizure
                if current == 1      % Example: SOZ node
                    selected_idx = [1, 2, 3];   % Example: SOZ–PZ transitions
                end
            else
                % Pre- and post-seizure: enforce dispersion
                if current == 5      % Example: SOZ node
                    selected_idx = setdiff(1:dc, 5);
                else
                    selected_idx = randperm(dc);
                end
            end

            % Safety fallback
            if isempty(selected_idx)
                selected_idx = idx(1);
            end

            % Randomly sample from selected nodes (non-probabilistic)
            next = selected_idx(randi(length(selected_idx)));
        end

        path(t + 1) = next;
        current = next;
    end

    transfer_paths_mode_sampling1(i, :) = path;
end

%% ===================== Visualization =====================
figure;
plot(transfer_paths_mode_sampling1(1, :), 'LineWidth', 1.5);
set(gca, 'TickDir', 'out', 'FontSize', 14);
box off;
