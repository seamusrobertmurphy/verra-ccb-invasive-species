# Preregistration: what counterfactual does the invasion-carbon literature use?

Written 2026-07-30, before any study was coded. This document fixes the question, the coding
frame and the decision rules in advance, because the entire vulnerability of this paper is that
the coder chooses the answers. Nothing below may be revised after coding begins except by a
dated amendment recorded at the foot of this file, stating what changed and why.

Spin-off from `verra-ccb-invasive-species`. Graduates to its own project directory only if the
pilot in `PILOT-RESULTS.md` clears the go/no-go rule stated below.

## The question

When a study reports the effect of plant invasion on ecosystem carbon, against what does it
compare the invaded state, and does it distinguish a **reference condition** from a
**counterfactual**?

A reference condition is what an uninvaded site looks like. A counterfactual is what the invaded
site would have looked like had it not been invaded. These coincide only if the invaded site
would otherwise have resembled the reference site, which is precisely what invasion gives us
reason to doubt: the disturbance that admitted the invader is usually also a disturbance to
carbon.

## Hypotheses

**H1 (prevalence).** A majority of primary studies in the invasion-carbon literature compare
invaded plots to an uninvaded reference without reporting the land-use history of that
reference, and therefore cannot separate the effect of the invader from the effect of the
disturbance that permitted invasion.

**H2 (consequence).** Where a study measures a degraded-but-uninvaded class alongside an intact
reference, the sign of the estimated carbon effect of invasion depends on which is used as the
comparison.

**H3 (separability).** The counterfactual question is answerable only where degradation and
invasion are causally separable processes. In systems where invasion is itself the degradation
pathway, a degraded-but-uninvaded class does not exist on the ground and the question is
malformed rather than merely unanswered.

H3 is the one I expect to be most novel and least anticipated by reviewers. It also predicts
which systems will and will not carry the required classes, which is a falsifiable ordering
rather than a post-hoc observation.

## Sampling frame

Primary studies are drawn from the reference lists of published invasion-carbon meta-analyses
rather than from a fresh systematic search. Those authors did the searching, their corpora are
published, and reusing them makes the sample auditable. Planned corpora: Liao et al. (2008,
94 studies), Vila et al. (2011, 199 articles), Nagy et al. (2021, 41 articles). This inherits
the corpora's own inclusion biases, which is a stated limitation, not a defect to be concealed.

**The pilot reported in `PILOT-RESULTS.md` is not drawn from that frame.** It is a convenience
sample of studies already in hand from the parent manuscript, coded to test whether the frame
is workable and whether the effect is large enough to be worth the full exercise. Its
prevalence estimates are indicative only and must not be reported as results.

## Coding frame

One row per primary study. Every field is coded from the paper's own text; nothing is inferred
from the authors' likely intent.

| Field | Values | Definition |
|---|---|---|
| `study` | citation key | |
| `system` | free text | invader and region |
| `design` | `paired`, `gradient`, `chronosequence`, `factorial`, `removal_experiment` | the highest-inference design present |
| `n_classes` | integer | number of distinct vegetation or land-cover classes with carbon measured |
| `has_invaded` | 0/1 | an invaded class is measured |
| `has_reference` | 0/1 | an uninvaded class presented as intact, natural or native |
| `has_degraded` | 0/1 | an uninvaded class explicitly described as degraded, disturbed or in reduced condition |
| `has_restored` | 0/1 | a class under active restoration or post-management recovery |
| `history_reported` | 0/1/2 | land-use history of the uninvaded comparison: 0 none, 1 partial or qualitative, 2 quantitative (ages, dates, stocking, management record) |
| `time_since_invasion` | 0/1 | invasion age or duration reported |
| `states_counterfactual` | 0/1 | the paper explicitly frames its comparison as what the site would have been absent invasion, as opposed to what an uninvaded site is like |
| `control_method` | `none`, `asserted_similarity`, `measured_covariates`, `statistical_matching` | strongest control for confounding present |
| `acknowledges_reverse_causation` | 0/1 | the paper anywhere notes that site condition may have permitted invasion rather than resulted from it |
| `sign` | `up`, `down`, `mixed`, `null` | direction of the reported carbon effect of invasion |
| `sign_flips` | 0/1/NA | where both a reference and a degraded class exist, whether the sign differs between the two comparisons. NA where the classes are not both present |

## Decision rules for ambiguous cases

These exist so that the same paper codes the same way twice.

1. `has_degraded` requires the paper's **own** language of degradation, disturbance or reduced
   condition applied to an uninvaded class. A class that a reader would judge degraded but the
   authors call natural codes 0. The rule is deliberately conservative and will understate
   `has_degraded`.
2. `states_counterfactual` requires a counterfactual construction, not merely the word baseline
   or control. Phrases such as "would have been", "in the absence of invasion" or "had the site
   not been invaded" satisfy it. "Compared with uninvaded plots" does not.
3. `asserted_similarity` covers any claim that sites were comparable, matched, similar or
   selected for uniformity **without** reported covariate values. Reporting the covariate values
   moves it to `measured_covariates`. Only formal matching, propensity or synthetic control
   moves it to `statistical_matching`.
4. `history_reported` codes the history of the **uninvaded comparison**, not of the invaded
   plots. Studies frequently report invasion age while saying nothing about the reference.
5. A study that measures only invaded stands with no uninvaded comparison of any kind is
   excluded, and the exclusion is counted.
6. `sign` is the direction for **total ecosystem carbon** where reported, otherwise for soil
   organic carbon, otherwise for aboveground biomass carbon, in that order of preference. The
   pool actually used is recorded in a free-text note.
7. Meta-analyses, reviews and syntheses are not primary studies and are excluded from coding,
   though their reference lists supply the frame.

## Coder reliability

Sole authorship on the parent manuscript does not transfer here. Coder arbitrariness is the
whole risk, so the paper requires either a second independent coder with a reported agreement
statistic, or, failing that, blind double-coding by the same coder separated in time with the
first pass sealed. The second option is weaker and must be declared as such. **This is an open
decision and must be resolved before the full corpus is coded.**

## Go / no-go rule for the pilot

The full exercise proceeds only if the pilot shows **both**:

- fewer than half of coded studies score `history_reported` = 2, and
- at least one study in which `sign_flips` = 1 can be demonstrated with published numbers.

If the first fails, the field is better at this than the hypothesis assumes and the paper
collapses. If the second fails, the consequence leg has no existence proof and the paper is an
observation about reporting practice rather than about validity.

## Amendments

None. Any change after coding begins is recorded here with its date and reason.
