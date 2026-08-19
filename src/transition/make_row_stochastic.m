function P = make_row_stochastic(weights)
%MAKE_ROW_STOCHASTIC Sanitize and normalize off-diagonal transition scores.

validateattributes(weights, {'double'}, {'2d', 'square'});
n = size(weights, 1);
weights(~isfinite(weights) | weights < 0) = 0;
weights(1:n+1:end) = 0;

rowSums = sum(weights, 2);
isolated = rowSums <= eps;
if any(isolated) && n > 1
    weights(isolated, :) = 1;
    indices = find(isolated);
    weights(sub2ind([n, n], indices, indices)) = 0;
end

rowSums = sum(weights, 2);
P = zeros(n);
valid = rowSums > eps;
P(valid, :) = weights(valid, :) ./ rowSums(valid);
end
