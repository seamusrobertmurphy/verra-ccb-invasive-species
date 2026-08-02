# verra-ccb-invasive-species

**Biological invasion increases carbon sequestration rates but not carbon stocks.**

Status: **submission ready.** Sole-authored. Target venue *Global Change Biology*, Research
Article, guidelines verified against the live pages on 2026-07-30.

**The master is [`01.manuscript/invasion-rate-versus-stock.qmd`](01.manuscript/invasion-rate-versus-stock.qmd).**
Edit it, not the renders. Every number in the prose is an inline R expression and every table
and figure is generated at render time, so prose and results cannot drift.
Build: `cd 01.manuscript && quarto render invasion-rate-versus-stock.qmd --to docx`.

Superseded drafts are in `01.manuscript/archive/`.

## Read in this order

1. [`CLAUDE.md`](CLAUDE.md) — conventions, the terminology rule, the corrections already forced.
2. [`05.tasks/STUDY-DESIGN-2026-07-31.md`](05.tasks/STUDY-DESIGN-2026-07-31.md) — the four-part
   design and why the paper is framed this way.
3. [`02.inputs/README-data.md`](02.inputs/README-data.md) — input tables and evidence tiers.
4. [`05.tasks/EVIDENCE-BASE-2026-07-30.md`](05.tasks/EVIDENCE-BASE-2026-07-30.md) — the
   quote-backed carbon standards evidence.

## The argument

Whether invasion increases ecosystem carbon is contested. The contest is largely artefactual:
two different quantities are both reported as "sequestration". Invasion raises the **rate** of
carbon accumulation substantially and consistently. It does not reliably raise the **stock**.

These correspond to the two methods the IPCC calls equally valid, the gain-loss and
stock-difference methods, and on invaded land they disagree. Carbon crediting rewards evidence
of rate while paying for durable stock, which is a systematic source of over-crediting and a
route to the bio-perversity that Lindenmayer et al. identified.

## Principal results

| Finding | Value |
|---|---|
| Soil organic carbon, all observations | +20.4%, 95% CI -4.6 to +52.0, not significant |
| Same, observations weighted equally | +6.8%, so the estimate is not robust |
| **Soil organic carbon, areal stocks only** | **-0.8%, 95% CI -15.7 to +16.7** |
| Soil organic carbon, concentrations only | +25.0%, 95% CI -4.7 to +63.9 |
| Microbial biomass carbon | +30.1%, significant |
| Particulate organic carbon | -36.4%, significant |
| Wetland and coastal | +140.0% significant; forest +3.5% and grassland +11.0%, neither significant |
| Depth | +22.0% at 0-10 cm, -17.2% below 20 cm |

**The sharpest result is internal to one study.** Pati et al. measured both quantities on the
same plots: the biomass stock differs 1.3-fold under invasion while the sequestration rate
differs 11.3-fold.

**The pattern is not confined to plants.** Invasive rats on 18 New Zealand islands raised live
plant biomass carbon 104% while reducing non-living pools 26%, entirely through a trophic
cascade with no plant invasion involved.

## Structural weaknesses, stated plainly

- **The two limbs are asymmetric.** The stock limb is a formal meta-analysis of 425 paired
  observations; the rate limb is a compilation of four published sources, tabulated and
  explicitly not pooled. This is declared in the Methods rather than concealed. A formal
  meta-analysis of rate effects is the obvious next study, and no deposited dataset supports one.
- **The evidence base is taxonomically narrow.** *Spartina alterniflora* supplies 36.5 per cent
  of soil organic carbon observations and Poaceae 53.8 per cent.
- **Mineral-associated carbon cannot be resolved**, at 10 observations from 5 studies. That is
  the fraction that would settle the durability question.
- **No contributing study reports bulk density**, so concentrations cannot be converted to
  stocks and the equivalent soil mass correction cannot be applied.
- Heterogeneity exceeds 99 per cent for every fraction.

## Pipeline

**There are no analysis scripts.** Every stage lives in the manuscript as a visible R chunk, so
rendering the document is running the analysis. In order: `setup` (helpers, the shared model
and the shared forest-plot routine), `data-stock` (parse the He et al. workbook, build
moderators, construct missing dispersion, compute effect sizes), `data-flux` (the same for the
Negesse et al. deposit), `tbl-rate`, `fit-fractions`, `fig-fractions`, `fit-moderators`,
`fig-moderators`, `coverage`, `fit-flux`, `fig-flux`, `fig-ratestock`, `fit-contrast`,
`tbl-sens`, `fit-turnover`, `fig-turnover`, `abstract-guard`. Base R plus `metafor`, `readxl`
and `knitr`.

The superseded eight-script pipeline is in `02.inputs/archive/scripts/`. It is not read by
anything and is kept only for the record.

## Submission checklist, all passing

Abstract 295 of 300 words; body 5,978 of 8,000; keywords 7; data availability present; 118
verified bibliography entries; no unresolved inline expressions; no em-dashes or en-dashes;
six figures. The abstract's literal figures are checked against the analysis on every render by
the `abstract-guard` chunk, which halts the render on drift.

The author-facing sections the manuscript no longer carries (acknowledgements, conflict of
interest, funding, CRediT contributions, artificial intelligence disclosure, supporting
information) were removed deliberately by the author and must not be reinstated.

**One manual step remains: line numbering must be enabled in Word, because Quarto does not emit
it to docx.**
