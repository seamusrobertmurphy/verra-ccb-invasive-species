# Inputs

Everything the manuscript reads. Nothing here is fetched at render time, so the document builds
offline and no number can move without a visible edit to a file in this folder.

## Live inputs

| Path | What it is | Read by |
|---|---|---|
| [`dryad-xu2025/`](dryad-xu2025/README.md) | **stock limb.** He et al. (2025), eight soil carbon fractions, paired invaded and uninvaded. Dryad doi:10.5061/dryad.c59zw3rkc | `data-stock` chunk |
| [`dryad-negesse2025/`](dryad-negesse2025/README.md) | **flux limb.** Negesse et al. (2025), soil respiration, enzymes, microbial pools, fauna. Dryad doi:10.5061/dryad.hhmgqnkq5 | `data-flux` chunk |
| `rate-evidence.csv` | **rate compilation.** Published carbon accumulation rates with paired uninvaded comparisons, compiled by hand | `setup` chunk, tabulated as Table 1 |

Each Dryad folder carries its own `README.md` recording the source publication, the data DOI,
the licence, how the file was retrieved, and the traps found while ingesting it. Read those
before touching the data.

**Raw third-party data is gitignored.** `Meta-analysis_Data.xlsx` and `Datasets.csv` are not in
the repository; the folder READMEs say how to retrieve them. Both deposits sit behind Dryad's
proof-of-work bot challenge, so both must be downloaded through a browser by hand. Do not
attempt to circumvent the challenge.

## `rate-evidence.csv`

One row per published estimate. Entries are reproduced exactly as published, without
recalculation, and are **tabulated rather than pooled**: four sources cannot support a pooled
estimate, and the entries differ in quantity and in units.

| Column | Meaning |
|---|---|
| `study` | short citation key |
| `invader` | the invading taxon |
| `trophic_level` | invader trophic level, following Peltzer et al. (2010) |
| `quantity` | what was measured, verbatim in the source's own terms |
| `invaded`, `invaded_err` | invaded value and its dispersion, blank where the source reports none |
| `uninvaded`, `uninvaded_err` | the paired uninvaded comparison |
| `err_type` | `se`, `sd` or `range`; a reported range is one estimate, plotted as an interval |
| `ratio` | invaded divided by uninvaded |

A source was admitted only where the uninvaded comparison is explicit, which excludes the large
literature reporting invaded productivity without a control.

## Archive

`archive/` holds material from the superseded version of this paper, which framed the study
around carbon parity across seven invaded systems and an audit of six voluntary carbon
standards. None of it is read by the current manuscript. It is kept because the standards audit
and the parameter table remain usable evidence for a separate paper.

| Path | What it was |
|---|---|
| `archive/scripts/` | the eight-script pipeline, now superseded: every stage lives in the manuscript as a visible R chunk |
| `archive/carbon-parameters.csv` | per-system carbon parameters with evidence tiers A to D |
| `archive/standards-audit.csv` | six voluntary standards plus one compliance scheme, coded against their own requirement documents |
| `archive/counterfactual-classes.csv`, `archive/systems.csv` | the seven-system framing |
| `archive/dryad-he2025-failed-download/` | two 56-byte files containing a Dryad authorisation error, kept only so the failure is not repeated |
