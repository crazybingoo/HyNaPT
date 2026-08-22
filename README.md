# HyNaPT

HyNaPT is a MATLAB framework for time-resolved attributed-hypergraph analysis of seizure propagation. This repository contains the privacy-safe method implementation, deterministic synthetic example, aggregate source data, and figure-by-figure plotting code used to support the revised manuscript.

## What is included

- PLV candidate-layer construction using a threshold selected from the elbow of the density-threshold curve.
- Two-node hyperedges from retained PLV pairs and phase-based COC weights for closed three-node hyperedges.
- Six signal- and topology-derived node attributes, with clinical zone labels excluded from the attribute vector.
- Four mutually exclusive transition cases: hyper-direct, hyper-adjacent, hyper-indirect, and hyper-disconnected.
- Row-stochastic transition matrices, isolated-row handling, and adjacent-window temporal fusion.
- Deterministic argmax and stochastic top-m transition-path generation.
- Exact within-unit, label-count-preserving AP permutation analysis and cohort-level normalized-lift summaries.
- Deterministic synthetic data, MATLAB unit tests, and automated privacy checks.
- `Source_Data.xlsx`, containing disclosure-reviewed aggregate statistics and synthetic numerical tests only.
- R scripts for aggregate evidence panels corresponding to Figs. 2–6, a privacy-safe aggregate companion to Supplementary Fig. S1, and repository-only boundary analyses, plus aggregate Supplementary Table S1 values.

## Repository layout

```text
HyNaPT/
├── src/                  # Feature, hypergraph, transition, and analysis code
├── workflows/            # Supported end-to-end public workflow
├── examples/             # Deterministic synthetic example
├── tests/                # MATLAB unit and numerical-boundary tests
├── r_figures/            # Aggregate figure-by-figure plotting code
├── docs/                 # Method, data, and reproducibility documentation
├── data/                 # Input schema and access-boundary documentation only
├── results/              # Generated outputs; ignored by Git
├── tools/                # Privacy audit
└── Source_Data.xlsx      # Aggregate-only public source data
```

## Method in one paragraph

Signals are divided into 3-second windows advanced in 1-second steps. A single PLV threshold is selected from the elbow of the mean density-threshold curve and applied consistently across the analyzed windows. Retained PLV pairs define two-node hyperedges, and closed triplets are weighted by phase-based COC. Node attributes comprise hyperdegree, mean PLV, log high-frequency power, log maximum and mean absolute amplitude, and phase-amplitude coupling. The four topological cases assign non-negative compatibility scores to ordered node pairs; scores are normalized by source row, and consecutive matrices are fused by a convex combination. Fixed retained-pair fractions of 40%, 50%, and 60% are analysis variants used only for matched-density sensitivity checks, not the primary threshold rule.

PLV or 4–80-Hz magnitude-squared coherence (MSC) ranks pairwise candidates in sensitivity analyses. COC is a different quantity: it weights closed three-node phase configurations. See [method principles](docs/METHOD_PRINCIPLES.md).

## Requirements

- MATLAB R2021b
- Signal Processing Toolbox
- Statistics and Machine Learning Toolbox
- R 4.2 or later for public plotting scripts
- R packages: `ggplot2`, `readxl`, `patchwork`, and `svglite`

## Quick start

```matlab
startup
results = synthetic_demo;
tests = runtests('tests');
assertSuccess(tests)
```

The example fixes the random seed and generates synthetic signals. It does not download or read clinical data.

To analyze an authorized in-memory signal matrix `X` with shape `channels x samples`:

```matlab
startup
cfg = struct('sampleRate', 1024, 'windowSeconds', 3, ...
    'stepSeconds', 1, 'alpha', 0.5);
results = run_feature_pipeline(X, cfg);
```

Clinical labels are not part of the node-attribute vector. If a downstream experiment uses a known source zone for initialization, keep the labels outside the public repository and do not reuse evaluation labels as model inputs.

