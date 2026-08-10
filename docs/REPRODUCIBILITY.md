# Reproducibility guide

## Reference environment

- MATLAB R2021b
- Signal Processing Toolbox
- Statistics and Machine Learning Toolbox
- CPU execution; no GPU is required for the synthetic smoke example

## Public reproducibility check

From the repository root:

```matlab
startup
results = synthetic_demo;
tests = runtests('tests');
assertSuccess(tests)
```

The example fixes the random seed to 42 and generates six synthetic channels over five seconds. It should produce three overlapping 3-second windows with a 1-second step.

## Clinical analysis boundary

Clinical recordings are intentionally not part of the public repository. Authorized analysts should load them from controlled storage, construct a de-identified in-memory matrix, and pass that matrix to `run_feature_pipeline`.

## Manuscript-level reproduction status

| Component | Publicly runnable | Requires controlled data | Status |
|---|---:|---:|---|
| Hypergraph construction | Yes | No for synthetic demo | Tested |
| Node-feature extraction | Yes | No for synthetic demo | Tested |
| Temporal feature workflow | Yes | No for synthetic demo | Tested |
| Clinical cohort analysis | No | Yes | Not distributed |
| Four-regime transition model | No | Usually | Historical upload incomplete |
| Manuscript figures | No | Yes | Must be rebuilt as parameterized scripts |

This distinction prevents a smoke example from being misrepresented as reproduction of the clinical claims.
