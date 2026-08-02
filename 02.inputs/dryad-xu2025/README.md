# Stock deposit: He et al. (2025), soil carbon fractions under plant invasion

This folder holds the **stock limb** of the analysis: paired invaded and uninvaded measurements
of eight soil carbon fractions.

| Field | Value |
|---|---|
| Source publication | He, Y., Li, J., Siemann, E., Li, B., Xu, Y. & Wang, Y. (2025). Plant invasion increases soil microbial biomass carbon: meta-analysis and empirical tests. *Global Change Biology*, 31(3), e70109. |
| Article DOI | 10.1111/gcb.70109 |
| Data DOI | 10.5061/dryad.c59zw3rkc |
| File used | `Meta-analysis_Data.xlsx`, 164,065 bytes |
| Licence | Dryad deposits are released under CC0 1.0 |
| Retrieved | 2026-07-30, manual download |
| Bibliography key | `he2025plant` |

## Files

| File | What it is |
|---|---|
| `Meta-analysis_Data.xlsx` | the deposit itself, **gitignored** under the raw-data convention |
| `README.md` | this file, the canonical record of where the data came from |
| `README-deposit.md` | the depositor's own README, reproduced verbatim |
| `PROVENANCE.md` | earlier provenance note, retained for the record |

## The folder name is wrong and is kept anyway

The dataset is **He et al.**, not Xu et al. The directory was named `dryad-xu2025` when the file
was first placed here, and renaming it would change a path the manuscript depends on for no
scientific gain. Cite it as He et al. (2025).

## Retrieval

Download from the Dryad landing page for the data DOI above, using a browser. Dryad serves a
proof-of-work challenge to automated clients, so command-line retrieval fails; the API download
endpoint requires a bearer token and returns `{"error":"Unauthorized"}` without one. Do not
attempt to circumvent the challenge.

## Structure

A single sheet with a two-row header. Columns 1 to 15 carry study metadata. From column 16 the
sheet is eight blocks of 12 columns, one per carbon fraction (TC, SOC, DOC, MBC, POC, MAOC, ROC,
WSOC). Each block carries data source, index, units, soil depth, and paired mean, standard
deviation and sample size for the native and invaded states, followed by a blank separator
column.

## How the manuscript uses it

The `data-stock` chunk of `01.manuscript/invasion-rate-versus-stock.qmd` parses this workbook
directly at render time. There is no intermediate script: the block layout is detected from row
1, the sub-headers in row 2 are verified rather than assumed, and any block whose layout does
not match is skipped. Effect sizes are recomputed from the reported means, dispersions and
sample sizes rather than taken from the deposit's own `lnRR` columns, so that the stock and flux
limbs use identical estimators and the same small-sample correction.

## Traps

1. **Coordinates are unreliable.** Some rows give latitudes beyond 90 degrees, which indicates
   longitude values entered in the latitude field. The coordinate fields are therefore not used
   as moderators.
2. **Habitat labels vary in case and spacing** for the same habitat, so they are collapsed to
   classes by pattern rather than matched exactly.
3. **Species names run words together and carry trailing authorities**, with at least one
   persistent misspelling: *Chromolaena* appears throughout as "Chromolaeo". The manuscript maps
   them explicitly, taxon by taxon, so that every correction stays visible; see the `coverage`
   chunk.
4. **Depth is a range string**, not a number, and is parsed to bounds and a midpoint.
5. **Bulk density is never reported**, which is why concentration observations cannot be
   converted to areal stocks. That absence is a finding of the paper, not an inconvenience.
