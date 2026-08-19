function [threshold, curve] = select_density_elbow_threshold(plvMatrices, thresholdGrid)
%SELECT_DENSITY_ELBOW_THRESHOLD Select the density-curve elbow.
%   Uses the maximum perpendicular distance to the chord joining the first
%   and last normalized density-threshold points. For a 3-D input, density
%   is averaged across windows before the elbow is selected.

if nargin < 2 || isempty(thresholdGrid)
    thresholdGrid = 0:0.0025:1;
end
validateattributes(plvMatrices, {'double'}, {'nonempty', 'finite'});
validateattributes(thresholdGrid, {'double'}, ...
    {'vector', 'increasing', '>=', 0, '<=', 1});

n = size(plvMatrices, 1);
if size(plvMatrices, 2) ~= n
    error('HyNaPT:InvalidPLVShape', 'PLV input must be square in its first two dimensions.');
end
numWindows = size(plvMatrices, 3);
numPairs = nchoosek(n, 2);
density = zeros(numel(thresholdGrid), numWindows);
for windowIndex = 1:numWindows
    matrix = plvMatrices(:, :, windowIndex);
    values = matrix(triu(true(n), 1));
    for index = 1:numel(thresholdGrid)
        density(index, windowIndex) = sum(values >= thresholdGrid(index)) / max(numPairs, 1);
    end
end
meanDensity = mean(density, 2);

x = normalize_unit(thresholdGrid(:));
y = normalize_unit(meanDensity(:));
firstPoint = [x(1), y(1)];
lastPoint = [x(end), y(end)];
chord = lastPoint - firstPoint;
denominator = max(norm(chord), eps);
distance = abs(chord(1) .* (firstPoint(2) - y) - ...
    (firstPoint(1) - x) .* chord(2)) ./ denominator;
if numel(distance) > 2
    distance([1, end]) = -Inf;
end
[~, elbowIndex] = max(distance);
threshold = thresholdGrid(elbowIndex);
curve = table(thresholdGrid(:), meanDensity, distance, ...
    'VariableNames', {'threshold', 'meanDensity', 'distanceToChord'});
curve.isElbow = false(height(curve), 1);
curve.isElbow(elbowIndex) = true;
end

function values = normalize_unit(values)
span = max(values) - min(values);
if span <= eps
    values = zeros(size(values));
else
    values = (values - min(values)) ./ span;
end
end
