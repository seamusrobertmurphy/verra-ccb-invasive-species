# verra-ccb-invasive-species — project conventions

Read [`INDEX.md`](INDEX.md) first. This file holds the conventions, the corrections already
forced, and the traps.

## The claim, in one sentence

Removing an invasive plant incurs an immediate carbon debt that the recovering native
vegetation may or may not repay, the time to repayment differs by orders of magnitude across
invader functional types, and no carbon standard can credit the result either way.

## The master document

`01.manuscript/invasion-rate-versus-stock.qmd` is the single source of truth. Edit it,
never the renders. Rendering runs the analysis: every number in the prose is an inline R
expression, every table and figure is generated at render time from `02.inputs/`. Nothing is
fetched over the network.

Build: `cd 01.manuscript && quarto render invasion-rate-versus-stock.qmd --to docx`
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

**The 10.6 kg CO2e/ha figure is an insecticide figure, not a herbicide emission factor.**
PLOS ONE 8(8):e72293 is about foliar insecticides against soybean aphid. It contains no
herbicide emission factor at all, and the only herbicide it names is glyphosate as a tank-mix
partner. What is transferable from it is the **application** term, 3.60 kg CO2e/ha, which is
diesel use by a tractor sprayer and is chemical-agnostic. An earlier version of the parameter
table here cited the 10.6 total as a herbicide factor. It does not.

**Kahara et al. 2026's published carbon stocks are a factor of 100 too large.** Reproducing
their own Equation 1 on their raw supplementary data gives `%C x BD x D x 100`, which is
100 x (Mg C/ha). Their tables label the result g/ha and their Results text calls it kg C/ha;
it is neither. Divide every tabulated value by 100. Two further defects sit in the same file:
core depths range from 2.2 to 29.0 cm despite a stated 20 to 30 cm, and spring cores average
7 cm against 23 to 25 cm in summer and autumn, which confounds their reported seasonal effect
with sampling depth. Depth-standardising the raw data leaves Phragmites and native Spartina
statistically indistinguishable, p = 0.70.

**Phragmites emits far less methane than the native it replaces.** In the only within-marsh
comparison available, invasive Phragmites emitted roughly 60 times less CH4 than native
*Spartina alterniflora*, and N2O shows no invasion effect anywhere it has been measured. Do
not assume the intuitive direction here.

**Prosopis aboveground carbon is in Mbaabu's Supplementary Table S7, not the main paper.**
Dense stands hold 12.46 Mg C/ha (SD 6.36, n=5), measured on the same plots as the soil data.
Do not substitute Birhane et al.'s Ethiopian figure of roughly 86 Mg C/ha: different country,
different measurement basis, and it contradicts the bound Mbaabu states in the main text.

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

## Terminology: the hard rule

**Never use a term that does not already appear in the published literature.** Do not coin,
do not paraphrase into plain English, do not substitute a "clearer" word. If a term seems like
jargon, the response is to go and check what the literature calls the quantity, not to invent
a replacement. Verify against article titles via the Crossref API before using anything.

This rule exists because it was broken on 2026-07-30. "Carbon parity", "carbon debt" and
"payback" were removed on the assumption that they were borrowed bioenergy jargon, and replaced
with "carbon break-even", "initial carbon loss" and "stock recovery", which were invented on the
spot and appear nowhere. The originals are the established terms and carry peer-reviewed article
titles:

- **carbon debt** — Fargione et al. 2008 *Science*; Mitchell et al. 2012 *GCB Bioenergy*;
  "Carbon debt and payback time - Lost in the forest?" *Renew. Sustain. Energy Rev.* 2017
- **carbon sequestration parity** — Mitchell et al. 2012 *GCB Bioenergy*; "Carbon debt repayment
  or carbon sequestration parity?" *GCB Bioenergy* 2014
- **carbon payback period / time** — Jonker et al. 2014 *GCB Bioenergy*; *Energies* 2018

Note that "carbon parity" on its own is **not** attested; the full form is "carbon sequestration
parity". Use the full form on first mention.

## The exemplar publication

**Mitchell, S.R., Harmon, M.E. & O'Connell, K.E.B. (2012). Carbon debt and carbon sequestration
parity in forest bioenergy production. *GCB Bioenergy* 4(6):818-827. doi:10.1111/j.1757-1707.2012.01173.x**

This is the model for terminology, analytical structure and depth. It is the paper this
manuscript's two-trajectory model is an adaptation of, and it sits in the sister journal of the
target venue. When a question arises about what to call something, how to structure the
analysis, or how deep to go, the answer is whatever Mitchell et al. did.

Secondary exemplar for subject matter and results presentation: Nagy et al. 2021,
*Journal of Applied Ecology* 58:327-337, a quantitative synthesis of invasion effects on
ecosystem carbon reported pool by pool.

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
- **State the clustering unit before reading any meta-analytic result.** The Negesse deposit
  has no complete study identifier: `Authors` is blank for 84.4% of rows and `Case_studies` is
  a row index. Clustering on either gives one group per observation, a degenerate random
  effect that silently drops the correction for non-independence. Soil respiration read
  +3.8% (p = 0.54) under that mistake and +24.3% (p = 0.041) once clustered on the site
  coordinates, which are complete for every row. The data never changed; the grouping did.
  Full detail in `02.inputs/dryad-negesse2025/PROVENANCE.md`.
- **Do not cite a source you have not resolved against Crossref.** An enzyme-asymmetry claim
  was nearly attributed to a "Zhou & Staver 2019" that does not exist. The real source for the
  claim is `zhou2019enhanced`, already in the bibliography, and the manuscript now reports that
  our data fail to replicate it rather than citing it as support.

## The paper's central distinction

**Rate is not stock.** Carbon stock is a mass held at a point in time; carbon sequestration rate
is a flux. They are related through residence time and can move in opposite directions. The
literature reports both as "sequestration", and that conflation is what the paper resolves.

The distinction is formalised in the IPCC's two estimation methods, the gain-loss method
(2006 Guidelines Vol. 4 Eq. 2.4) and the stock-difference method (Eq. 2.5), which the guidance
calls "equally valid". Never write about invasion and carbon without specifying which quantity
is meant.

## Corrections forced by PDF extraction

**The plus-or-minus sign does not survive text extraction from some publishers' typesetting.**
In Pati et al. 2025 it renders as an arrow, and an early draft read the paired mean and standard
error as an invaded-against-uninvaded comparison. The correct readings are total biomass
94.45 +/- 10.27 against 72.85 +/- 9.50 Mg/ha, and sequestration rate 8.01 +/- 1.50 against
0.71 +/- 2.39 Mg C/ha/yr. **Never read a paired value from a text layer without confirming
whether the separator is a comparison or a dispersion term.**

## Sources excluded on quality grounds

**Wang 2023 on Phragmites carbon must not be cited.** It is published in the National High
School Journal of Science, a secondary-school student publication, carries no DOI, and is not
peer reviewed to professional standard. Its claim that Phragmites-invaded wetlands show 3.1
times higher net primary production is attributed to its own reference 47 and should be traced
to that primary source. The exclusion is recorded in the manuscript's Methods.

## Filename and citation traps in 04.references/literature

Two deposited PDFs carry wrong metadata in their filenames. The Gliricidia paper is **Pati et
al. 2025**, *Environmental Challenges* 20:101186, not "Kumar et al". The bio-perversity paper is
**Lindenmayer et al. 2012**, *Conservation Letters* 5:28-36, not 2023. Always verify against
Crossref rather than trusting a filename.
