# verra-ccb-invasive-species

**Carbon parity after invasive plant removal, and the crediting gap it exposes.**

Status as of 2026-07-30: **master manuscript built and rendering**, analysis executable
in-document, bibliography verified entry by entry against fetched publisher records.
Sole-authored. Target venue Global Change Biology.

**The master is [`01.manuscript/invasive-removal-carbon-debt.qmd`](01.manuscript/invasive-removal-carbon-debt.qmd).**
Edit it, not the renders. Every number in the prose is an inline R expression and every table
and figure is generated at render time, so prose and results cannot drift.
Build: `cd 01.manuscript && quarto render invasive-removal-carbon-debt.qmd --to docx`.

## Read in this order

1. [`CLAUDE.md`](CLAUDE.md) — conventions, terminology, the corrections already forced, traps.
2. [`README.md`](README.md) — the problem, what the paper does, headline findings.
3. [`02.inputs/README-data.md`](02.inputs/README-data.md) — the parameter dictionary and the
   evidence tier scheme that governs what may be claimed.
4. [`05.tasks/EVIDENCE-BASE-2026-07-30.md`](05.tasks/EVIDENCE-BASE-2026-07-30.md) — the
   quote-backed standards evidence, every document retrieved and searched in full text.

## The question

Across invaded systems differing in the functional type of the invader, how long does it take
for recovering native vegetation to overtake the carbon trajectory the invader would have
followed if left in place, and can any carbon standard credit the answer?

H1 is that parity time is ordered by invader functional type, that it is never reached where
the invader outperforms the community it displaced, and that no standard can act on either
outcome.

## The thesis, as of 2026-07-30

The paper now argues a **symmetry**, which is sharper than the original gap framing. Removal
cannot be credited, because clearing a woody invader is an emission against a carbon-rich
baseline and is indistinguishable, on the face of the applicable test, from deliberately
lowering that baseline. Retention cannot be credited either, and for a structural reason rather
than an ideological one: retention is inaction, inaction is the baseline, and nothing can be
additional to itself. Whichever action the carbon arithmetic favours, the accounting returns
nothing.

Compounding it, the sign of the answer depends on the counterfactual. Section 2.3 shows that on
the one site where intact, degraded and restored classes were all measured, invasion is a loss
of 3.27 Mg C/ha against pristine grassland, a gain of 4.64 against restored grassland and a gain
of 20.30 against degraded grassland. A crediting system must fix a counterfactual in advance and
apply it categorically, so it fixes the sign before the ecology is consulted.

Retention-crediting is **not** endorsed. The decisive objection is leakage: paying to retain an
invader pays to maintain a propagule source, and stock accounting captures the retained carbon
while externalising the spread.

## The two moving parts

**The parity model.** Two monomolecular trajectories from the moment of intervention. Under
retention the stock relaxes toward the invaded asymptote. Under removal it falls instantly by
the removal debt, then relaxes toward the native reference stock. Parity is the crossing.
Payback, reported alongside, is the return to the pre-removal stock. Uncertainty by Monte
Carlo, 10,000 draws per system, every parameter drawn from its reported dispersion.

**The standards audit.** Six voluntary regimes plus the Australian compliance scheme, coded
against six criteria, read from the current requirement documents in full text rather than
from summaries.

## Established so far

**Verra's eligibility gate has been open since 2015 and the crediting gate has never opened.**
VM0033 has listed "removing invasive species" as an eligible tidal wetland activity since
v1.0. The VCS Standard carries an eligibility route for land whose dominant cover is an
invasive species threatening ecosystem health, tightened in v5.0 from a blanket exemption to
an evidentiary test requiring a defined dominance threshold.

**VM0047 changed in May 2025 and this is the pivotal date for the standards argument.**
v1.0 contained no occurrence of the word invasive and its pre-existing woody biomass clause
made deliberate clearing close to disqualifying. v1.1 added a three-condition carve-out
contemplating "site preparation (e.g., clearing invasive species)". Condition (ii) requires
the removed biomass to be a waste product with no commercial value, which sits directly
against the VM0044 biochar route where the same biomass is a saleable feedstock.

**No quantitative clearing threshold exists, and Verra says so in its own consultation
record.** Asked what threshold of pre-existing woody biomass removal is permissible, Verra
answered that the methodology specifies none and fell back on the 5 per cent de minimis rule.

**VM0045's dynamic matched baseline already dissolves the accounting problem.** The invader
stands in both project and matched control plots, so removal is not an emission and the credit
attaches to differential regeneration growth. Present verbatim since v1.0 in October 2022 and
apparently unrecognised as a solution to this problem. Limited to US FIA jurisdictions and to
forest remaining forest.

