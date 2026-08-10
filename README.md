# HyNaPT

Research code for **HyNaPT**, a MATLAB framework for time-resolved attributed-hypergraph analysis of seizure propagation.

> **Repository status.** This repository is being prepared for a revised manuscript. The public, non-clinical feature and hypergraph layers are runnable and tested. The historical upload did not contain the complete transition-rule implementation or the external COC routine; these gaps are explicitly documented rather than silently replaced with a different algorithm.

## What is included

- Construction of pair, triangle, and four-node hyperedges from multichannel signals.
- Hypergraph topology, connectivity, efficiency, and node-degree utilities.
- PLV, HFO power, PAC, amplitude, path-length, and Gaussian-kernel node features.
- A path-independent temporal feature workflow.
- A deterministic synthetic example that contains no clinical or participant data.
- MATLAB unit tests and automated privacy checks.

## Repository layout

```text
HyNaPT/
├── src/
│   ├── analysis/        # Downstream graph and clustering metrics
│   ├── features/        # Signal and node-attribute extraction
│   ├── hypergraph/      # Hypergraph construction and topology
│   ├── transition/      # Historical transition assembly interface
│   └── utils/           # Windowing and normalization helpers
├── workflows/           # Supported path-independent workflows
├── examples/            # Synthetic, non-clinical examples
├── tests/               # MATLAB unit tests
├── config/              # De-identified configuration builders
├── data/                # Data-access and schema documentation only
├── docs/                # Reproducibility and method-code mapping
├── legacy/              # Documentation for excluded historical scripts
├── results/             # Generated outputs are ignored by Git
└── tools/               # Repository privacy checks
```

## Requirements

- MATLAB R2021b (reference environment)
- Signal Processing Toolbox
- Statistics and Machine Learning Toolbox

The reference analysis uses signals sampled at **1024 Hz**, 3-second windows, and a 1-second step. The current feature functions enforce the reference sampling rate rather than silently changing the analysis.

## Quick start

Clone the repository, start MATLAB in the repository root, and run:

```matlab
startup
results = synthetic_demo;
```

Expected console output includes the number of synthetic channels, temporal windows, hyperedges, and the node-similarity matrix size. No external data are downloaded or read.

Run the tests with:

```matlab
startup
results = runtests('tests');
assertSuccess(results)
```

## Using your own authorized data

Input signals must be a finite numeric matrix with shape `channels x samples`. Keep all participant-level data outside the Git repository. A supported public workflow is:

```matlab
startup
cfg = struct( ...
    'sampleRate', 1024, ...
    'windowSeconds', 3, ...
    'stepSeconds', 1, ...
    'zonePrior', zeros(size(X, 1), 1));
results = run_feature_pipeline(X, cfg);
```

Clinical zone priors are optional in this workflow. For an independent validation experiment, use zeros or non-label features so that clinical labels are not simultaneously used as model inputs and validation targets.

## Data protection

This repository intentionally contains **no participant-level SEEG, clinical labels, patient identifiers, local clinical paths, or patient-derived result files**. Raw and processed clinical data must remain in an approved controlled-access environment. See [data/README.md](data/README.md) and [SECURITY.md](SECURITY.md).

## Reproducibility scope

- The synthetic demo and public feature/hypergraph layers are reproducible from this repository.
- Full manuscript-figure reproduction requires controlled-access clinical inputs.
- The manuscript-compatible transition layer cannot yet be claimed as independently reproducible from the historical public upload because required transition functions and the COC dependency were absent.
- No substitute transition formula has been invented in this cleanup.

See [docs/REPRODUCIBILITY.md](docs/REPRODUCIBILITY.md), [docs/METHOD_CODE_MAP.md](docs/METHOD_CODE_MAP.md), and [docs/KNOWN_LIMITATIONS.md](docs/KNOWN_LIMITATIONS.md).

## Citation

Citation metadata are provided in [`CITATION.cff`](CITATION.cff). The manuscript is under revision; update the DOI, version, and release archive after acceptance.

## License

HyNaPT is released under the [BSD 3-Clause License](LICENSE). This permissive open-source license allows use, modification, and redistribution while requiring preservation of the copyright and license notice and prohibiting unauthorized endorsement by the authors or contributors.
