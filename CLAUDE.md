# verra-ccb-invasive-species — project conventions

Read [`INDEX.md`](INDEX.md) first. This file holds the conventions, the corrections already
forced, and the traps.

## The claim, in one sentence

Removing an invasive plant incurs an immediate carbon debt that the recovering native
vegetation may or may not repay, the time to repayment differs by orders of magnitude across
invader functional types, and no carbon standard can credit the result either way.

## The master document

`01.manuscript/invasive-removal-carbon-parity.qmd` is the single source of truth. Edit it,
never the renders. Rendering runs the analysis: every number in the prose is an inline R
expression, every table and figure is generated at render time from `02.inputs/`. Nothing is
fetched over the network.

Build: `cd 01.manuscript && quarto render invasive-removal-carbon-parity.qmd --to docx`
(or `--to html`).

Base R only, no packages beyond `knitr`. Every chunk carries an explicit `#| echo: true`.
Suppress noisy output with `output: false`, never the code. Do not hide the code because it
"looks unprofessional in a submission": that judgement is not ours to make, and making it
cost the allometry paper an entire render on 2026-07-22.

## Parameters and the provisional guard

`02.inputs/carbon-parameters.csv` is long format, one row per parameter per system, so
provenance travels with the value. Every row carries an evidence tier:

- **A** measured in the cited source for that system, with a dispersion estimate
- **B** measured, point estimate only
- **C** derived by arithmetic that is visible in the manuscript code
- **D** transferred from another system or a global default
- **P** provisional, not yet read from a source

The setup chunk **stops the render** if any row is still tier P. That guard exists on purpose.
Do not weaken it to get a render out, and do not promote a P to a D without reading a source.
Tier D is a stated limitation in the text, not a hiding place.

## Corrections already forced

**The Phragmites removal figures are not Phragmites figures.** A soil organic carbon loss of
1273, 389 and 207 g C/m2 at freshwater, brackish and saltwater sites, elevation loss of
-4.24 cm, and emissions up to 4.2 t CO2e/acre, circulate in secondary summaries as if they
described herbicide control of invasive Phragmites in North American marshes. They come from
Lane et al. 2016, *Wetlands* 36:1167-1181, an experimental **wetland loss** study in coastal
Louisiana in which herbicide was applied to **native** emergent marsh to simulate vegetation
death. The words Phragmites and Spartina do not appear in its body text. Do not attribute
those numbers to invasive plant control. The genuine Phragmites removal flux work is
Martin and Moseman-Valtierra 2017, *Atmospheric Environment* 158:51-59.

**Working for Water is carbon-blind, and that is a finding.** The largest invasive removal
programme on earth has run for three decades with endpoints of water yield, employment and
biodiversity. It is not a data gap to apologise for in the limitations; it belongs in the
discussion as a recommendation. Note also that Hosking and Du Preez 2004 concluded the
programme was **inefficient** at the sites tested, which is the opposite of what a casual
citation would assume.

**Verra names almost no species.** Across the entire Verra corpus the only invasive taxa named
anywhere are Russian olive and water hyacinth, both in the draft VM0044 biochar feedstock
list. Do not write as though the standards engage with particular invaders. They do not.

**Registry search finds compliance negations, not projects.** CCB criterion B2 makes "no
invasive species will be introduced" boilerplate in a great many project documents. Grepping
project descriptions at scale returns those negations, which are the opposite of the activity
at issue. The distinction between "we will not introduce" and "we will remove" has to be made
by reading.

## Terminology

**Parity**, not payback, is the paper's quantity. Parity is the crossing of the counterfactual
trajectory, in the sense of Mitchell et al. 2012; payback is the return to the pre-removal
stock. Crediting systems pay for the former while intuition reaches for the latter, and
conflating them is the single most likely reviewer objection. Both are reported.

**Debt** is the carbon released or lost by the removal, not the standing stock of the invader.
Carbon leaving the site in durable form, as timber or biochar, is not part of the debt. That
is precisely why the biochar route changes the arithmetic and not merely the finance.

## Traps

- Jonker et al. 2014 showed that methodological choices alone swing payback from under a year
  to 27 years and parity from 2 to 106 years in the bioenergy literature. A reviewer will
  raise this. The accounting boundary and the counterfactual are fixed in the Methods before
  any result is computed, and the sensitivity analysis addresses it directly.
- The invaded state is often **not** at equilibrium. Where a source gives no invaded
  asymptote the code treats the invaded state as static, which is the conservative assumption
  for the removal case and must stay labelled as such.
- Soil carbon is reported to different depths across sources. Never combine a 1 m soil stock
  with a 30 cm stock without saying so in the parameter table.
