# Flux deposit: Negesse et al. (2025), soil biota and microbial activity under plant invasion

This folder holds the **flux limb** of the analysis: paired invaded and uninvaded measurements
of soil respiration, extracellular enzyme activities, nitrogen transformation rates, microbial
pools and faunal abundances.

| Field | Value |
|---|---|
| Source publication | Negesse, Z., Pan, K., Guadie, A., Justine, M. F., Azene, B., Pandey, B., Wu, X., Sun, X. & Zhang, L. (2025). Plant invasions alter soil biota and microbial activities: a global meta-analysis. *Plant and Soil*, 513(1), 1031-1050. |
| Article DOI | 10.1007/s11104-025-07227-7 |
| Data DOI | 10.5061/dryad.hhmgqnkq5 |
| File used | `Datasets.csv`, 688 rows x 24 columns, 143 KB |
| Licence | Dryad deposits are released under CC0 1.0 |
| Retrieved | 2026-08-01, manual download |
| Bibliography key | `negesse2025invasive` |

## Files

| File | What it is |
|---|---|
| `Datasets.csv` | the deposit itself, **gitignored** under the raw-data convention |
| `README.md` | this file, the canonical record of where the data came from |
| `README-deposit.md` | the depositor's own README, reproduced verbatim |
| `PROVENANCE.md` | the ingestion record, including the clustering diagnosis in full |

## Retrieval

Download from the Dryad landing page for the data DOI above, using a browser. Dryad serves a
proof-of-work challenge to automated clients; do not attempt to circumvent it.

## How the manuscript uses it

The `data-flux` chunk of `01.manuscript/invasion-rate-versus-stock.qmd` reads and classifies
this file at render time. Response variables are assigned to six functional classes before any
model is fitted: soil respiration (the direct carbon flux), carbon-acquiring enzymes,
nutrient-acquiring enzymes, nitrogen transformation rates, microbial pools and faunal abundance.
Effect sizes are recomputed from the reported means, dispersions and sample sizes rather than
taken from the deposit's own `ln (LRR)` column, so that the flux and stock limbs use identical
estimators and the same small-sample correction.

## Traps

1. **The file is not UTF-8.** It reads correctly as `latin1`. Read as UTF-8 the response labels
   are mangled and the Greek beta of beta-glucosidase is lost, so enzyme names are matched by
   pattern rather than by exact string.
2. **There is no complete study identifier.** `Authors` is blank for 581 of 688 rows (84.4%) and
   `Case_studies` is a row index, not a source publication: it runs 1, NA, 2, 3, and yields one
   group per row. Clustering on either produces a degenerate random effect in which every
   observation is its own study, which silently removes the correction for non-independence and
   returns anti-conservative confidence intervals.
3. **The coordinate pair is the usable clustering unit.** `Northing` and `Easting` are populated
   for every row and resolve to 110 distinct sites. Carrying the author string forward within
   each site recovers a named source publication for 99 of the 110.
4. **This changes the result, not merely the intervals.** Under the row-index clustering, soil
   respiration appeared to rest on 2 studies and returned +3.8%, p = 0.54. Under site clustering
   the same 37 observations rest on 14 sites and return +24.3%, p = 0.041. The data never
   changed; the grouping did. Any reanalysis must state its clustering unit.

Full detail in [`PROVENANCE.md`](PROVENANCE.md).
