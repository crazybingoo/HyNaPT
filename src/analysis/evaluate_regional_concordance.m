function result = evaluate_regional_concordance(scores, labels, options)
%EVALUATE_REGIONAL_CONCORDANCE Exact within-unit AP permutation analysis.
%   RESULT = EVALUATE_REGIONAL_CONCORDANCE(SCORES, LABELS) ranks binary
%   positive labels above negative labels using average precision (AP).
%   The exact null preserves the number of positive labels while keeping
%   the scores fixed. Source-zone contacts must be removed by the caller.

arguments
    scores (:,1) double {mustBeFinite}
    labels (:,1) double {mustBeFinite}
    options.MaxExactCombinations (1,1) double {mustBeInteger,mustBePositive} = 1e6
end

if numel(scores) ~= numel(labels)
    error('HyNaPT:Concordance:SizeMismatch', ...
        'Scores and labels must contain the same number of entries.');
end
if any(labels ~= 0 & labels ~= 1)
    error('HyNaPT:Concordance:BinaryLabels', ...
        'Labels must be encoded as 0 or 1.');
end

numTargets = numel(labels);
numPositive = sum(labels);
if numPositive == 0 || numPositive == numTargets
    error('HyNaPT:Concordance:DegenerateLabels', ...
        'At least one positive and one negative label are required.');
end

numCombinations = nchoosek(numTargets, numPositive);
if numCombinations > options.MaxExactCombinations
    error('HyNaPT:Concordance:NullTooLarge', ...
        'Exact null requires %g combinations; increase MaxExactCombinations explicitly.', ...
        numCombinations);
end

observedAP = local_average_precision(scores, labels);
positiveSets = nchoosek(1:numTargets, numPositive);
nullAP = zeros(size(positiveSets, 1), 1);
for index = 1:size(positiveSets, 1)
    permutedLabels = zeros(numTargets, 1);
    permutedLabels(positiveSets(index, :)) = 1;
    nullAP(index) = local_average_precision(scores, permutedLabels);
end

nullMean = mean(nullAP);
rawLift = observedAP - nullMean;
denominator = 1 - nullMean;
if denominator <= eps
    normalizedLift = NaN;
else
    normalizedLift = rawLift / denominator;
end

result = struct( ...
    'observedAP', observedAP, ...
    'nullMeanAP', nullMean, ...
    'rawLift', rawLift, ...
    'normalizedLift', normalizedLift, ...
    'nullDistribution', nullAP, ...
    'numTargets', numTargets, ...
    'numPositive', numPositive);
end

function ap = local_average_precision(scores, labels)
[~, order] = sort(scores, 'descend');
rankedLabels = labels(order);
precision = cumsum(rankedLabels) ./ (1:numel(labels))';
ap = sum(precision .* rankedLabels) / sum(rankedLabels);
end
