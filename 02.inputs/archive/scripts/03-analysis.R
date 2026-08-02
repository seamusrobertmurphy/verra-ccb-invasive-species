# Primary meta-analysis: effect of plant invasion on soil carbon pools.
#
# Data: He et al. (2025) Dryad doi:10.5061/dryad.c59zw3rkc, tidied by 02-tidy-he2025.R.
# Effect size: log response ratio (Hedges, Gurevitch & Curtis 1999) with the second-order
# small-sample bias correction of Lajeunesse (2015). Missing dispersion, where it occurs,
# is handled by the weighted coefficient-of-variation method of Nakagawa et al. (2023).
# Models: multilevel random effects with observations nested in studies (Viechtbauer 2010),
# which accounts for the non-independence of multiple observations per study
# (Noble et al. 2017).
#
# Run: Rscript 02.inputs/scripts/03-analysis.R

suppressPackageStartupMessages({library(metafor)})
set.seed(20260730)

d <- read.csv("03.outputs/he2025-long.csv", stringsAsFactors = FALSE)
dir.create("03.outputs/tables", recursive = TRUE, showWarnings = FALSE)

# ---------------------------------------------------------------- tidy moderators ----
# depth is recorded as a range string; take the midpoint and also keep the lower bound,
# because the hypothesis is that topsoil gains mask deeper losses
parse_depth <- function(x) {
  m <- regmatches(x, regexec("^\\s*([0-9.]+)\\s*-\\s*([0-9.]+)", x))
  t(vapply(m, function(v) if (length(v) == 3) as.numeric(v[2:3]) else c(NA, NA), c(0, 0)))
}
dp <- parse_depth(d$depth_raw)
d$depth_top <- dp[, 1]; d$depth_bot <- dp[, 2]
d$depth_mid <- rowMeans(dp)

# habitat labels are inconsistently cased and spaced in the source; collapse to classes
h <- tolower(gsub("[^a-z]", "", tolower(d$habitat)))
d$habitat_class <- ifelse(grepl("forest|orchard", h), "forest",
                   ifelse(grepl("grass|hill|plain|plateau|terrace|watershed", h), "grassland",
                   ifelse(grepl("wetland|swamp|marsh|mangrove|delta|estuary|beach|shore|island|river", h),
                          "wetland_coastal",
                   ifelse(grepl("ricefield", h), "cropland", NA))))

d$growth_cycle <- ifelse(grepl("^annual", tolower(d$invasive_growth_cycle)), "annual",
                  ifelse(grepl("perenn", tolower(d$invasive_growth_cycle)), "perennial", NA))

# ------------------------------------------------- missing dispersion, if any --------
# Nakagawa et al. (2023): estimate a weighted average coefficient of variation from the
# observations that do report dispersion, then use it to construct the missing SDs.
cv_pool <- function(m, s, n) {
  ok <- is.finite(m) & is.finite(s) & is.finite(n) & m > 0
  sqrt(sum((n[ok] - 1) * (s[ok] / m[ok])^2) / sum(n[ok] - 1))
}
cv_nat <- cv_pool(d$M_native,   d$SD_native,   d$N_native)
cv_inv <- cv_pool(d$M_invasive, d$SD_invasive, d$N_invasive)
d$sd_imputed <- !is.finite(d$SD_native) | !is.finite(d$SD_invasive)
d$SD_native[!is.finite(d$SD_native)]     <- cv_nat * d$M_native[!is.finite(d$SD_native)]
d$SD_invasive[!is.finite(d$SD_invasive)] <- cv_inv * d$M_invasive[!is.finite(d$SD_invasive)]
# where sample size is missing, the smallest observed n is the conservative substitute
nmin <- min(c(d$N_native, d$N_invasive), na.rm = TRUE)
d$N_native[!is.finite(d$N_native)]     <- nmin
d$N_invasive[!is.finite(d$N_invasive)] <- nmin

cat(sprintf("pooled CV: native %.3f, invaded %.3f; dispersion imputed for %d of %d rows (%.1f%%)\n",
            cv_nat, cv_inv, sum(d$sd_imputed), nrow(d), 100 * mean(d$sd_imputed)))

# --------------------------------------------------------------- effect sizes --------
# metafor's ROM gives the uncorrected lnRR and its variance; the Lajeunesse (2015)
# second-order term is added explicitly so the correction is visible rather than assumed
d <- d[d$M_native > 0 & d$M_invasive > 0, ]
es <- escalc(measure = "ROM",
             m1i = d$M_invasive, sd1i = d$SD_invasive, n1i = d$N_invasive,
             m2i = d$M_native,   sd2i = d$SD_native,   n2i = d$N_native)
