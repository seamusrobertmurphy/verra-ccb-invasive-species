# verra-ccb-invasive-species

**Carbon parity after invasive plant removal, and the crediting gap it exposes.**

Status as of 2026-07-30: **master manuscript built and rendering**, analysis executable
in-document, bibliography verified entry by entry against fetched publisher records.
Sole-authored. Target venue Global Change Biology.

**The master is [`01.manuscript/invasive-removal-carbon-parity.qmd`](01.manuscript/invasive-removal-carbon-parity.qmd).**
Edit it, not the renders. Every number in the prose is an inline R expression and every table
and figure is generated at render time, so prose and results cannot drift.
Build: `cd 01.manuscript && quarto render invasive-removal-carbon-parity.qmd --to docx`.

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

| System | Debt (Mg C/ha) | Parity | Claimable at 40 yr |
|---|---|---|---|
| Cheatgrass steppe | 0.4 | 28 yr | yes, but the benefit is near zero |
| Dry deciduous forest (Lantana) | 1.7 | 5 yr | yes, debt 30% of benefit |
| Atlantic Forest regrowth (Acacia) | 45.4 | 21 yr | yes, debt 178% of benefit |
| Prosopis rangeland | 10.2 | not reached, P=0.56 | no |
| Tropical freshwater (hyacinth) | 3.8 | not reached, P=0.70 | no |
| Everglades (Melaleuca) | 51.0 | not reached, P=0.86 | no |
| Tidal marsh (Phragmites) | 9.5 | not reached, P=0.96 | no |

The Prosopis result is the most interesting and the least secure: the soil carbon gain from
grassland restoration very nearly cancels the loss of Prosopis standing biomass, so parity sits
on a knife edge and the answer is governed by an aboveground stock the source does not tabulate.

## Blocking and open

- **Only two of seven systems are fully quantified.** Evidence class is derived in code from
  the parameter tiers, not asserted, so this cannot be talked around: a system counts as
  quantified only where both stocks and the invader's own aboveground carbon are measured.
  Cheatgrass and Lantana pass. The rest carry at least one transferred parameter.
- **The single most valuable missing number is Prosopis aboveground carbon in Baringo.**
  Mbaabu et al. report it only as being lower than the 0-30 cm SOC pool, in Supplementary
  Table S7, which was not retrieved. Get S7 and the Prosopis parity result firms up
  substantially. Do not substitute Birhane et al.'s Ethiopian figure of 86 Mg C/ha: it is a
  different country, a different measurement basis, and it violates the bound Mbaabu states.
- **Phragmites stocks are the weakest in the table.** Gu et al.'s 37 to 77 per cent soil carbon
  excess is verified, but the absolute native stock is nominal, because Kahara et al. report
  concentrations rather than areal stocks and MDPI returned 403 to automated fetch. The sign of
  the difference drives the result, not the magnitude, but the numbers should not be quoted as
  measurements. Retrieve Kahara et al. Table 3 by hand.
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
