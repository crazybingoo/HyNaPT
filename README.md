# HyNaPT

HyNaPT is a MATLAB framework for time-resolved attributed-hypergraph analysis of seizure propagation. This repository contains the privacy-safe method implementation, deterministic synthetic example, aggregate source data, and figure-by-figure plotting code used to support the revised manuscript.

## What is included

- PLV candidate-layer construction using a threshold selected from the elbow of the density-threshold curve.
- Two-node hyperedges from retained PLV pairs and phase-based COC weights for closed three-node hyperedges.
- Six signal- and topology-derived node attributes, with clinical zone labels excluded from the attribute vector.
- Four mutually exclusive transition cases: hyper-direct, hyper-adjacent, hyper-indirect, and hyper-disconnected.
- Row-stochastic transition matrices, isolated-row handling, and adjacent-window temporal fusion.
- Deterministic synthetic data, MATLAB unit tests, and automated privacy checks.
- `Source_Data.xlsx`, containing disclosure-reviewed aggregate statistics and synthetic numerical tests only.
- R scripts for aggregate evidence panels corresponding to Figs. 2–6 and Supplementary Figs. S1–S2.

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

## Aggregate source data and figures

`Source_Data.xlsx` contains cohort-level estimates, confidence intervals, test results, and synthetic boundary tests. It contains no participant rows, clinical labels, channel names, coordinates, linkage keys, or local paths. Each plotting script reads one worksheet and writes PDF, SVG, PNG, and TIFF output under the ignored `results/public_figures` directory.

```powershell
Rscript r_figures/Fig_2/make_Fig_2_aggregate.R
Rscript r_figures/Fig_3/make_Fig_3_aggregate.R
Rscript r_figures/Fig_4/make_Fig_4_aggregate.R
Rscript r_figures/Fig_5/make_Fig_5_aggregate.R
Rscript r_figures/Fig_6/make_Fig_6_aggregate.R
```

The public scripts reproduce the aggregate evidence, not the restricted participant-level points or representative clinical traces in the submission figures. See [figure reproduction](docs/FIGURE_REPRODUCTION.md).

## Data protection

This repository intentionally contains no raw or processed participant recordings, participant-level clinical labels, real or coded participant identifiers, electrode/contact labels, coordinates, dates, institutional identifiers, local clinical paths, or participant-derived rows. Run the privacy audit before every public commit:

```powershell
python tools/privacy_scan.py .
```

See [data access](data/README.md), [security policy](SECURITY.md), and [known limitations](docs/KNOWN_LIMITATIONS.md).

## Citation and license

Citation metadata are provided in [`CITATION.cff`](CITATION.cff). HyNaPT is released under the [BSD 3-Clause License](LICENSE).