d$yi_raw <- as.numeric(es$yi); d$vi <- as.numeric(es$vi)
d$yi <- d$yi_raw +
  0.5 * ((d$SD_invasive^2) / (d$N_invasive * d$M_invasive^2) -
         (d$SD_native^2)   / (d$N_native   * d$M_native^2))
d <- d[is.finite(d$yi) & is.finite(d$vi) & d$vi > 0, ]
d$obs <- seq_len(nrow(d))

pct <- function(b) (exp(b) - 1) * 100

# ------------------------------------------------ primary model, SOC stock -----------
fit_frac <- function(k) {
  s <- d[d$fraction == k, ]
  if (length(unique(s$study)) < 3) return(NULL)
  m <- try(rma.mv(yi, vi, random = ~ 1 | study/obs, data = s, method = "REML"), silent = TRUE)
  if (inherits(m, "try-error")) return(NULL)
  # I2 for multilevel models, following Nakagawa & Santos (2012)
  W <- diag(1 / s$vi); X <- model.matrix(m)
  P <- W - W %*% X %*% solve(t(X) %*% W %*% X) %*% t(X) %*% W
  i2 <- 100 * sum(m$sigma2) / (sum(m$sigma2) + (m$k - m$p) / sum(diag(P)))
  data.frame(fraction = k, k_obs = m$k, k_study = length(unique(s$study)),
             lnRR = as.numeric(m$b), se = m$se,
             ci_lb = m$ci.lb, ci_ub = m$ci.ub, pval = m$pval,
             pct = pct(as.numeric(m$b)), pct_lb = pct(m$ci.lb), pct_ub = pct(m$ci.ub),
             I2 = i2, stringsAsFactors = FALSE)
}
FRACS <- c("SOC", "TC", "POC", "MAOC", "MBC", "DOC", "ROC", "WSOC")
res <- do.call(rbind, lapply(FRACS, fit_frac))
res <- res[order(match(res$fraction, FRACS)), ]

cat("\n=== pooled effect of invasion, by carbon fraction ===\n")
print(data.frame(fraction = res$fraction, k = res$k_obs, studies = res$k_study,
                 pct_change = round(res$pct, 1),
                 CI = sprintf("%.1f to %.1f", res$pct_lb, res$pct_ub),
                 p = signif(res$pval, 3), I2 = round(res$I2)), row.names = FALSE)
write.csv(res, "03.outputs/tables/pooled-by-fraction.csv", row.names = FALSE)

# ------------------------------------------------ moderators on SOC ------------------
soc <- d[d$fraction == "SOC", ]
cat("\n=== SOC moderator models (n =", nrow(soc), "obs,",
    length(unique(soc$study)), "studies) ===\n")

mod_test <- function(form, label, data = soc) {
  dd <- data[complete.cases(data[, all.vars(form)]), ]
  if (nrow(dd) < 10 || length(unique(dd$study)) < 3) {
    cat(sprintf("%-26s insufficient data (n=%d)\n", label, nrow(dd))); return(NULL) }
  m <- try(rma.mv(yi, vi, mods = form, random = ~ 1 | study/obs, data = dd, method = "REML"),
           silent = TRUE)
  if (inherits(m, "try-error")) { cat(sprintf("%-26s did not converge\n", label)); return(NULL) }
  cat(sprintf("%-26s QM = %.2f, df = %d, p = %.4f  (n = %d)\n",
              label, m$QM, m$m, m$QMp, nrow(dd)))
  data.frame(moderator = label, QM = m$QM, df = m$m, p = m$QMp, n = nrow(dd),
             stringsAsFactors = FALSE)
}
mods <- do.call(rbind, list(
  mod_test(~ depth_mid,            "soil depth (midpoint)"),
  mod_test(~ factor(habitat_class),"habitat class"),
  mod_test(~ factor(growth_cycle), "invader growth cycle"),
  mod_test(~ MAT,                  "mean annual temperature"),
  mod_test(~ MAP,                  "mean annual precipitation")))
if (!is.null(mods)) write.csv(mods, "03.outputs/tables/soc-moderators.csv", row.names = FALSE)

