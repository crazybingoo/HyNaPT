# Known limitations

1. The public repository does not contain participant-level recordings, labels, paths, matrices, or rows. Consequently, participant-level statistical analyses cannot be independently recomputed from public files.
2. Aggregate plotting scripts reproduce the released numeric evidence but not restricted participant points, representative clinical traces, or electrode-level layouts.
3. The current evidence is based on a small single-center cohort of 10 participants with one analyzed seizure per participant; external validation and surgical-outcome endpoints are not available.
4. Model-derived asymmetric transitions do not establish causal propagation.
5. The primary implementation supports the reference sampling rate of 1024 Hz. Other sampling rates require a documented preprocessing and validation step.
6. Indirect-path enumeration is bounded by configurable hop and path limits to prevent combinatorial growth on large dense hypergraphs.
