# Experiment workflow aligned with the current manuscript

## Analysis unit and stages

The manuscript analyzes one seizure from each of 10 participants and treats the participant as the independent unit. The primary signal workflow uses 3-second windows advanced by 1 second. Patient-level analyses for Figs. 3–5 use at most 36 consecutive windows per stage. The public repository does not distribute those participant windows or rows.

## Model construction

1. Compute windowed pairwise PLV matrices.
2. Select one threshold from the elbow of the across-window mean density-threshold curve on the grid `0:0.0025:1` and apply it to all windows in the run.
3. Treat retained pairs as 2-node hyperedges. Treat closed triplets in the retained-pair graph as candidate 3-node hyperedges and weight them by phase-based COC.
4. Assemble six node attributes: hyperdegree, mean PLV, log high-frequency power, log maximum absolute amplitude, log mean absolute amplitude, and phase-amplitude coupling.
5. Compute non-negative ordered-pair compatibility under the mutually exclusive hyper-direct, hyper-adjacent, hyper-indirect, and hyper-disconnected cases.
6. Set invalid/negative scores and the diagonal to zero, repair empty source rows with uniform off-diagonal mass, and normalize each source row.
7. Fuse consecutive transition matrices by the prespecified convex weight. The primary weight is 0.5; 0.25 and 0.75 are sensitivity settings.

## Path generation and derived evidence

Known source-zone contacts initialize the representative path process. PZ/NIZ labels do not enter attributes, candidate selection, transition assembly, or path generation. Deterministic paths select the maximum-probability next node. Stochastic top-m paths retain 10%, 25%, 50%, or 100% of non-zero destinations, draw 100 candidates per step in proportion to their transition probabilities, and use the modal draw as the next node. The reported stability analysis uses 20 fixed random seeds.

Regional node activity in Fig. 2(e) is the stage-specific proportion of destinations from source-zone-initialized paths that are assigned post hoc to SOZ, PZ, or NIZ. It is not SEEG amplitude, edge weight, transition probability, or a static region proportion.

Complementary analyses summarize outgoing-transition entropy, inward sensitivity, directed betweenness, three transition-profile modules, adjacent-window adjusted Rand index, attribute mapping contrasts, and higher-order-projection efficiency. These endpoints describe different model properties and are not substitutes for the regional-ranking endpoint.

## Sensitivity boundary

The frozen one-factor-at-a-time grid varies the pairwise candidate metric, exact retained-pair fraction, window/step setting, temporal fusion weight, MAD bandwidth, and higher-order weighting mode. PLV or 4–80-Hz MSC ranks pairwise candidates; COC weights closed triplets. Exact retained fractions are sensitivity settings only and do not replace the primary elbow rule.
