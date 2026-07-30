# Inputs and provenance

Nothing in this folder is raw third-party data. Both files are parameter tables compiled by
hand from the peer-reviewed literature and from standards documents, and every row carries the
source it was read from. No file here is fetched at render time, so the manuscript renders
offline and the numbers cannot move without a visible edit to these files.

## `carbon-parameters.csv`

Long format, one row per parameter per system, so the provenance travels with the value and
Table 2 of the manuscript is a direct print of this file.

| Column | Meaning |
|---|---|
| `system_id` | short key used throughout the analysis |
| `parameter` | parameter name, see the dictionary below |
| `value` | point estimate |
| `sd` | standard deviation on the point estimate, blank where the source reports none |
| `n` | sample size reported by the source, blank where not reported |
| `units` | units of `value` |
| `source_key` | BibTeX key in `04.references/references.bib` |
| `source_note` | table, figure or page the number was read from |
| `tier` | evidence tier, see below |

Parameter dictionary:

| `parameter` | Meaning | Units |
|---|---|---|
| `C_inv` | total ecosystem carbon of the invaded state | Mg C ha-1 |
| `C_nat` | total ecosystem carbon of the uninvaded native reference | Mg C ha-1 |
| `C_deg` | total ecosystem carbon of the degraded or immediately post-clearance state | Mg C ha-1 |
| `AGB_inv` | aboveground biomass carbon held by the invader itself | Mg C ha-1 |
| `K_inv` | asymptote of the invaded trajectory if the invader is left in place | Mg C ha-1 |
| `r_inv` | relaxation rate of the invaded trajectory toward `K_inv` | yr-1 |
| `r_nat` | relaxation rate of the native trajectory toward `C_nat` after removal | yr-1 |
| `f_rel` | fraction of invader aboveground carbon released to atmosphere within one year of clearing | dimensionless |
| `dSOC` | soil organic carbon lost as a direct consequence of the removal operation | Mg C ha-1 |
| `E_op` | operational emissions of the removal, expressed as carbon | Mg C ha-1 |

Evidence tiers, which are reported alongside every result:

- **A** measured in the cited source for this system, with a dispersion estimate.
- **B** measured in the cited source for this system, point estimate only.
- **C** derived by arithmetic from values in the cited source; the derivation is shown in the
  manuscript code, not hidden here.
- **D** transferred from a different system or a global default because nothing system-specific
  exists. Every tier D parameter is a stated limitation in the manuscript.

## `standards-audit.csv`

One row per carbon standard per assessment criterion, coded from the standard's own current
requirement documents. `evidence` quotes or paraphrases the operative clause and `source_url`
gives the document fetched. Coding is `0` absent, `1` permitted or implied, `2` explicit.
The audit date is recorded in the file so a future reader knows which version was read.
