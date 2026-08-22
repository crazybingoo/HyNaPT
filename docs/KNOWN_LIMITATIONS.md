# Known limitations

1. The public repository does not contain participant-level recordings, labels, paths, matrices, or rows. Consequently, participant-level statistical analyses cannot be independently recomputed from public files.
2. Aggregate plotting scripts reproduce the released numeric evidence but not restricted participant points, representative clinical traces, or electrode-level layouts.
3. The current evidence is based on a small single-center cohort of 10 participants with one analyzed seizure per participant; external validation and surgical-outcome endpoints are not available.
4. Model-derived asymmetric transitions do not establish causal propagation.
5. The primary implementation supports the reference sampling rate of 1024 Hz. Other sampling rates require a documented preprocessing and validation step.
6. Indirect-path enumeration is bounded by configurable hop and path limits to prevent combinatorial growth on large dense hypergraphs.
7. The implemented construction is restricted to 2-node hyperedges and closed 3-node hyperedges. Hyperedges with more than three nodes and alternative transition rules have not been evaluated.
8. Node attributes are limited to the implemented signal- and topology-derived features; hyperedge attributes and other continuous vector-valued attributes require new similarity functions and transition rules.
9. The primary temporal fusion weight is fixed. Data-adaptive fusion would require a separate training and validation design.
10. Higher-order projection increased global efficiency relative to the matched pairwise backbone, but this network endpoint is not evidence that COC or closed triplets improve regional AP.
11. Transfer beyond epilepsy remains a methodological prospect and requires application-specific rules, attributes, and validation standards.
