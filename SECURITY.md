# Security and clinical-data policy

Participant privacy takes precedence over convenience.

## Never commit

- raw or processed participant recordings;
- clinical labels or participant-level rows;
- names, initials, record numbers, dates, institutional identifiers, or linkage keys;
- real or coded participant identifiers;
- electrode/contact labels, coordinates, or clinical images;
- participant-derived matrices, paths, figures, or tables;
- absolute local paths, credentials, tokens, or private URLs.

Only synthetic examples and aggregate outputs that have passed disclosure review may be public. `Source_Data.xlsx` is the sole tracked spreadsheet exception; all other spreadsheet and delimited-data files are ignored by default.

Before every public commit, run:

```powershell
python tools/privacy_scan.py .
```

If sensitive material is found in the working tree or Git history, stop distribution. Deleting it in a later commit does not remove it from history; repository history may need to be rewritten and any exposed credentials revoked.
