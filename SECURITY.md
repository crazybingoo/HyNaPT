# Security and clinical-data policy

HyNaPT is research software for analyses involving clinical electrophysiology. Participant privacy takes precedence over convenience.

## Never commit

- Raw or processed participant recordings.
- Clinical zone labels linked to an individual.
- Names, initials, hospital identifiers, record numbers, dates, or local clinical paths.
- Patient-level intermediate matrices, sampled paths, figures, or tables.
- Credentials, private download URLs, or controlled-access tokens.

Only synthetic examples and aggregate, disclosure-reviewed outputs may be considered for public release. If sensitive material is discovered in the current tree or Git history, stop distribution and contact the repository owner. Removing a file in a later commit does not remove it from Git history; history rewriting and credential revocation may be required.
