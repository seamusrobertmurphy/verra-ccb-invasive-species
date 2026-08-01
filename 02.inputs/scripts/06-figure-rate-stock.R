# Figure: the rate-stock divergence, the paper's central claim.
# Rate estimates come from the compiled published evidence (02.inputs/rate-evidence.csv);
# stock estimates come from the fitted meta-analysis. The two classes are plotted on one
# log-ratio axis so the divergence is visible directly. Rate entries are individual published
# estimates and are NOT pooled; this is stated on the panel so the figure cannot mislead.
# Run: Rscript 02.inputs/scripts/06-figure-rate-stock.R

suppressPackageStartupMessages(library(metafor))
o <- readRDS("03.outputs/analysis-objects.rds"); soc <- o$soc; res <- o$res
rate <- read.csv("02.inputs/rate-evidence.csv", stringsAsFactors = FALSE)
FIG <- "03.outputs/figures"; dir.create(FIG, recursive = TRUE, showWarnings = FALSE)

AREAL <- c("g/cm2", "kg/m2", "mg ha-1", "mg/ha")
soc$basis <- ifelse(soc$units %in% AREAL, "areal", "concentration")
fitr <- function(s) {
  if (nrow(s) < 6 || length(unique(s$study)) < 3) return(NULL)
  m <- rma.mv(yi, vi, random = ~ 1 | study/obs, data = s, method = "REML")
  c(lr = as.numeric(m$b), lo = m$ci.lb, hi = m$ci.ub, p = m$pval)
}

# ---- assemble the two classes on a common log response ratio scale --------------------
R <- data.frame(label = character(), lr = numeric(), lo = numeric(), hi = numeric(),
                cls = character(), src = character(), stringsAsFactors = FALSE)
add <- function(label, lr, lo = NA, hi = NA, cls, src)
  R <<- rbind(R, data.frame(label, lr, lo, hi, cls, src, stringsAsFactors = FALSE))

# rate estimates, published, individually
for (i in seq_len(nrow(rate))) {
  q <- rate$quantity[i]
  # biomass stock from Pati is added separately below so it sits beside the matching rate;
  # Liao's shoot and root carbon are plant stocks and are classified as such
  if (q == "total biomass stock") next
  lab <- switch(q,
    "carbon sequestration rate" = "Sequestration rate, Gliricidia",
    "live plant biomass carbon" = "Live plant biomass C, rats",
    "non-living pool carbon"    = "Non-living pool C, rats",
    "total ecosystem carbon"    = "Total ecosystem C, rats",
    "shoot carbon stock"        = "Shoot C, global synthesis",
    "root carbon stock"         = "Root C, global synthesis",
    "fluxes including ANPP and litter decomposition" = "ANPP and decomposition, global",
    q)
  cls <- if (grepl("Sequestration rate|ANPP", lab)) "rate or flux" else "stock"
  # a reported range is one estimate, not two: it is added once, after the loop
  if (rate$err_type[i] == "range") next
  add(lab, log(rate$ratio[i]), NA, NA, cls, rate$study[i])
}
rng <- rate[rate$err_type == "range", ]
if (nrow(rng) == 2)
  add("ANPP and decomposition, global", mean(log(rng$ratio)),
      min(log(rng$ratio)), max(log(rng$ratio)), "rate or flux", rng$study[1])

# stock estimates, fitted here
sA <- fitr(soc[soc$basis == "areal", ]); sC <- fitr(soc[soc$basis == "concentration", ])
sAll <- fitr(soc)
add("Soil organic C, all observations", sAll["lr"], sAll["lo"], sAll["hi"], "stock", "this study")
add("Soil organic C, concentration",    sC["lr"],   sC["lo"],   sC["hi"],   "stock", "this study")
add("Soil organic C, areal stock",      sA["lr"],   sA["lo"],   sA["hi"],   "stock", "this study")
pb <- rate[rate$quantity == "total biomass stock", ]
add("Biomass stock, Gliricidia", log(pb$ratio), NA, NA, "stock", pb$study)
for (k in c("MBC", "POC")) {
  r <- res[res$fraction == k, ]
  add(paste0(ifelse(k == "MBC", "Microbial biomass C", "Particulate organic C"), ", fractions"),
      log(1 + r$pct/100), log(1 + r$pct_lb/100), log(1 + r$pct_ub/100), "stock", "this study")
}

R <- R[order(R$cls, R$lr), ]
GREEN <- "#2f6b4f"; GREY <- "#7a7a7a"

png(file.path(FIG, "figure-4-rate-stock.png"), width = 2400, height = 1650, res = 300)
op <- par(mar = c(4.6, 15.5, 2.2, 5.6), family = "sans")
yy <- seq_len(nrow(R))
xr <- range(c(R$lr, R$lo, R$hi), na.rm = TRUE); xr <- xr + c(-0.12, 0.12) * diff(xr)
plot(NA, xlim = xr, ylim = c(0.3, nrow(R) + 0.7), axes = FALSE, xlab = "", ylab = "")
abline(v = 0, col = "grey50", lwd = 1.3)
brk <- which(diff(as.numeric(factor(R$cls))) != 0) + 0.5
abline(h = brk, col = "grey85", lwd = 1)
isr <- R$cls == "rate or flux"
segments(R$lo, yy, R$hi, yy, lwd = 2.2, col = ifelse(isr, GREEN, GREY))
points(R$lr, yy, pch = ifelse(isr, 23, 21), cex = 1.5, lwd = 1.5,
       bg = ifelse(isr, GREEN, "white"), col = ifelse(isr, GREEN, GREY))
# x axis labelled as fold change, which is what the reader wants to see
tk <- log(c(0.5, 1, 2, 4, 8, 16))
tk <- tk[tk >= xr[1] & tk <= xr[2]]
axis(1, at = tk, labels = sprintf("%g", exp(tk)), cex.axis = 0.9)
mtext("Invaded / uninvaded ratio (log scale)", side = 1, line = 2.7, cex = 0.95)
for (i in yy) mtext(R$label[i], side = 2, at = i, las = 1, line = 0.4, cex = 0.78, adj = 1)
for (i in yy) mtext(R$src[i], side = 4, at = i, las = 1, line = 0.3, cex = 0.68,
                    adj = 0, col = "grey35")
pl <- tapply(yy, R$cls, mean)
mtext("Rate or flux", side = 2, at = pl[["rate or flux"]], line = 13.2, cex = 0.85, font = 2)
mtext("Stock",        side = 2, at = pl[["stock"]],        line = 13.2, cex = 0.85, font = 2)
legend("bottomright", bty = "n", cex = 0.72, inset = c(0, 0.02),
       pch = c(23, 21), pt.bg = c(GREEN, "white"), col = c(GREEN, GREY),
       legend = c("rate or flux (published, not pooled)", "stock (fitted or published)"))
par(op); invisible(dev.off())

cat("figure written\n"); print(R, row.names = FALSE, digits = 3)
