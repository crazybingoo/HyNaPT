function normalized = row_normalize(matrix)
%ROW_NORMALIZE Normalize an off-diagonal matrix, including isolated rows.

normalized = make_row_stochastic(matrix);
end
