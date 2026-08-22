# Aggregate results in the current submission

All values below are aggregate-only and correspond to 10 independent participants with one analyzed seizure each.

## Clinical regional concordance

- HyNaPT mean AP: 0.734; 95% CI 0.581–0.867.
- Exact patient-specific permutation-null mean AP: 0.663.
- Mean normalized AP lift: 0.335; 95% CI 0.045–0.609.
- Joint two-sided permutation P: 0.0195; positive raw lift in 8/10 participants.
- Mean AUROC: 0.643; 95% CI 0.491–0.781.
- Mean PZ/NIZ enrichment: 1.494; 95% CI 1.056–2.089.

Regional node activity is descriptive. Mean PZ activity was highest pre-ictally (0.475), while mean SOZ activity increased modestly from pre-ictal (0.181) to ictal (0.212) and post-ictal (0.239). Participant distributions overlap across regions and stages.

## Complementary model evidence

- Diffusion entropy decreased ictally in 8/10 participants in each clinical region; inward sensitivity and directed betweenness were more heterogeneous.
- Adjacent-window ARI increased relative to pre-ictal windows in early, middle, late, and post-ictal stages; the corresponding mean changes were 0.1926, 0.2391, 0.2401, and 0.1592.
- Complete HyNaPT exceeded topology-only adjacent-matrix change by 0.208106 and attribute permutation by 0.016079. These are dynamical contrasts, not regional AP gains.
- Higher-order projection exceeded the same retained pairwise backbone in global efficiency by 0.055467 across stages. This is a representation endpoint, not evidence that COC improves AP.
- Across 18 uncalibrated sensitivity configurations, mean AP ranged from 0.710 to 0.770.
- Argmax path-visit AP was 0.655; top-m values ranged from 0.610 to 0.638. Node agreement ranged from 0.318 to 0.459 and edge Jaccard similarity from 0.198 to 0.339.

The results support conditional regional concordance and model-level representation effects. They do not demonstrate source-zone discovery, causal paths, exact contact recruitment times, external generalization, or clinical utility.
