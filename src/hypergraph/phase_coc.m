function coc = phase_coc(phaseMatrix)
%PHASE_COC Compute the phase-based COC synchrony weight for a node group.
%   phaseMatrix is samples x nodes and contains instantaneous phase in
%   radians. The normalized spectral entropy of the circular-correlation
%   matrix yields a bounded higher-order synchronization weight.

validateattributes(phaseMatrix, {'double'}, {'2d', 'nonempty', 'finite'});
numNodes = size(phaseMatrix, 2);
if numNodes < 2
    error('HyNaPT:COCRequiresMultipleNodes', ...
        'COC requires phase series from at least two nodes.');
end

correlation = eye(numNodes);
for first = 1:numNodes
    for second = first + 1:numNodes
        value = circular_correlation(phaseMatrix(:, first), phaseMatrix(:, second));
        correlation(first, second) = value;
        correlation(second, first) = value;
    end
end

eigenvalues = real(eig((correlation + correlation') ./ 2));
eigenvalues(eigenvalues < 0 & eigenvalues > -1e-10) = 0;
eigenvalues = max(eigenvalues, 0);
if sum(eigenvalues) <= eps
    coc = 0;
    return;
end
probabilities = eigenvalues ./ sum(eigenvalues);
probabilities = probabilities(probabilities > 0);
coc = 1 + sum(probabilities .* log2(probabilities)) ./ log2(numNodes);
coc = min(max(real(coc), 0), 1);
end

function value = circular_correlation(first, second)
firstMean = atan2(mean(sin(first)), mean(cos(first)));
secondMean = atan2(mean(sin(second)), mean(cos(second)));
firstCentered = sin(first - firstMean);
secondCentered = sin(second - secondMean);
denominator = sqrt(sum(firstCentered .^ 2) * sum(secondCentered .^ 2));
if denominator <= eps
    value = 0;
else
    value = sum(firstCentered .* secondCentered) / denominator;
end
value = min(max(value, -1), 1);
end
