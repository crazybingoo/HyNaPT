function Q = fuse_transition_matrices(currentMatrix, nextMatrix, alpha)
%FUSE_TRANSITION_MATRICES Convexly combine consecutive transition matrices.

arguments
    currentMatrix double
    nextMatrix double
    alpha (1,1) double {mustBeGreaterThanOrEqual(alpha,0),mustBeLessThanOrEqual(alpha,1)}
end
if ~isequal(size(currentMatrix), size(nextMatrix))
    error('HyNaPT:TransitionSizeMismatch', ...
        'Consecutive transition matrices must have the same dimensions.');
end
Q = make_row_stochastic((1 - alpha) .* currentMatrix + alpha .* nextMatrix);
end
