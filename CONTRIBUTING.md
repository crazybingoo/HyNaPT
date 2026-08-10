# Contributing

1. Do not add participant-level data or identifiers.
2. Create a focused branch and keep scientific changes separate from formatting changes.
3. Add or update a MATLAB unit test for behavioral changes.
4. Run `python tools/privacy_scan.py .` and the MATLAB test suite before opening a pull request.
5. Document changes that alter thresholds, feature definitions, random seeds, or expected outputs.

Scientific changes must describe whether they preserve the manuscript method or introduce a new analysis variant.
