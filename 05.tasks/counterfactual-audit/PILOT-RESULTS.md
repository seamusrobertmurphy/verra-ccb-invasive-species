# Pilot results: counterfactual audit

Run 2026-07-30 against the frame fixed in [`PREREGISTRATION-2026-07-30.md`](PREREGISTRATION-2026-07-30.md).
Every number below comes from [`summarise-pilot.R`](summarise-pilot.R) applied to
[`pilot-coding.csv`](pilot-coding.csv). Nothing here was computed by hand.

**Verdict: GO.** Both preregistered gates clear.

## What the pilot is and is not

Six primary studies, four read in full and two in part. They are a **convenience sample of
papers already in hand from the parent manuscript**, not a draw from the sampling frame. The
prevalence percentages below are therefore indicative only and must not be reported as results.
What the pilot establishes is that the coding frame is applicable and that the consequence leg
has an existence proof.

One frame addition was made before coding began, so it is not an amendment: an `access` field
recording whether the paper was read in full or in part, and a `coder_confidence` field. Studies
available only as abstracts were not coded at all.

## H1, prevalence

| Feature | Pilot |
|---|---|
| An uninvaded reference class is present | 6/6 |
| A degraded-but-uninvaded class is present | 1/6 |
| A restored class is present | 2/6 |
| No land-use history of the reference reported | 3/6 |
| Quantitative land-use history of the reference reported | 2/6 |
| **States a counterfactual rather than a reference condition** | **0/6** |
| **Acknowledges that site condition may have permitted invasion** | **0/6** |

Control for confounding was `asserted_similarity` in four studies and `measured_covariates` in
two. No study in the sample used statistical matching of any kind.

The two zero rows are the finding. Every study compares invaded plots to uninvaded plots. None
frames that comparison as what the site would have been absent invasion, and none anywhere notes
the possibility that the condition of the site is why the invader is there. That is not a
subtlety the field debates and resolves in one direction; it is a question the field does not
appear to ask.

Two caveats keep this honest. The sample is small and non-random, and rules 2 and 3 of the frame
are deliberately conservative, so both zeros are lower bounds on the field's actual practice.

## H2, consequence

One study in the pilot carries both a reference and a degraded uninvaded class, and it delivers
the existence proof. Mbaabu et al. measured five land-cover classes in Baringo, Kenya, with soil
organic carbon to 1 m and aboveground carbon on the same plots.

| Class | Soil C | Aboveground C | Total |
|---|---|---|---|
| Pristine grassland | 49.76 | 6.02 | 55.78 |
| Restored grassland | 44.68 | 3.19 | 47.87 |
| Degraded grassland | 31.52 | 0.69 | 32.21 |
| Dense Prosopis (invaded) | 40.05 | 12.46 | 52.51 |

The estimated carbon effect of invasion, from these same numbers:

| Counterfactual | Effect | Verdict |
|---|---|---|
| Pristine grassland | −3.27 Mg C/ha | **loss** |
| Restored grassland | +4.64 Mg C/ha | **gain** |
| Degraded grassland | +20.30 Mg C/ha | **gain** |

Same site, same cores, same year, same authors. The sign of the answer is set by the comparison,
and the spread between the extreme comparisons is 23.6 Mg C/ha, which is larger than the entire
invaded aboveground carbon stock.

Note that including aboveground carbon changes the story from the soil-only figures, and in the
invader's favour: dense Prosopis holds 12.46 Mg C/ha aboveground against 6.02 under pristine
grassland, so adding the biomass pool narrows the loss against pristine from 9.71 to 3.27. Pool
selection is therefore a second, nested counterfactual-like choice, and the frame should be
extended to record it explicitly in the full corpus.

## What this changes

The design objection that stalled this idea, that it needs more field sites than exist, does not
survive the pilot. Prevalence comes from coding a corpus, not from fieldwork, and consequence
needs an existence proof rather than a sample. Baringo supplies the existence proof, and it is
unusually strong because the five classes were measured by one team in one year with the same
protocol, which removes every alternative explanation except the choice of comparison.

The pilot also sharpens H3. Of the six systems, only Baringo could in principle carry a
degraded-but-uninvaded class, because grazing degradation and Prosopis invasion are distinct
processes there. In sagebrush steppe, invasion is the degradation pathway, so the class does not
exist to be measured. That predicts which systems can answer the counterfactual question at all,
and it is testable against the full corpus.

## Open decisions before the full corpus

1. **Coder reliability is unresolved and is the paper's main methodological risk.** Sole coding
   will not survive review. Either recruit a second coder as co-author, or blind double-code with
   the first pass sealed and report the agreement statistic, declaring the weaker design.
2. **Pool selection** should be added to the frame as its own field, on the evidence above.
3. **Corpus access.** The pilot excluded every abstract-only paper. Applying the frame at scale
   requires full text for several hundred studies, and paywalls blocked a substantial share of
   this session's retrievals. Institutional access needs to be secured before committing.
4. **The session's WebSearch budget is exhausted (200/200)**, so assembling the reference lists
   of the target meta-analyses is the first task of a fresh session.
5. **Venue.** This is a methods and meta-science paper, better suited to *Methods in Ecology and
   Evolution*, *Journal of Applied Ecology* or *Conservation Letters* than to *Global Change
   Biology*, where the parity manuscript should still go on its own terms.

## Graduation

On the go verdict this becomes its own project at
`publications-academic/invasion-counterfactual-audit/`, following the layout of the sibling
manuscripts. It stays here until the coder-reliability decision at item 1 is made, because that
decision determines whether it is a sole-authored paper at all.
