function summary = summarize_regional_concordance(scoreSets, labelSets, options)
%SUMMARIZE_REGIONAL_CONCORDANCE Cohort summary for label-blind AP lift.
%   Each cell contains one independent analysis unit. Scores remain fixed
%   while binary labels are enumerated exactly within that unit. The cohort
%   mean normalized lift is bootstrapped over units and compared with joint
%   draws from the exact unit-level null distributions.

arguments
    scoreSets (:,1) cell
    labelSets (:,1) cell
    options.BootstrapSamples (1,1) double {mustBeInteger,mustBePositive} = 10000
    options.JointSamples (1,1) double {mustBeInteger,mustBePositive} = 100000
    options.Seed (1,1) double {mustBeInteger,mustBeNonnegative} = 20260820
    options.MaxExactCombinations (1,1) double {mustBeInteger,mustBePositive} = 1e6
end

if numel(scoreSets) ~= numel(labelSets) || isempty(scoreSets)
    error('HyNaPT:Concordance:CohortSize', ...
        'Score and label cell arrays must have the same non-zero length.');
end

numUnits = numel(scoreSets);
unitResults = cell(numUnits, 1);
normalizedLift = zeros(numUnits, 1);
rawLift = zeros(numUnits, 1);
for unit = 1:numUnits
    unitResults{unit} = evaluate_regional_concordance( ...
        scoreSets{unit}(:), double(labelSets{unit}(:)), ...
        'MaxExactCombinations', options.MaxExactCombinations);
    normalizedLift(unit) = unitResults{unit}.normalizedLift;
    rawLift(unit) = unitResults{unit}.rawLift;
end

if any(~isfinite(normalizedLift))
    error('HyNaPT:Concordance:UndefinedLift', ...
        'Normalized lift is undefined for at least one analysis unit.');
end

previousState = rng;
cleanup = onCleanup(@() rng(previousState));
rng(options.Seed, 'twister');
bootstrapIndices = randi(numUnits, numUnits, options.BootstrapSamples);
bootstrapMeans = mean(normalizedLift(bootstrapIndices), 1);
confidenceInterval = prctile(bootstrapMeans, [2.5, 97.5]);

jointNull = zeros(options.JointSamples, numUnits);
for unit = 1:numUnits
    nullAP = unitResults{unit}.nullDistribution;
    sampled = nullAP(randi(numel(nullAP), options.JointSamples, 1));
    jointNull(:, unit) = (sampled - unitResults{unit}.nullMeanAP) ./ ...
        (1 - unitResults{unit}.nullMeanAP);
end
jointNullMean = mean(jointNull, 2);
observedMean = mean(normalizedLift);
twoSidedP = (1 + sum(abs(jointNullMean) >= abs(observedMean))) / ...
    (options.JointSamples + 1);

summary = struct( ...
    'numUnits', numUnits, ...
    'observedMeanAP', mean(cellfun(@(x) x.observedAP, unitResults)), ...
    'exactNullMeanAP', mean(cellfun(@(x) x.nullMeanAP, unitResults)), ...
    'meanRawLift', mean(rawLift), ...
    'meanNormalizedLift', observedMean, ...
    'normalizedLiftCI', confidenceInterval, ...
    'twoSidedJointPermutationP', twoSidedP, ...
    'positiveRawLiftCount', sum(rawLift > 0), ...
    'unitResults', {unitResults});

clear cleanup
end