**Two routes monetise the activity today, neither as land carbon.** VM0044 biochar, where the
draft v2.0 promotes invasive terrestrial and aquatic plants to a named feedstock category, and
the SD VISta Nature Framework, where invasive abundance is a scored Condition metric.

**Registered projects are effectively absent.** Zero projects where invasive plant control is
the primary crediting activity. Note that registry.verra.org is closed to programmatic access
and the Berkeley Voluntary Registry Offsets Database has an empty project-description column
for all VCS projects, so name search is the only route and it returns mostly the opposite
case, afforestation projects deliberately planting exotics.

**CCB is purely restrictive.** All seven occurrences of invasive species in CCB v3.1 sit
inside criterion B2 and impose a negative obligation: do not introduce, do not let populations
increase. Nothing in CCB credits, rewards or requires control.

## Results as they stand

Ordered exactly by invader functional type, which was the hypothesis.

| System | Debt (Mg C/ha) | Parity, median (95%) | P(never) | Claimable at 40 yr |
|---|---|---|---|---|
| Dry deciduous forest (Lantana) | 1.7 | 5 yr (1-71) | 19% | yes, debt 30% of benefit |
| Cheatgrass steppe | 0.4 | 16 yr (0-158) | 40% | no, benefit is near zero |
| Atlantic Forest regrowth (Acacia) | 45.4 | 21 yr (9-90) | 1% | yes, debt 178% of benefit |
| Prosopis rangeland | 11.2 | 23 yr (2-110) | 38% | no, benefit near zero at yr 40 |
| Tidal marsh (Phragmites) | 4.5 | not reached | 54% | no |
| Tropical freshwater (hyacinth) | 3.8 | not reached | 70% | no |
| Everglades (Melaleuca) | 51.0 | not reached | 86% | no |

**The Prosopis result is the sharpest in the paper.** With the measured aboveground carbon from
Mbaabu's Supplementary Table S7 (12.46 Mg C/ha for dense stands), the soil carbon gained by
restoring grassland very nearly cancels the loss of Prosopis standing biomass. Parity lands at
23 years by the Monte Carlo median and at roughly 41 years on the point estimate, straddling the
end of a 40-year crediting period, and the net benefit at year 40 is indistinguishable from zero
(-0.6, 95% interval -16.8 to 16.6). A project in Baringo would be betting its entire carbon case
on where in that interval it lands. Note also that the restoration chronosequence stops at year
30, so the approach to the asymptote is an extrapolation.

Parity and payback are identical wherever the invaded state is treated as static, which is a
check on the code rather than a coincidence: with a flat counterfactual the pre-removal stock
and the counterfactual are the same quantity.

## Blocking and open

- **Only three of seven systems are fully quantified.** Evidence class is derived in code from
  the parameter tiers, not asserted, so this cannot be talked around: a system counts as
  quantified only where both stocks and the invader's own aboveground carbon are measured.
  Prosopis, cheatgrass and Lantana pass. The rest carry at least one transferred parameter.
- **Acacia is the most valuable remaining gap.** Matos et al. measure aboveground live stems
  only: no roots, no soil, no litter, no deadwood, no regeneration layer. Since acacias are
  nitrogen fixers and the uninvaded plots carry 147 species against 26, the belowground and
  soil terms are exactly where a native stand would be expected to close the gap. The native
  asymptote of 150 Mg C/ha is a transferred value and drives the acacia result. Note also that
  the source's headline threefold difference is not age-controlled; invaded stands average 4.9
  years younger, and the age-controlled multiplier is 5.15x.
- **Melaleuca figures in the literature are dry mass, not carbon.** The canonical 129 to 263
  t/ha is aboveground dry biomass excluding roots, from single unreplicated plots; the better
  replicated 2002 figures are higher (141 to 304 t/ha with standard errors) but the weaker
  numbers propagated. No carbon fraction has ever been measured for Melaleuca in Florida.
- **No measured decay constant exists for any of the five woody invaders.** The global synthesis
  of 295 estimates across 114 species contains no record for Prosopis, Acacia, Lantana,
  Melaleuca or Tamarix, and almost nothing from warm semi-arid systems at all. Every release
  fraction in the table is therefore a modelled quantity.
- **No system has a measured post-removal carbon trajectory except Prosopis**, whose rate is
  derived from the Mbaabu restoration chronosequence. Recovery rate is the parameter the model
  is most sensitive to, so this is the field's central data gap and the paper says so.
- Working for Water, the largest removal programme on earth, has no carbon accounting. Treated
  in the discussion as a recommendation, not an apology.
- Methane and nitrous oxide are outside the accounting boundary. Defensible for the terrestrial
  systems, weakest for the aquatic one, where the stock framing may be wrong altogether and the
  live question is methane.
- GCB requires line numbering, which Quarto does not emit to docx. Enable it in Word at
  submission.
