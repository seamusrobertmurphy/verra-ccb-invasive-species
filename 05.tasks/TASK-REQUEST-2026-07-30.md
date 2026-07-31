# Task request, 2026-07-30

Brief for the next work session on this manuscript. Read
[`../CLAUDE.md`](../CLAUDE.md) and [`../INDEX.md`](../INDEX.md) first.

## 1. Objective

Bring `01.manuscript/invasive-removal-carbon-debt.qmd` to submission-ready state for
**Journal of Applied Ecology**.

## 2. Register: the requirement that overrides everything else

**Write the manuscript as a formal scientific article. It is not a notepad, a briefing note,
an essay, or a blog post.** The current draft repeatedly fails this and it is the single
largest thing wrong with it.

Concretely, this means:

- **Formal academic register throughout.** Declarative sentences reporting evidence. No
  rhetorical questions, no direct address to the reader, no conversational asides, no
  editorialising about what is "interesting", "striking", "awkward" or "uncomfortable".
- **Section headings must name their content, not argue a case.** Current headings such as
  "The answer depends on what kind of invader it is", "The standards cannot express the answer,
  in either direction" and "One accounting design already dissolves the problem" are essay
  headings. Replace with descriptive ones in the exemplar's style: "Carbon storage by invader
  growth form", "Treatment of removal under voluntary standards", and so on.
- **Delete rhetorical constructions.** Examples currently in the text: "Nothing about the
  ecosystem differs between these three statements. Only the question does."; "Whichever action
  the arithmetic favours, the accounting returns nothing."; "The result is an activity that is
  simultaneously required as a safeguard, named as eligible, and impossible to credit." These
  are argumentative flourishes. State the finding and let it stand.
- **Tense.** Past tense for what was done and found. Present tense for established knowledge
  and for what the data show. Do not narrate the process of the analysis.
- **Hedging proportionate to evidence.** Tier D parameters must carry explicit qualification;
  tier A findings should not be over-hedged.
- **First use defines, thereafter abbreviates**, as the exemplar does with AGB, BGB and SOC.
- **No claim without a citation or a result.** Every assertion about the literature carries a
  reference; every number traces to Table 1, Table 2, Table 3 or the Supporting Information.
- **No em-dashes anywhere** (repository house rule).
- Content belongs to its section. No results in Methods, no new results in Discussion.

## 3. The exemplar

**Nagy, R.C., Fusco, E.J., Balch, J.K., Finn, J.T., Mahood, A., Allen, J.M. & Bradley, B.A.
(2021). A synthesis of the effects of cheatgrass invasion on US Great Basin carbon storage.
*Journal of Applied Ecology* 58:327-337.** PDF at `04.references/literature/`.

It governs formatting, layout, structure, depth of analysis, and permitted vocabulary. When a
question arises about what to call something, how to structure a section, or how much detail to
give, the answer is whatever Nagy et al. did. Measured targets:

| | Exemplar | Current draft |
|---|---|---|
| Abstract | 4 numbered points, 4th headed *Synthesis and applications*, cap 350 words | 338 words, compliant |
| 1 INTRODUCTION | 964 words | 860 |
| 2 MATERIALS AND METHODS | 1,196 | 1,126 |
| 3 RESULTS | 651 | 648 |
| 4 DISCUSSION, unsectioned prose, no Conclusion | 2,380 | 2,737, **over** |
| Display items | 3 figures, 3 tables | 3 figures, 3 tables |
| End matter | Acknowledgements, Authors' Contributions, Data Availability, ORCID, References | compliant |

## 4. Terminology: hard rule

**Never use a term that does not already appear in the published literature of this field.** Do
not coin, do not paraphrase into plain English, do not substitute a word that seems clearer.
Verify against article titles through the Crossref API before using anything new.

Banned in this manuscript by author instruction: **carbon parity, carbon debt, payback,
carbon break-even, alien**. The last is removed from all text and keywords; it survives only
inside cited titles, where changing it would misquote the source.

Permitted vocabulary is what the exemplar uses: C storage, C pools, biomass C, soil organic
carbon, C loss, vegetation type, time since, invaded, non-native, invasive. Where the exemplar
has no term, because it computes no temporal quantity, **describe the quantity in plain attested
words rather than invent a label**. Current shorthands, each defined once in Methods: "C loss",
"time to exceed retention", "time to return".

This rule exists because it was broken twice on 2026-07-30. See `../CLAUDE.md` for the record.

## 5. Outstanding work, in priority order

1. **Rewrite for register**, per section 2. This is the bulk of the task and touches every
   section. The science does not change; the prose does.
2. **Code placement.** The rendered docx currently carries roughly 290 lines of R before the
   abstract, because the analysis chunks precede the front matter in document order. A submitted
   manuscript must open with title, abstract and keywords. Resolve **without hiding the code**,
   which is a standing repository rule and was already reverted once on the allometry paper. The
   likely solution is to move all computation chunks into an appendix or Supporting Information
   chunk block that executes first but prints last, or to move them behind the front matter
   while keeping `echo: true`. Ask before adopting any solution that reduces code visibility.
3. **Discussion is 357 words over the exemplar** and is now unsectioned, making a long
   undifferentiated block. Trim, and consider whether the standards material and the ecological
   material can be ordered more clearly within continuous prose.
4. **Reinstate the counterfactual table to the main text if the author agrees.** It was moved to
   Supporting Information (Table S2) purely to meet the exemplar's six-display-item count, but it
   carries one of the paper's two novel findings, the change of sign from -3.27 to +20.30 Mg C
   ha-1 depending on the comparison used. One display item over the exemplar is defensible here.
5. **Residual awkward phrasing** left by an automated terminology substitution. Known example in
   the Methods: "a fully measured the time to exceed retention calculation". Read the whole
   document for others.
6. **Confirm the venue.** The exemplar is *Journal of Applied Ecology*. The manuscript was
   previously built to *Global Change Biology* guidelines, verified live on 2026-07-30, and the
   four-point abstract and section numbering now in place are BES house style that would be
   wrong for GCB. Verify the current J Appl Ecol author guidelines before submission.

## 6. Known weaknesses to state honestly, not conceal

- Only 3 of 7 ecosystems are parameterised entirely from measurement. Evidence class is derived
  in code from the parameter tiers, not asserted, and must stay that way.
- The rate of native C accumulation after clearing dominates the result and is measured in one
  ecosystem only, from a restoration chronosequence rather than a removal experiment.
- Methane and nitrous oxide are outside the accounting boundary. Weakest for the aquatic case.
- Registry access was limited: `registry.verra.org` is closed to programmatic retrieval, so the
  project search rests on name matching and on documents retrieved individually.

## 7. Do not repeat

- Do not change the title. The author chose it.
- Do not coin terminology. See section 4.
- Do not run bulk regular-expression substitutions across the manuscript. Two attempts on
  2026-07-30 renamed an R function to an invalid identifier, mangled an output filename to one
  containing a space, and produced unreadable headings. Edit deliberately, and render after
  every change.
- Do not report a number from code that is not saved in the manuscript.
- Do not hide code to make the render look tidy.
