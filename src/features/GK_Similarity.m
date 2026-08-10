function similarity = GK_Similarity(A)
    % GK_SIMILARITY
    % Compute the Gaussian kernel similarity matrix between nodes
    % based on their feature representations.
    %
    % Input:
    %   A : [num_nodes × num_features] feature matrix,
    %       where each row corresponds to one node
    %
    % Output:
    %   similarity : [num_nodes × num_nodes] Gaussian kernel
    %                similarity matrix

    % Number of nodes
    n = size(A, 1);

    %% ===================== Pairwise Euclidean Distance =====================
    D = zeros(n, n);
    for u = 1:n
        for v = 1:n
            if u ~= v
                D(u, v) = norm(A(u, :) - A(v, :));
            end
        end
    end

    %% ===================== Bandwidth Estimation (MAD) =====================
    % Median of pairwise distances
    median_D = median(D(:));

    % Median absolute deviation (MAD)
    abs_deviation = abs(D(:) - median_D);
    MAD = median(abs_deviation);

    % Gaussian kernel bandwidth. Constant feature matrices have MAD = 0;
    % use a neutral finite fallback instead of returning NaN values.
    sigma = 1.4826 * MAD;
    if ~isfinite(sigma) || sigma <= eps
        nonzeroDistances = D(D > 0 & isfinite(D));
        if isempty(nonzeroDistances)
            sigma = 1;
        else
            sigma = median(nonzeroDistances);
        end
    end

    %% ===================== Gaussian Kernel Similarity =====================
    similarity = exp(-D.^2 / (2 * sigma^2));

    % Optional: remove self-similarity
    % similarity(1:n+1:end) = 0;
end
