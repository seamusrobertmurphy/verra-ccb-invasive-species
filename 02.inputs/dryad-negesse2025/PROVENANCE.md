# Provenance: Negesse et al. (2025) soil biota and microbial activity deposit

| Field | Value |
|---|---|
| Source publication | Negesse, Z., Pan, K., Guadie, A., Justine, M. F., Azene, B., Pandey, B., Wu, X., Sun, X., & Zhang, L. (2025). Plant invasions alter soil biota and microbial activities: a global meta-analysis. *Plant and Soil*, 513(1), 1031-1050. |
| Article DOI | 10.1007/s11104-025-07227-7 |
| Data DOI | 10.5061/dryad.hhmgqnkq5 |
| Retrieved | 2026-08-01, manual download |
| File used | `Datasets.csv`, 688 rows x 24 columns, 143 KB |
| Licence | Dryad deposits are released under CC0 1.0 |

`Datasets.csv` is gitignored under the repository's raw-data convention. Retrieve it from the
Dryad landing page for the data DOI above. Dryad serves a proof-of-work challenge to automated
clients, so the download is performed in a browser by hand; do not attempt to circumvent it.

## What this repository uses it for

The flux limb of the rate-versus-stock analysis. Soil respiration is the direct carbon flux; the
enzyme, microbial pool and faunal classes are evidence on the mechanism. Effect sizes are
recomputed from the reported means, dispersions and sample sizes by
`02.inputs/scripts/08-flux.R`, not taken from the deposit's own `ln (LRR)` column, so that the
flux and stock limbs use identical estimators and the same small-sample correction.

## Traps recorded during ingestion

1. **The file is not UTF-8.** It reads correctly as `latin1`. Read as UTF-8 the response labels
   are mangled and the Greek beta of beta-glucosidase is lost, so enzyme names are matched by
   pattern rather than by exact string.
2. **There is no complete study identifier.** `Authors` is blank for 581 of 688 rows (84.4%) and
   `Case_studies` is a row index, not a source publication: it runs 1, NA, 2, 3, ... and yields
   one group per row. Clustering on either produces a degenerate random effect in which every
   observation is its own study, which silently removes the correction for non-independence and
   returns anti-conservative confidence intervals.
3. **The coordinate pair is the usable clustering unit.** `Northing` and `Easting` are populated
   for every row and resolve to 110 distinct sites. Carrying the author string forward within
   each site recovers a named source publication for 99 of the 110.
4. **The degrees-of-freedom trap this closes.** Under the row-index clustering soil respiration
   appeared to rest on 2 studies and returned +3.8%, p = 0.54. Under site clustering the same 37
   observations rest on 14 sites and return +24.3%, p = 0.041. The estimate changed because the
   grouping changed, not because the data did. Any reanalysis must state its clustering unit.
