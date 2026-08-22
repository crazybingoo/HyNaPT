# Data access and input schema

No participant-level data are distributed in this repository.

## Public files

- `Source_Data.xlsx`: disclosure-reviewed aggregate statistics and synthetic numerical tests.
- `examples/synthetic_demo.m`: deterministic synthetic signals generated in memory.

The workbook contains no participant rows or coded participant identifiers. It is not a substitute for the restricted raw dataset.

## Restricted inputs

Raw and processed SEEG recordings, clinical annotations, electrode/contact labels, coordinates, dates, linkage keys, participant-level matrices, and participant-level result rows must remain in approved controlled storage. Access is governed by the originating ethics, consent, institutional, and clinical data-use conditions; this repository does not create a new access route. A qualified researcher request would require institutional approval, an appropriate data-use agreement, secure storage, and a prohibition on re-identification before any controlled transfer could be considered.

## Expected in-memory signal input

- numeric matrix with shape `n_channels x n_samples`;
- finite preprocessed values;
- reference sampling rate of 1024 Hz;
- no identifiers embedded in variable names or paths committed to Git.

Authorized analysts should load restricted data outside the repository and pass only an in-memory numeric matrix to `run_feature_pipeline`.