The public analysis helpers implement the manuscript's label-blind evaluation boundary. Remove source-zone contacts before calling `evaluate_regional_concordance`, keep scores fixed, and provide only the binary propagation-zone versus non-involved-zone target labels:

```matlab
patient = evaluate_regional_concordance(scores, labels);
cohort = summarize_regional_concordance(scoreCells, labelCells);
```

For path-strategy checks, `CandidateFraction = 0` gives deterministic argmax; positive fractions retain the top-m non-zero destinations and advance to the modal result of probability-weighted draws:

```matlab
path = generate_transition_path(Q, sourceNode, ...
    'Steps', 10, 'CandidateFraction', 0.25, ...
    'NumSamples', 100, 'Seed', 1);
```

## Aggregate source data and figures

`Source_Data.xlsx` contains cohort-level estimates, confidence intervals, test results, and synthetic boundary tests. Fig. 2 includes aggregate regional node activity, benchmark AP, normalized AP lift against the exact within-participant null, AUROC, and enrichment. `Supp_Table_S1` mirrors the four aggregate model rows in the current Supplementary Table S1. The patient-level rows in Supplementary Table S2 and the patient-level points in Supplementary Fig. S1 are not distributed; `Supp_Fig_S1` is an aggregate companion only. The historically named `Supp_Fig_S2` worksheet contains additional repository-only boundary analyses and is not a figure in the current SI. The workbook contains no participant-level rows, clinical labels, channel names, coordinates, linkage keys, or local paths. Each plotting script reads one worksheet and writes PDF, SVG, PNG, and TIFF output under the ignored `results/public_figures` directory.

```powershell
Rscript r_figures/Fig_2/make_Fig_2_aggregate.R
Rscript r_figures/Fig_3/make_Fig_3_aggregate.R
Rscript r_figures/Fig_4/make_Fig_4_aggregate.R
Rscript r_figures/Fig_5/make_Fig_5_aggregate.R
Rscript r_figures/Fig_6/make_Fig_6_aggregate.R
```

The public scripts reproduce or accompany the aggregate evidence; they do not reproduce restricted participant-level points, rows, or representative clinical traces in the submission figures. See [figure reproduction](docs/FIGURE_REPRODUCTION.md) and the [public release boundary](docs/PUBLIC_RELEASE_BOUNDARY.md).

## Current aggregate result snapshot

In the 10-participant, one-seizure-per-participant analysis, mean AP was 0.734 (95% CI 0.581–0.867), compared with a patient-specific exact-null mean of 0.663. Mean normalized AP lift was 0.335 (95% CI 0.045–0.609; joint two-sided permutation P = 0.0195), with positive raw lift in 8 of 10 participants. Mean AUROC was 0.643 and mean PZ/NIZ enrichment was 1.494. These are conditional regional-concordance results after known source-zone initialization; they do not test source-zone discovery, electrode recruitment timing, causal propagation, external validation, or clinical decision benefit.

See [experiment workflow](docs/EXPERIMENT_WORKFLOW.md), [statistical analysis](docs/STATISTICAL_ANALYSIS.md), [result snapshot](docs/RESULTS_SNAPSHOT.md), and [known limitations](docs/KNOWN_LIMITATIONS.md).

## Data protection

This repository intentionally contains no raw or processed participant recordings, participant-level clinical labels, real or coded participant identifiers, electrode/contact labels, coordinates, dates, institutional identifiers, local clinical paths, or participant-level rows. Manuscript/SI files and personal contact metadata are also excluded. Run the privacy audit before every public commit:

```powershell
python tools/privacy_scan.py .
```

See [data access](data/README.md), [security policy](SECURITY.md), and [known limitations](docs/KNOWN_LIMITATIONS.md).

## Citation and license

Citation metadata are provided in [`CITATION.cff`](CITATION.cff). HyNaPT is released under the [BSD 3-Clause License](LICENSE).
