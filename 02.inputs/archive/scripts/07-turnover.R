# Does the invasion effect on carbon decline with the turnover time of the pool?
#
# The paper argues that invasion accelerates cycling rather than building durable stock. That
# argument makes a quantitative prediction the existing data can test directly: the effect of
# invasion on a carbon pool should be largest in the fastest-cycling pools and should fall
# toward zero, or below it, in the slowest. Testing it converts an interpretation into a
# falsifiable hypothesis without requiring any new data.
#
# Turnover classes are assigned from the published characterisation of each operationally
# defined fraction, not from the results, and are fixed before the model is fitted.
# Run: Rscript 02.inputs/scripts/07-turnover.R

suppressPackageStartupMessages(library(metafor))
set.seed(20260801)
o <- readRDS("03.outputs/analysis-objects.rds"); d <- o$d
TBL <- "03.outputs/tables"; FIG <- "03.outputs/figures"
dir.create(TBL, recursive = TRUE, showWarnings = FALSE)

# ---- turnover assignment, fixed a priori ---------------------------------------------
# fast: pools turning over on hours to months, dominated by living or freely soluble material
# intermediate: partially decomposed plant residues, years to decades
# slow: organo-mineral associations, decades to centuries
# mixed: bulk measures aggregating all of the above, excluded from the ordered test
TURNOVER <- c(
  MBC  = "fast",          # microbial biomass, living, days to months
  DOC  = "fast",          # dissolved organic carbon, freely soluble
  WSOC = "fast",          # water-soluble organic carbon, freely soluble
  ROC  = "fast",          # readily oxidisable carbon, operationally labile
  POC  = "intermediate",  # particulate organic matter, plant residues
  MAOC = "slow",          # mineral-associated organic matter
  SOC  = "mixed",         # bulk soil organic carbon
  TC   = "mixed")         # total carbon
RANK <- c(fast = 1, intermediate = 2, slow = 3)

d$turnover <- unname(TURNOVER[d$fraction])
d$turn_rank <- unname(RANK[d$turnover])
d$is_ordered <- !is.na(d$turn_rank)

cat("=== observations by turnover class ===\n")
print(table(factor(d$turnover, levels = c("fast", "intermediate", "slow", "mixed"))))
cat("\nfractions per class:\n")
for (k in c("fast", "intermediate", "slow", "mixed"))
  cat(sprintf("  %-13s %s\n", k, paste(sort(unique(d$fraction[d$turnover == k])), collapse = ", ")))

pct <- function(b) (exp(b) - 1) * 100

# ---- pooled effect within each class -------------------------------------------------
cat("\n=== pooled effect of invasion by turnover class ===\n")
cls <- do.call(rbind, lapply(c("fast", "intermediate", "slow"), function(k) {
  s <- d[which(d$turnover == k), ]
  if (nrow(s) < 6 || length(unique(s$study)) < 3) return(NULL)
  m <- rma.mv(yi, vi, random = ~ 1 | study/obs, data = s, method = "REML")
  data.frame(turnover = k, k_obs = m$k, k_study = length(unique(s$study)),
             pct = pct(as.numeric(m$b)), lo = pct(m$ci.lb), hi = pct(m$ci.ub),
             p = m$pval, stringsAsFactors = FALSE)}))
print(data.frame(Class = cls$turnover, k = cls$k_obs, Studies = cls$k_study,
                 `Change (%)` = sprintf("%+.1f", cls$pct),
                 CI = sprintf("%+.1f to %+.1f", cls$lo, cls$hi),
                 p = signif(cls$p, 3), check.names = FALSE), row.names = FALSE)
write.csv(cls, file.path(TBL, "table-turnover-classes.csv"), row.names = FALSE)

# ---- the ordered test ----------------------------------------------------------------
# Turnover rank is entered as a continuous moderator, which tests the ordered prediction
# directly rather than testing for any difference among classes.
sub <- d[d$is_ordered, ]
m_ord <- rma.mv(yi, vi, mods = ~ turn_rank, random = ~ 1 | study/obs,
                data = sub, method = "REML")
cat(sprintf("\n=== ordered test: effect ~ turnover rank (fast=1, intermediate=2, slow=3) ===\n"))
cat(sprintf("  slope   %+.4f  (95%% CI %+.4f to %+.4f)\n", m_ord$b[2], m_ord$ci.lb[2], m_ord$ci.ub[2]))
cat(sprintf("  QM = %.2f, df = %d, p = %.4f, k = %d observations from %d studies\n",
            m_ord$QM, m_ord$m, m_ord$QMp, m_ord$k, length(unique(sub$study))))
cat(sprintf("  interpretation: each step toward slower turnover changes the effect by %+.1f%%\n",
            pct(m_ord$b[2])))

# categorical form, to confirm the ordered result is not an artefact of the linear coding
m_cat <- rma.mv(yi, vi, mods = ~ factor(turnover), random = ~ 1 | study/obs,
                data = sub, method = "REML")
cat(sprintf("  categorical form: QM = %.2f, df = %d, p = %.4f\n", m_cat$QM, m_cat$m, m_cat$QMp))

saveRDS(list(classes = cls, ordered = m_ord, categorical = m_cat,
             turnover = TURNOVER), "03.outputs/turnover.rds")

# ---- figure --------------------------------------------------------------------------
png(file.path(FIG, "figure-5-turnover.png"), width = 2100, height = 1250, res = 300)
op <- par(mar = c(4.6, 8.0, 1.4, 5.0), family = "sans")
yy <- rev(seq_len(nrow(cls)))
xr <- range(c(cls$lo, cls$hi)); xr <- xr + c(-0.08, 0.10) * diff(xr)
plot(NA, xlim = xr, ylim = c(0.4, nrow(cls) + 0.6), axes = FALSE, xlab = "", ylab = "")
abline(v = 0, col = "grey55", lwd = 1.2)
sig <- cls$p < 0.05
GREEN <- "#2f6b4f"; RED <- "#9b3b3b"; GREY <- "#7a7a7a"
col <- ifelse(sig, ifelse(cls$pct > 0, GREEN, RED), GREY)
segments(cls$lo, yy, cls$hi, yy, lwd = 2.4, col = col)
points(cls$pct, yy, pch = 21, cex = 1.6, lwd = 1.6,
       bg = ifelse(sig, col, "white"), col = col)
axis(1, cex.axis = 0.9)
mtext("Change in carbon under invasion (%)", side = 1, line = 2.6, cex = 0.95)
lab <- c(fast = "Fast\n(days to months)", intermediate = "Intermediate\n(years to decades)",
         slow = "Slow\n(decades to centuries)")
for (i in seq_len(nrow(cls)))
  mtext(lab[cls$turnover[i]], side = 2, at = yy[i], las = 1, line = 0.4, cex = 0.76, adj = 1)
for (i in seq_len(nrow(cls)))
  mtext(sprintf("k=%d (%d)", cls$k_obs[i], cls$k_study[i]), side = 4, at = yy[i],
        las = 1, line = 0.3, cex = 0.7, adj = 0, col = "grey35")
par(op); invisible(dev.off())
cat("\nfigure written to", file.path(FIG, "figure-5-turnover.png"), "\n")
