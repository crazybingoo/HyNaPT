# Data access and input schema

No participant data are distributed in this repository.

## Expected in-memory input

- Variable: a numeric signal matrix such as `X`.
- Shape: `n_channels x n_samples`.
- Reference sampling rate: 1024 Hz.
- Values: finite, preprocessed SEEG samples.

Participant-level recordings, channel labels, clinical annotations, and derived matrices must remain in the institution's approved controlled-access storage. Users with legitimate access should load data outside the repository and pass only an in-memory matrix to the public workflow.

For public testing, use `examples/synthetic_demo.m`, which generates deterministic synthetic signals and contains no clinical information.
