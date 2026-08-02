# Probe the structure of the He et al. (2025) meta-analysis dataset before any modelling.
# Source: Dryad doi:10.5061/dryad.c59zw3rkc, deposited with
# He, Li, Siemann, Li, Xu & Wang (2025) Global Change Biology 31(3): e70109.
#
# Run:  Rscript 02.inputs/scripts/01-probe-he2025.R
# Purpose is only to report what is in the file: sheets, columns, sample sizes,
# which carbon fractions are present, and how much dispersion is actually reported.
# Nothing is modelled here and nothing is written.

f <- "02.inputs/dryad-xu2025/Meta-analysis_Data.xlsx"
if (!file.exists(f)) stop("Dataset not present at ", f,
                          "\nDownload from https://doi.org/10.5061/dryad.c59zw3rkc")

suppressPackageStartupMessages(library(readxl))

sheets <- excel_sheets(f)
cat("SHEETS:", paste(sheets, collapse = " | "), "\n\n")

for (s in sheets) {
  d <- suppressWarnings(read_excel(f, sheet = s))
  cat("=== sheet:", s, " rows:", nrow(d), " cols:", ncol(d), "===\n")
  print(data.frame(col = names(d),
                   type = vapply(d, function(x) class(x)[1], ""),
                   n_nonmissing = vapply(d, function(x) sum(!is.na(x)), 0L),
                   row.names = NULL))

  # which carbon fractions appear anywhere in the sheet, as column names or as values
  frac <- c("SOC", "MBC", "POC", "MAOC", "DOC", "ROC", "TC", "TN", "MBN")
  incol <- frac[vapply(frac, function(p) any(grepl(p, names(d), ignore.case = FALSE)), TRUE)]
  chr   <- d[vapply(d, is.character, TRUE)]
  inval <- if (ncol(chr)) {
    u <- unique(unlist(lapply(chr, unique)))
    frac[vapply(frac, function(p) any(grepl(paste0("^", p, "$"), u)), TRUE)]
  } else character(0)
  cat("\ncarbon fractions in column names:", paste(incol, collapse = ", "), "\n")
  cat("carbon fractions as values      :", paste(inval, collapse = ", "), "\n")

  # a meta-analysis needs paired means, SDs and sample sizes; report how many are present,
  # because the share of missing SDs decides whether the Nakagawa et al. (2023) weighted
  # coefficient of variation method is required
  pat <- c(mean = "mean|_m$|^m_", sd = "sd|SD", se = "se|SE", n = "^n_|_n$|sample")
  for (nm in names(pat)) {
    hit <- names(d)[grepl(pat[[nm]], names(d), ignore.case = TRUE)]
    cat(sprintf("%-5s columns: %s\n", nm, if (length(hit)) paste(hit, collapse = ", ") else "none"))
  }
  cat("\nfirst 3 rows:\n"); print(utils::head(as.data.frame(d), 3))
  cat("\n\n")
}
