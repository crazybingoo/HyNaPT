# Method-to-code map

| Method component | Primary implementation | Public check |
|---|---|---|
| Sliding temporal windows | `src/utils/get_sliding_window.m` | unit test |
| PLV matrix | `src/features/get_plvMatrix.m` | synthetic pipeline |
| Density-threshold curve elbow | `src/hypergraph/select_density_elbow_threshold.m` | unit test |
| Pair and closed-triplet construction | `src/hypergraph/construct_hypergraph.m` | synthetic pipeline |
| Phase-based COC | `src/hypergraph/phase_coc.m` | bounded/locked-phase test |
| Node-attribute assembly | `src/features/extract_node_features.m` | synthetic pipeline |
| Gaussian-kernel similarity | `src/features/GK_Similarity.m` | finite fallback test |
| Pair connection regimes | `src/hypergraph/find_node_pair_connections.m` | four-case test |
| Four-case transition matrix | `src/transition/assemble_transition_matrix.m` | normalization/asymmetry test |
| Isolated-row normalization | `src/transition/make_row_stochastic.m` | uniform-row test |
| Temporal fusion | `src/transition/fuse_transition_matrices.m` | alpha boundary tests |
| Argmax and stochastic top-m paths | `src/analysis/generate_transition_path.m` | deterministic and seeded path tests |
| Exact within-unit AP null | `src/analysis/evaluate_regional_concordance.m` | exact-enumeration test |
| Cohort normalized AP lift | `src/analysis/summarize_regional_concordance.m` | deterministic bootstrap/joint-null test |
| End-to-end public workflow | `workflows/run_feature_pipeline.m` | synthetic pipeline test |
| Aggregate figure scripts | `r_figures/` | render audit |
| Aggregate source data | `Source_Data.xlsx` | workbook and privacy audit |

The implementation scope and interpretation are described in `docs/METHOD_PRINCIPLES.md`.
