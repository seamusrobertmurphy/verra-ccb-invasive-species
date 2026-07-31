# Tidy the He et al. (2025) meta-analysis dataset into long format.
# Source: Dryad doi:10.5061/dryad.c59zw3rkc, deposited with
# He Y, Li J, Siemann E, Li B, Xu Y & Wang Y (2025) Plant invasion increases soil
# microbial biomass carbon. Global Change Biology 31(3): e70109.
#
# The workbook is a two-row header. Columns 1-15 carry study metadata. From column 16
# the sheet is a series of blocks, one per carbon or nitrogen fraction, each 12 columns
# wide, whose name sits in row 1 and whose sub-headers sit in row 2:
#   Data source | index | units | Soil depth (cm) | M_native | SD_native | N_native |
#   M_invasive | SD_invasive | N_invasive | lnRR_<fraction> | (blank separator)
#
# Output: 03.outputs/he2025-long.csv, one row per paired observation per fraction.
# Run: Rscript 02.inputs/scripts/02-tidy-he2025.R

suppressPackageStartupMessages({library(readxl)})

f   <- "02.inputs/dryad-xu2025/Meta-analysis_Data.xlsx"
raw <- suppressMessages(read_excel(f, col_names = FALSE, .name_repair = "minimal"))
raw <- as.data.frame(raw, stringsAsFactors = FALSE)

r1 <- as.character(unlist(raw[1, ]))   # block names
r2 <- as.character(unlist(raw[2, ]))   # sub-headers
dat <- raw[-(1:2), , drop = FALSE]     # data rows

META_N <- 15
meta_names <- r1[1:META_N]
meta <- dat[, 1:META_N, drop = FALSE]
names(meta) <- c("study", "title", "latitude", "longitude", "methods", "habitat",
                 "native_species", "native_family", "native_growth_cycle",
                 "invasive_species", "invasive_family", "invasive_growth_cycle",
                 "invasion_phase", "MAT", "MAP")

# a block starts wherever row 1 carries a name beyond the metadata columns
starts <- which(!is.na(r1) & nzchar(r1) & seq_along(r1) > META_N)
cat("fraction blocks found at columns:", paste(starts, collapse = ", "), "\n")

# the fraction code is the leading token of the block name, e.g. "TC (Total Carbon, ...)"
frac_code <- sub("^\\s*([A-Za-z0-9]+).*$", "\\1", r1[starts])
cat("fractions:", paste(frac_code, collapse = ", "), "\n\n")

SUB <- c("source", "index", "units", "depth",
         "M_native", "SD_native", "N_native",
         "M_invasive", "SD_invasive", "N_invasive", "lnRR")

num <- function(x) suppressWarnings(as.numeric(ifelse(trimws(as.character(x)) %in%
                                                      c("n/a", "NA", "", "-"), NA, x)))

out <- list()
for (i in seq_along(starts)) {
  cols <- starts[i] + (0:10)                 # 11 populated columns; the 12th is a spacer
  cols <- cols[cols <= ncol(dat)]
  blk  <- dat[, cols, drop = FALSE]
  names(blk) <- SUB[seq_along(cols)]

  # verify the sub-headers are where they are expected, rather than assuming it
  got <- r2[cols]
  ok  <- grepl("M_native", got[5]) && grepl("SD_native", got[6]) &&
         grepl("M_invasive", got[8]) && grepl("SD_invasive", got[9])
  if (!ok) { cat("SKIPPED block", frac_code[i], ": unexpected sub-headers\n"); next }

  b <- cbind(meta, fraction = frac_code[i], blk, stringsAsFactors = FALSE)
  for (v in c("M_native","SD_native","N_native","M_invasive","SD_invasive","N_invasive","lnRR"))
    b[[v]] <- num(b[[v]])
  b$depth_raw <- as.character(blk$depth)
  # keep only rows where both means are present; everything else is padding
  b <- b[is.finite(b$M_native) & is.finite(b$M_invasive), , drop = FALSE]
  out[[i]] <- b
}

long <- do.call(rbind, out)
long$MAT <- num(long$MAT); long$MAP <- num(long$MAP)
rownames(long) <- NULL

dir.create("03.outputs", showWarnings = FALSE)
write.csv(long, "03.outputs/he2025-long.csv", row.names = FALSE)

cat("=== paired observations per fraction ===\n")
tab <- as.data.frame(table(long$fraction), stringsAsFactors = FALSE)
names(tab) <- c("fraction", "n_obs")
tab$n_studies <- vapply(tab$fraction, function(k)
  length(unique(long$study[long$fraction == k])), 0L)
tab$pct_with_SD <- round(100 * vapply(tab$fraction, function(k) {
  s <- long[long$fraction == k, ]
  mean(is.finite(s$SD_native) & is.finite(s$SD_invasive)) }, 0), 1)
tab$pct_with_N <- round(100 * vapply(tab$fraction, function(k) {
  s <- long[long$fraction == k, ]
  mean(is.finite(s$N_native) & is.finite(s$N_invasive)) }, 0), 1)
print(tab, row.names = FALSE)

cat("\ntotal paired observations:", nrow(long),
    " studies:", length(unique(long$study)), "\n")
cat("habitats:", paste(sort(unique(na.omit(long$habitat))), collapse = ", "), "\n")
cat("\ndepth values (raw, first 20 unique):\n")
print(head(sort(unique(long$depth_raw)), 20))
