# Primary dataset provenance

`Meta-analysis_Data.xlsx` (164,065 bytes) is **not committed**, per the repository rule that
raw third-party data stays out of git. Retrieve it as follows.

**Source.** He, Y., Li, J., Siemann, E., Li, B., Xu, Y. & Wang, Y. (2025). Plant invasion
increases soil microbial biomass carbon: meta-analysis and empirical tests. *Global Change
Biology* 31(3), e70109. doi:10.1111/gcb.70109

**Data deposit.** Dryad, doi:10.5061/dryad.c59zw3rkc, file `Meta-analysis_Data.xlsx`.

**Retrieval note.** Dryad sits behind a proof-of-work bot challenge, so command-line retrieval
fails and the file must be downloaded through a browser. The API download endpoint requires a
bearer token and returns `{"error":"Unauthorized"}` without one.

**Structure.** A single sheet with a two-row header. Columns 1 to 15 carry study metadata.
From column 16 the sheet is eight blocks of 12 columns, one per carbon fraction (TC, SOC, DOC,
MBC, POC, MAOC, ROC, WSOC), each block carrying data source, index, units, soil depth, and
paired mean, standard deviation and sample size for the native and invaded states. Parsed by
`02.inputs/scripts/02-tidy-he2025.R`, which is committed and reproduces the tidy dataset from
this file alone.

**Directory name.** Retained as `dryad-xu2025` because that is where the file was placed; the
dataset is He et al., not Xu et al.
