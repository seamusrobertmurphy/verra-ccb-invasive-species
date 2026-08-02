# Figures for the invasion soil carbon meta-analysis.
# Base R only, so the manuscript renders without additional graphics dependencies.
# Run: Rscript 02.inputs/scripts/04-figures.R

suppressPackageStartupMessages(library(metafor))
o <- readRDS("03.outputs/analysis-objects.rds"); d <- o$d; soc <- o$soc
FIG <- "03.outputs/figures"; dir.create(FIG, recursive = TRUE, showWarnings = FALSE)
pct <- function(b) (exp(b) - 1) * 100

areal <- c("g/cm2", "kg/m2", "mg ha-1", "mg/ha")
d$basis   <- ifelse(d$units %in% areal, "areal", "concentration")
soc$basis <- ifelse(soc$units %in% areal, "areal", "concentration")

fit <- function(s) {
  if (nrow(s) < 6 || length(unique(s$study)) < 3) return(NULL)
  m <- try(rma.mv(yi, vi, random = ~ 1 | study/obs, data = s, method = "REML"), silent = TRUE)
  if (inherits(m, "try-error")) return(NULL)
  c(est = pct(as.numeric(m$b)), lo = pct(m$ci.lb), hi = pct(m$ci.ub),
    k = m$k, ns = length(unique(s$study)), p = m$pval)
}

GREEN <- "#2f6b4f"; RED <- "#9b3b3b"; GREY <- "#6b6b6b"

# ---- Figure 1: pooled effect by carbon fraction -------------------------------------
FR <- c("MBC", "SOC", "MAOC", "DOC", "ROC", "TC", "WSOC", "POC")
LB <- c(MBC = "Microbial biomass C", SOC = "Soil organic C", MAOC = "Mineral-associated C",
        DOC = "Dissolved organic C", ROC = "Readily oxidisable C", TC = "Total C",
        WSOC = "Water-soluble organic C", POC = "Particulate organic C")
rows <- lapply(FR, function(k) fit(d[d$fraction == k, ]))
names(rows) <- FR; rows <- rows[!vapply(rows, is.null, TRUE)]
M <- do.call(rbind, rows)

png(file.path(FIG, "figure-1-fractions.png"), width = 2200, height = 1500, res = 300)
op <- par(mar = c(4.4, 12.5, 1.2, 5.2), family = "sans")
yy <- rev(seq_len(nrow(M)))
xr <- range(c(M[, "lo"], M[, "hi"]), na.rm = TRUE); xr <- xr + c(-0.05, 0.05) * diff(xr)
plot(NA, xlim = xr, ylim = c(0.4, nrow(M) + 0.6), axes = FALSE, xlab = "", ylab = "")
abline(v = 0, col = "grey55", lwd = 1.2)
sig <- M[, "p"] < 0.05
segments(M[, "lo"], yy, M[, "hi"], yy, lwd = 2.4,
         col = ifelse(sig, ifelse(M[, "est"] > 0, GREEN, RED), GREY))
points(M[, "est"], yy, pch = 21, cex = 1.5, lwd = 1.6,
       bg = ifelse(sig, ifelse(M[, "est"] > 0, GREEN, RED), "white"),
       col = ifelse(sig, ifelse(M[, "est"] > 0, GREEN, RED), GREY))
axis(1, cex.axis = 0.9)
mtext("Change under invasion (%)", side = 1, line = 2.6, cex = 0.95)
for (i in seq_len(nrow(M)))
  mtext(LB[rownames(M)[i]], side = 2, at = yy[i], las = 1, line = 0.4, cex = 0.85, adj = 1)
for (i in seq_len(nrow(M)))
  mtext(sprintf("k=%d (%d)", M[i, "k"], M[i, "ns"]), side = 4, at = yy[i],
        las = 1, line = 0.3, cex = 0.72, adj = 0, col = "grey30")
par(op); invisible(dev.off())