# depth is the pre-registered prediction: topsoil gain masking deeper loss
m_depth <- try(rma.mv(yi, vi, mods = ~ depth_mid, random = ~ 1 | study/obs,
                      data = soc[is.finite(soc$depth_mid), ], method = "REML"), silent = TRUE)
if (!inherits(m_depth, "try-error")) {
  cat(sprintf("\nSOC ~ depth: slope = %.5f per cm (95%% CI %.5f to %.5f), p = %.4f\n",
              m_depth$b[2], m_depth$ci.lb[2], m_depth$ci.ub[2], m_depth$pval[2]))
}

# shallow versus deep, as a directly interpretable contrast
soc$depth_bin <- ifelse(soc$depth_bot <= 20, "0-20 cm",
                 ifelse(is.finite(soc$depth_bot), ">20 cm", NA))
for (b in c("0-20 cm", ">20 cm")) {
  s <- soc[which(soc$depth_bin == b), ]
  if (nrow(s) >= 8 && length(unique(s$study)) >= 3) {
    m <- rma.mv(yi, vi, random = ~ 1 | study/obs, data = s, method = "REML")
    cat(sprintf("  SOC %-8s %+6.1f%% (95%% CI %+.1f to %+.1f), k = %d, p = %.4f\n",
                b, pct(as.numeric(m$b)), pct(m$ci.lb), pct(m$ci.ub), m$k, m$pval))
  }
}

# ------------------------------------------------ publication bias -------------------
cat("\n=== publication bias, SOC ===\n")
eg <- try(rma.mv(yi, vi, mods = ~ sqrt(vi), random = ~ 1 | study/obs, data = soc,
                 method = "REML"), silent = TRUE)
if (!inherits(eg, "try-error"))
  cat(sprintf("Egger-type regression on sqrt(vi): b = %.3f, p = %.4f\n",
              eg$b[2], eg$pval[2]))
fs <- try(fsn(yi, vi, data = soc, type = "Rosenberg"), silent = TRUE)
if (!inherits(fs, "try-error")) cat("Rosenberg fail-safe N:", fs$fsnum, "\n")

# ------------------------------------------------ sensitivity ------------------------
cat("\n=== sensitivity, SOC pooled effect ===\n")
m_full <- rma.mv(yi, vi, random = ~ 1 | study/obs, data = soc, method = "REML")
cat(sprintf("  %-28s %+6.1f%% (%.1f to %.1f), k = %d\n", "primary (multilevel)",
            pct(as.numeric(m_full$b)), pct(m_full$ci.lb), pct(m_full$ci.ub), m_full$k))
s2 <- soc[!soc$sd_imputed, ]
if (nrow(s2) >= 10) {
  m2 <- rma.mv(yi, vi, random = ~ 1 | study/obs, data = s2, method = "REML")
  cat(sprintf("  %-28s %+6.1f%% (%.1f to %.1f), k = %d\n", "reported dispersion only",
              pct(as.numeric(m2$b)), pct(m2$ci.lb), pct(m2$ci.ub), m2$k))
}
m3 <- rma.mv(yi, rep(1, nrow(soc)), random = ~ 1 | study/obs, data = soc, method = "REML")
cat(sprintf("  %-28s %+6.1f%% (%.1f to %.1f), k = %d\n", "unweighted",
            pct(as.numeric(m3$b)), pct(m3$ci.lb), pct(m3$ci.ub), m3$k))
m4 <- rma(yi, vi, data = soc, method = "REML")
cat(sprintf("  %-28s %+6.1f%% (%.1f to %.1f), k = %d\n", "single-level random effects",
            pct(as.numeric(m4$b)), pct(m4$ci.lb), pct(m4$ci.ub), m4$k))

# POC versus MAOC is the persistence contrast
pm <- d[d$fraction %in% c("POC", "MAOC"), ]
if (length(unique(pm$study)) >= 3) {
  mpm <- try(rma.mv(yi, vi, mods = ~ factor(fraction), random = ~ 1 | study/obs,
                    data = pm, method = "REML"), silent = TRUE)
  if (!inherits(mpm, "try-error"))
    cat(sprintf("\nPOC vs MAOC contrast: QM = %.2f, df = %d, p = %.4f\n",
                mpm$QM, mpm$m, mpm$QMp))
}

saveRDS(list(d = d, soc = soc, res = res), "03.outputs/analysis-objects.rds")
write.csv(d, "03.outputs/he2025-effectsizes.csv", row.names = FALSE)
cat("\nwritten: 03.outputs/he2025-effectsizes.csv, tables/, analysis-objects.rds\n")
