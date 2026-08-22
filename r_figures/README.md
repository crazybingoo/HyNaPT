# Public aggregate plotting code

Each folder contains a standalone R script for one revised manuscript figure. Scripts read aggregate-only worksheets from `Source_Data.xlsx` and export PDF, SVG, PNG, and TIFF files under `results/public_figures`. The workbook also contains the aggregate rows for Supplementary Table S1.

`Supplementary_Fig_S1` creates a privacy-safe aggregate companion to the current SI figure; it does not reproduce the withheld participant-level points. `Supplementary_Fig_S2` is retained as a historical technical folder for additional repository-only boundary analyses and is not a figure in the current SI.

The shared theme uses Arial 8-point text, bold panel tags, and the purple/teal/grey/muted-pink palette used in the revised manuscript. Public plots do not recreate restricted participant points, representative clinical traces, or electrode-level layouts.

Run any script from any working directory, for example:

```powershell
Rscript r_figures/Fig_2/make_Fig_2_aggregate.R
```
