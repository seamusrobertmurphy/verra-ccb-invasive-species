# verra-ccb-invasive-species

**Biological invasion increases carbon sequestration rates but not carbon stocks.**

A quantitative synthesis of how long it takes for recovering native vegetation to overtake the
carbon trajectory an invasive plant would have followed if left in place, joined to an audit of
whether any carbon standard can credit the answer.

Status: master manuscript built and rendering, analysis executable in-document. Sole-authored.
Target venue **Global Change Biology**, Research Article, guidelines verified live on 2026-07-30.

The venue decision was made on budget, not prestige. Global Change Biology allows 8,000 words
counted over the body only, with **no cap on figures, tables or references**, which is the only
budget among the candidates that can carry the parity model and the six-standard audit in one
paper without exiling the audit to supplementary material. Impact factor 12.5, six-day median
to first decision, no submission or publication charge. One Earth is the strong second choice
and arguably the better home for the mixed character, at the cost of 5,000 words and seven
display items. Nature Sustainability fits the argument best and the manuscript worst: 3,500
words and roughly 50 references cannot hold both halves. If it goes there, it goes as an
**Analysis**, never a Review, because their own rule reclassifies structured literature
syntheses as original research.

---

## The problem

Removing an invasive plant is one of the few restoration actions with an unambiguous
biodiversity rationale and no reliable way to pay for it. Carbon finance is the obvious
candidate and it fails for a reason that is arithmetic rather than administrative. A woody
invader is itself a carbon stock. Clearing it registers as an emission against a carbon-rich
baseline, and the clearing is deliberate, carried out by the proponent, and motivated by
carbon finance. Those three facts are the standard test for baseline gaming, and a genuine
restoration project satisfies all of them.

Whether removal is nevertheless a carbon gain depends on a quantity nobody had estimated: the
time to carbon parity, meaning the point at which the recovering native trajectory overtakes
the counterfactual. The literature splits cleanly into two halves that have never been joined.
A large body quantifies what invasion does to ecosystem carbon, and finds that invasion
frequently *raises* stocks. A much thinner body follows what happens after removal, and
measures species composition, water yield and employment rather than carbon.

## What this does

Two parts, and the second is what makes it a standards paper rather than an invasion ecology
paper.

**The parity synthesis.** The carbon debt framework built for biofuels by Fargione et al.
(2008) and sharpened into a parity concept by Mitchell et al. (2012) is adapted to invasive
removal and applied across seven systems chosen to span invader functional type: woody
nitrogen-fixing trees, a thicket-forming shrub, an annual grass, a wetland graminoid, a woody
wetland tree and a floating aquatic. The selection is deliberately adversarial, including the
systems where removal is most likely to *lose* carbon.

**The standards audit.** Six voluntary crediting regimes plus one compliance scheme, read
against their own current requirement documents rather than summaries. Every regime prohibits
introducing invasive species. None credits the carbon consequence of removing them.

## Headline findings

**The eligibility gate is open and the crediting gate is shut.** Verra's VM0033 has listed
"removing invasive species" as an eligible tidal wetland activity since 2015, and the VCS
Standard has carried an eligibility carve-out for land whose dominant cover is an invasive
species. Neither provides a way to quantify the result without penalising the proponent for
the invader's own biomass.

**One accounting design already solves the problem, and nobody appears to have noticed.**
VM0045's dynamic matched baseline leaves the invader standing in both project and control
plots, so its removal never registers as a net emission and the credit attaches to the
differential growth of released regeneration. The constraint is jurisdictional, currently the
conterminous United States via the Forest Inventory and Analysis, and structural, forest
remaining forest. It cannot reach a marsh or a rangeland. Whether that design generalises is
the paper's constructive proposal.

**The activity is monetised, just never as land carbon.** Two routes pay today: invasive
biomass as biochar feedstock under VM0044, where the carbon leaves the land pool for a durable
one, and invasive control as a scored Condition metric under the SD VISta Nature Framework,
where it generates biodiversity credits. Neither rewards the land carbon effect.

**Registered projects are close to absent.** Against a decade-old eligibility clause, the
number of registered projects where invasive plant control is the primary crediting activity
is zero.

## Layout

| Path | What it holds |
|---|---|
| `01.manuscript/` | the master `.qmd` and its renders |
| `02.inputs/` | the two parameter tables, each row carrying its source |
| `03.outputs/` | tables and figures, all regenerated at render time |
| `04.references/` | verified BibTeX, CSL styles, the reference docx |
| `05.tasks/` | task requests and evidence notes |

Read [`INDEX.md`](INDEX.md) for what to open in what order, and [`CLAUDE.md`](CLAUDE.md) for
the conventions and the corrections already forced, including one misattributed dataset that
would have put fabricated numbers in the Phragmites section.

## Build

```
cd 01.manuscript
quarto render invasion-rate-versus-stock.qmd --to docx
quarto render invasion-rate-versus-stock.qmd --to html
```

Rendering runs the entire analysis. Base R only, no packages beyond `knitr`, nothing fetched
over the network.
