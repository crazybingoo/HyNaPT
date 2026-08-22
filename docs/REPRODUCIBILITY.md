# Reproducibility guide

## Reference environment

- MATLAB R2021b
- Signal Processing Toolbox
- Statistics and Machine Learning Toolbox
- R 4.2 or later with `ggplot2`, `readxl`, `patchwork`, and `svglite`

## Public method check

From the repository root:

```matlab
startup
results = synthetic_demo;
tests = runtests('tests');
assertSuccess(tests)
```

The random seed is fixed. The synthetic example exercises elbow selection, hypergraph construction, COC weighting, feature extraction, the four transition cases, and temporal fusion. Unit tests additionally cover exact AP-null enumeration, deterministic cohort resampling, and argmax/top-m path generation.

## Public figure check

Each script under `r_figures` reads `Source_Data.xlsx` and writes to `results/public_figures`. The source workbook contains aggregate estimates only. Public plots therefore verify the numeric summaries and visual encodings without exposing participant-level rows.

## Reproduction matrix

| Component | Publicly runnable | Requires controlled data | Status |
|---|---:|---:|---|
| Synthetic end-to-end method | Yes | No | Tested |
| Density-curve elbow | Yes | No | Tested |
| Phase-based COC | Yes | No | Tested |
| Four-case transition model | Yes | No | Tested on synthetic networks |
| Argmax and stochastic top-m paths | Yes | No | Tested with fixed seeds |
| Exact AP permutation and cohort lift code | Yes | No | Tested with synthetic score/label vectors |
| Aggregate manuscript evidence | Yes | No | Source workbook and R scripts |
| Participant-level statistics | No | Yes | Not distributed |
| Representative clinical traces and paths | No | Yes | Not distributed |
| Independent external validation | No | Yes | Not yet available |

The public aggregate workbook supports verification of reported summaries but cannot reconstruct participant-level tests from first principles. Authorized analysts need the approved controlled environment for that purpose.
