# Known limitations

1. The historical public upload omitted four transition-rule functions referenced by `assemble_transition_matrix.m`.
2. `compute_hyperedge_weight.m` depends on an external `measure_COC` implementation that was not included in the upload and whose redistribution terms have not been verified.
3. Full manuscript figures depend on controlled clinical recordings and participant-level intermediate results; these are intentionally excluded.
4. Several thresholds are inherited from exploratory analysis and still require formal sensitivity analysis.
5. The public workflow currently supports the reference sampling rate of 1024 Hz only.

These items must be resolved before claiming complete independent reproduction of the manuscript results.
