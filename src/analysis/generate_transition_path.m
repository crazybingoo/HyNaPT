function path = generate_transition_path(transitionMatrix, sourceNode, options)
%GENERATE_TRANSITION_PATH Deterministic argmax or stochastic top-m path.
%   CandidateFraction = 0 selects the maximum-probability destination.
%   A positive fraction retains the corresponding top fraction of non-zero
%   destinations, draws NumSamples targets in proportion to their weights,
%   and advances to the modal sampled target.

arguments
    transitionMatrix (:,:) double {mustBeFinite,mustBeNonnegative}
    sourceNode (1,1) double {mustBeInteger,mustBePositive}
    options.Steps (1,1) double {mustBeInteger,mustBePositive} = 10
    options.CandidateFraction (1,1) double {mustBeGreaterThanOrEqual(options.CandidateFraction,0),mustBeLessThanOrEqual(options.CandidateFraction,1)} = 0
    options.NumSamples (1,1) double {mustBeInteger,mustBePositive} = 100
    options.Seed (1,1) double {mustBeInteger,mustBeNonnegative} = 1
end

[numRows, numColumns] = size(transitionMatrix);
if numRows ~= numColumns
    error('HyNaPT:Path:SquareMatrix', 'Transition matrix must be square.');
end
if sourceNode > numRows
    error('HyNaPT:Path:SourceRange', 'Source node exceeds matrix size.');
end

previousState = rng;
cleanup = onCleanup(@() rng(previousState));
rng(options.Seed, 'twister');
path = zeros(1, options.Steps + 1);
path(1) = sourceNode;

for step = 1:options.Steps
    current = path(step);
    weights = transitionMatrix(current, :);
    weights(current) = 0;
    candidates = find(weights > 0);
    if isempty(candidates)
        candidates = setdiff(1:numRows, current);
        weights(candidates) = 1;
    end
    [~, order] = sort(weights(candidates), 'descend');
    candidates = candidates(order);

    if options.CandidateFraction == 0
        nextNode = candidates(1);
    else
        numRetained = max(1, ceil(options.CandidateFraction * numel(candidates)));
        retained = candidates(1:numRetained);
        probabilities = weights(retained);
        probabilities = probabilities ./ sum(probabilities);
        cumulative = cumsum(probabilities);
        draws = zeros(options.NumSamples, 1);
        for draw = 1:options.NumSamples
            draws(draw) = retained(find(rand <= cumulative, 1, 'first'));
        end
        nextNode = mode(draws);
    end
    path(step + 1) = nextNode;
end

clear cleanup
end
