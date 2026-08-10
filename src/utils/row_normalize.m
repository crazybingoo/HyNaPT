function normalized = row_normalize(matrix)
%ROW_NORMALIZE Normalize rows while safely handling all-zero rows.

rowSums = sum(matrix, 2);
normalized = zeros(size(matrix));
validRows = isfinite(rowSums) & rowSums > 0;
normalized(validRows, :) = matrix(validRows, :) ./ rowSums(validRows);
end
