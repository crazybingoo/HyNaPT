# Method-to-code map

| Method component | Primary implementation |
|---|---|
| Sliding temporal windows | `src/utils/get_sliding_window.m` |
| PLV matrix | `src/features/get_plvMatrix.m` |
| Hyperedge construction | `src/hypergraph/gain_hyperEdges.m` |
| Hyperdegree | `src/hypergraph/d_u.m` |
| Hypergraph path length | `src/hypergraph/hypergraph_avg_shortest_path.m` |
| HFO band power | `src/features/compute_HFO_PSD.m` |
| Phase-amplitude coupling | `src/features/compute_PAC.m` |
| Node-attribute assembly | `src/features/extract_node_features.m` |
| Gaussian-kernel similarity | `src/features/GK_Similarity.m` |
| Pair connection regimes | `src/hypergraph/find_node_pair_connections.m` |
| Hypergraph efficiency | `src/hypergraph/hypergraph_efficiency.m` |
| Node fragility utility | `src/analysis/compute_fragility.m` |
| Public temporal workflow | `workflows/run_feature_pipeline.m` |
| Synthetic validation | `examples/synthetic_demo.m` |

The four-regime transition layer is retained only as an interface in `src/transition/assemble_transition_matrix.m`; it fails with a descriptive error until the exact missing manuscript functions are supplied.
