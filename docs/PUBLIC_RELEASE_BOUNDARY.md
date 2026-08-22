# Public release boundary for the current manuscript and SI

This repository is aligned with the current manuscript and Supplementary Information at the level that can be released without participant or personal information. The manuscript and SI files themselves are not part of the repository.

## Current submission mapping

| Submission item | Public repository representation | Release boundary |
|---|---|---|
| Main Figs. 1–6 | Method code, synthetic tests, and aggregate source worksheets for Figs. 2–6 | Representative clinical traces, channel-level paths, and participant points are withheld |
| Supplementary Table S1 | `Supp_Table_S1` with the HyNaPT reference and three aggregate comparator rows | No participant rows |
| Supplementary Table S2 | None | Entire table is participant-level and is not distributed |
| Supplementary Fig. S1 | `Supp_Fig_S1` aggregate companion | Participant-level points and decompositions are not distributed |
| Additional boundary analyses | Historical worksheet/script name `Supp_Fig_S2` | Repository-only aggregate analysis; not a figure in the current SI |

## Content that must never be committed

- raw or processed human recordings;
- real, coded, or anonymous case/participant identifiers;
- participant-, seizure-, window-, path-, channel-, electrode-, or contact-level rows;
- clinical labels, coordinates, dates, linkage keys, or local clinical paths;
- manuscript/SI DOCX or PDF files;
- author contact details, ORCIDs, phone numbers, local usernames, or workstation paths.

Aggregate cohort estimates, confidence intervals, test results, counts, and synthetic numerical checks may be released only after disclosure review. Existing citation authorship metadata are maintained separately in `CITATION.cff`; this alignment update adds no personal contact metadata.