# ---- Figure 2: SOC by habitat, depth and measurement basis --------------------------
soc$db <- cut(soc$depth_bot, c(0, 10, 20, 1000), labels = c("0-10 cm", "10-20 cm", ">20 cm"))
grp <- list(
  list(lab = "Wetland and coastal", s = soc[which(soc$habitat_class == "wetland_coastal"), ], panel = 1),
  list(lab = "Grassland",           s = soc[which(soc$habitat_class == "grassland"), ],       panel = 1),
  list(lab = "Forest",              s = soc[which(soc$habitat_class == "forest"), ],          panel = 1),
  list(lab = "0-10 cm",             s = soc[which(soc$db == "0-10 cm"), ],                    panel = 2),
  list(lab = "10-20 cm",            s = soc[which(soc$db == "10-20 cm"), ],                   panel = 2),
  list(lab = ">20 cm",              s = soc[which(soc$db == ">20 cm"), ],                     panel = 2),
  list(lab = "Concentration",       s = soc[soc$basis == "concentration", ],                  panel = 3),
  list(lab = "Areal stock",         s = soc[soc$basis == "areal", ],                          panel = 3))
G <- do.call(rbind, lapply(grp, function(g) {
  f <- fit(g$s); if (is.null(f)) return(NULL)
  data.frame(lab = g$lab, panel = g$panel, t(f), stringsAsFactors = FALSE)}))

png(file.path(FIG, "figure-2-moderators.png"), width = 2200, height = 1700, res = 300)
op <- par(mar = c(4.4, 11.5, 1.2, 5.2), family = "sans")
G <- G[order(G$panel, decreasing = TRUE), ]
yy <- seq_len(nrow(G))
xr <- range(c(G$lo, G$hi), na.rm = TRUE); xr <- xr + c(-0.05, 0.08) * diff(xr)
plot(NA, xlim = xr, ylim = c(0.3, nrow(G) + 0.7), axes = FALSE, xlab = "", ylab = "")
abline(v = 0, col = "grey55", lwd = 1.2)
brk <- which(diff(G$panel) != 0) + 0.5
abline(h = brk, col = "grey85", lwd = 1)
sig <- G$p < 0.05
segments(G$lo, yy, G$hi, yy, lwd = 2.4,
         col = ifelse(sig, ifelse(G$est > 0, GREEN, RED), GREY))
points(G$est, yy, pch = 21, cex = 1.5, lwd = 1.6,
       bg = ifelse(sig, ifelse(G$est > 0, GREEN, RED), "white"),
       col = ifelse(sig, ifelse(G$est > 0, GREEN, RED), GREY))
axis(1, cex.axis = 0.9)
mtext("Change in soil organic carbon under invasion (%)", side = 1, line = 2.6, cex = 0.95)
for (i in yy) mtext(G$lab[i], side = 2, at = i, las = 1, line = 0.4, cex = 0.85, adj = 1)
for (i in yy) mtext(sprintf("k=%d (%d)", G$k[i], G$ns[i]), side = 4, at = i,
                    las = 1, line = 0.3, cex = 0.72, adj = 0, col = "grey30")
pl <- tapply(yy, G$panel, mean)
for (nm in names(pl))
  mtext(c(`1` = "Habitat", `2` = "Depth", `3` = "Measurement")[nm],
        side = 2, at = pl[nm], las = 0, line = 9.6, cex = 0.9, font = 2)
par(op); invisible(dev.off())

# ---- Figure 3: the measurement-basis result, shown as the raw effect sizes ----------
png(file.path(FIG, "figure-3-basis.png"), width = 2200, height = 1300, res = 300)
op <- par(mfrow = c(1, 2), mar = c(4.4, 4.6, 2.4, 1.0), family = "sans")
for (b in c("concentration", "areal")) {
  s <- soc[soc$basis == b, ]
  f <- fit(s)
  plot(s$yi, 1 / sqrt(s$vi), pch = 21, bg = "#ffffffaa", col = "grey35", cex = 1.0,
       xlab = "Log response ratio", ylab = "Precision (1/SE)",
       main = paste0(ifelse(b == "areal", "(b) Areal stock", "(a) Concentration"),
                     sprintf("  %+.1f%%", f["est"])),
       font.main = 1, cex.main = 1.0, xlim = c(-1.6, 2.2))
  abline(v = 0, col = "grey60")
  abline(v = log(1 + f["est"] / 100), col = ifelse(f["p"] < 0.05, GREEN, GREY), lwd = 2.2, lty = 2)
}
par(op); invisible(dev.off())

cat("figures written to", FIG, "\n")
print(M); cat("\n"); print(G, row.names = FALSE)
