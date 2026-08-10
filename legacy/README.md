# Excluded historical scripts

The original upload included exploratory scripts with hard-coded local clinical paths and participant-specific assumptions. They were removed from the cleaned working tree because they were neither portable nor appropriate for a public repository.

The supported replacement is `workflows/run_feature_pipeline.m`. Manuscript figure scripts should be rebuilt as parameterized functions against controlled-access inputs before any public release.
