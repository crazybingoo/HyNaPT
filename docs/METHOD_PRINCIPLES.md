# Method principles

## 1. Temporal construction

Let `X_t` denote the multichannel signal in window `t`. The reference workflow uses 3-second windows, a 1-second step, and a sampling rate of 1024 Hz. Pairwise PLV matrices are computed for all windows. For a threshold grid from 0 to 1, each threshold is mapped to the mean retained-pair density across windows. The primary threshold is the maximum-distance-to-chord elbow of this density-threshold curve and is applied consistently to every window in the run.

Exact retained fractions are not the primary construction rule. Fractions of 40%, 50%, and 60% are used only to form density-matched sensitivity variants.

## 2. Hypergraph and higher-order weight

Retained PLV pairs define two-node hyperedges. Every fully closed triangle in the retained pair layer defines a candidate three-node hyperedge. Its phase-based COC weight is computed from the circular-correlation matrix `R` of the three instantaneous phase series. If `p_i` are the eigenvalues of `R` normalized to sum to one, then

```text
COC = 1 + sum_i p_i log2(p_i) / log2(C),
```

where `C` is the number of nodes in the hyperedge. The implementation clips only numerical negative eigenvalues and returns a value in `[0, 1]`.

MSC and COC are not interchangeable. PLV or 4–80-Hz MSC can rank pairwise candidates in the sensitivity grid; COC weights the retained closed triplets.

## 3. Node attributes

For every window and node, the attribute vector contains:

1. hyperdegree;
2. mean PLV;
3. log high-frequency power in 30–80 Hz;
4. log maximum absolute amplitude;
5. log mean absolute amplitude; and
6. phase-amplitude coupling between 4–8-Hz phase and 30–80-Hz amplitude.

Columns are normalized before Gaussian-kernel similarity is computed. Clinical zone labels are excluded from this vector. A known source-zone label may initialize a separate propagation experiment, but evaluation labels must not enter feature extraction or transition assembly.

## 4. Four transition cases

Each ordered pair of distinct nodes is assigned to exactly one topological case. The implementation first constructs a non-negative compatibility score `w_uv`, fixes the diagonal at zero, and then computes

```text
P_uv = w_uv / sum_(k != u) w_uk.
```

- **Hyper-direct:** the nodes share at least one hyperedge. Their score is attribute similarity multiplied by the summed shared-hyperedge support.
- **Hyper-adjacent:** the nodes lie in distinct hyperedges that share at least one node. Their score combines source-node degree decay, attribute similarity, and the weight between adjacent hyperedges.
- **Hyper-indirect:** the incident hyperedges are connected only through intermediate hyperedges. Compatibility contributions are products along valid simple support paths and are summed before row normalization. Products discount weak links and longer paths.
- **Hyper-disconnected:** no direct or indirect hyperedge path connects the pair. A weak non-zero score depends on attribute similarity and `1 - exp(-PLV)`, scaled by mean hyperdegree.

Non-finite and negative scores are set to zero. A row with no positive off-diagonal support receives equal mass over the other nodes. This makes every nontrivial row stochastic while retaining a zero diagonal.

## 5. Temporal fusion and interpretation

For consecutive transition matrices,

```text
Q_t = (1 - alpha) P_t + alpha P_(t+1),  0 <= alpha <= 1,
```

followed by the same row-normalization safeguard. Matrix asymmetry represents model-derived transition direction. It does not establish causal propagation or a separately validated directed-hypergraph reconstruction.

The primary analysis uses `alpha = 0.5`; values 0.25 and 0.75 are prespecified sensitivity settings. The fusion is a specified convex combination, not a fitted dynamical process.

## 6. Path generation and clinical-label boundary

Known SOZ contacts may initialize a transition path. At each step, deterministic argmax selects the largest outgoing transition probability. In stochastic top-m analysis, a fixed fraction of non-zero destinations is retained, 100 targets are drawn in proportion to their transition probabilities, and the modal draw defines the next transition. PZ/NIZ labels remain outside path generation and are introduced only after scores or destinations have been fixed.

Regional node activity is the post hoc fraction of SOZ-initialized path destinations falling in SOZ, PZ, or NIZ. Regional concordance instead ranks fixed uncalibrated scores for PZ versus NIZ contacts after excluding SOZ contacts. These quantities are not interchangeable.
