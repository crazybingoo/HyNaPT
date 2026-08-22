# Statistical analysis

## Primary regional concordance

After known SOZ initialization, uncalibrated HyNaPT scores rank PZ above NIZ contacts. SOZ contacts are excluded from the target set. For each participant, scores are held fixed while PZ/NIZ labels are enumerated exactly, preserving the number of positives and negatives. Average precision (AP) is the primary endpoint.

The prespecified participant-level effect is

```text
normalized AP lift = (observed AP - exact-null mean AP) /
                     (1 - exact-null mean AP).
```

The participant is the independent unit. The cohort statistic is the mean normalized lift. A 10,000-resample participant bootstrap gives the 95% confidence interval. The two-sided cohort P value uses 100,000 joint draws from the exact participant null distributions. This test controls for each participant's PZ prevalence and finite target-set size.

`evaluate_regional_concordance.m` implements the exact participant null, and `summarize_regional_concordance.m` implements the participant bootstrap and joint-null calculation for authorized in-memory score and label vectors. No participant vectors are shipped in this repository.

## Benchmark and complementary analyses

Pairwise PLV, topology-only, and attribute-permutation controls use the same participants, channels, stages, and endpoint. Paired differences use participant-bootstrap 95% confidence intervals, exact two-sided sign-flip tests, and Benjamini-Hochberg adjustment for the three controls. These are the three comparator rows retained in the current Supplementary Table S1.

Figs. 3–5 use participant-level paired effects, 10,000-resample bootstrap confidence intervals, exact two-sided sign-flip tests, and Benjamini-Hochberg adjustment within metric families. The sensitivity grid reports participant-bootstrap confidence intervals around uncalibrated AP. Descriptive regional node activity in Fig. 2(e) is reported as participant means and standard deviations without an inferential regional hierarchy claim.
