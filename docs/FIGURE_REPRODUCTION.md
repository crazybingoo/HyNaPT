# Aggregate figure reproduction

## Scope

The public source workbook contains cohort-level means, confidence intervals, exact test results, and synthetic boundary checks. Participant rows and representative clinical data are deliberately absent. The public figures therefore reproduce the aggregate evidence layer of the revised manuscript.

## Figure map

| Script | Workbook sheet | Evidence reproduced |
|---|---|---|
| `r_figures/Fig_2/make_Fig_2_aggregate.R` | `Fig_2` | uncalibrated HyNaPT regional ranking, paired gains, AUROC, enrichment |
| `r_figures/Fig_3/make_Fig_3_aggregate.R` | `Fig_3` | stage-related transition concentration by clinical region |
| `r_figures/Fig_4/make_Fig_4_aggregate.R` | `Fig_4` | adjacent-window ARI and module-entropy changes |
| `r_figures/Fig_5/make_Fig_5_aggregate.R` | `Fig_5` | attribute/topology contrasts and hypergraph-projection efficiency |
| `r_figures/Fig_6/make_Fig_6_aggregate.R` | `Fig_6` | parameter sensitivity and jump-strategy stability |
| `r_figures/Supplementary_Fig_S1/make_Supplementary_Fig_S1_aggregate.R` | `Supp_Fig_S1` | aggregate sensitivity configuration summary |
| `r_figures/Supplementary_Fig_S2/make_Supplementary_Fig_S2_aggregate.R` | `Supp_Fig_S2` | aggregate null and boundary analyses |

## Visual conventions

Scripts share an Arial-based 8-point theme and a purple, teal, grey, and muted-pink palette to remain visually compatible with the revised manuscript. Panel labels are bold and consistently positioned. PDF and SVG are the primary vector outputs; PNG and TIFF are exported at 300 dpi.
