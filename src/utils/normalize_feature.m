function normalized = normalize_feature(values)
%NORMALIZE_FEATURE Z-score and min-max normalize a numeric feature.
% Constant or entirely non-finite inputs are mapped to zeros.

inputSize = size(values);
values = double(values);
finiteMask = isfinite(values);

if ~any(finiteMask(:))
    normalized = zeros(inputSize);
    return;
end

finiteValues = values(finiteMask);
mu = mean(finiteValues);
sigma = std(finiteValues);

if sigma <= eps(max(abs(finiteValues)))
    zValues = zeros(inputSize);
else
    zValues = (values - mu) ./ sigma;
end

zValues(~finiteMask) = 0;
minimum = min(zValues(:));
maximum = max(zValues(:));

if maximum - minimum <= eps(max(abs([minimum, maximum])))
    normalized = zeros(inputSize);
else
    normalized = (zValues - minimum) ./ (maximum - minimum);
end
end
