function labels = spectral_kmeans_clustering(L, k)
    % SPECTRAL_KMEANS_CLUSTERING
    % Perform spectral clustering based on the hypergraph Laplacian matrix.
    %
    % Input:
    %   L : [n × n] hypergraph Laplacian matrix
    %   k : number of clusters (modules)
    %
    % Output:
    %   labels : [n × 1] vector of cluster labels for each node

    %% ===================== Step 1: Eigen-Decomposition =====================
    % Compute the eigenvectors corresponding to the k smallest eigenvalues
    [V, ~] = eigs(L, k, 'smallestabs');   % V: n × k eigenvector matrix

    %% ===================== Step 2: Row Normalization =====================
    % Normalize rows to improve clustering stability
    U = bsxfun(@rdivide, V, sqrt(sum(V.^2, 2)) + 1e-10);  % Avoid division by zero

    %% ===================== Step 3: K-Means Clustering =====================
    % K-means with Euclidean distance
    labels = kmeans(U, k, 'Replicates', 10, 'MaxIter', 300);

    %% ===================== Optional Visualization =====================
    % scatter(U(:,1), U(:,2), 100, labels, 'filled');  % For k = 2 or 3
    % title('Spectral Clustering Result');
end
