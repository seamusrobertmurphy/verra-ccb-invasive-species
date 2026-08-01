# The rate limb: a formal meta-analysis of carbon and nutrient fluxes under invasion.
#
# Data: Negesse et al. (2025) Plant and Soil, deposited at Dryad doi:10.5061/dryad.hhmgqnkq5.
# 688 paired invaded and uninvaded observations from 110 sites, carrying soil respiration,
# nitrogen transformation rates, extracellular enzyme activities, microbial pools and faunal
# abundances. Soil respiration is a direct carbon flux and is the quantity the paper's rate
# limb has until now lacked.
#
# Effect sizes are recomputed here rather than taken from the deposit's own lnRR column, so
# that the flux and stock limbs use identical methods: log response ratio with the Lajeunesse
# (2015) small-sample correction, multilevel random effects with observations nested in study.
# Run: Rscript 02.inputs/scripts/08-flux.R

suppressPackageStartupMessages(library(metafor))
set.seed(20260801)
TBL <- "03.outputs/tables"; FIG <- "03.outputs/figures"
dir.create(TBL, recursive = TRUE, showWarnings = FALSE)

f <- "02.inputs/dryad-negesse2025/Datasets.csv"
# the deposit is not UTF-8; it is read as latin1 and the response labels are matched by
# pattern rather than by exact string, because the beta of beta-glucosidase does not survive
x <- read.csv(f, stringsAsFactors = FALSE, fileEncoding = "latin1", check.names = FALSE)
names(x) <- make.names(names(x))
x$var <- trimws(x$Soil.response.variables)
# Clustering unit. The deposit carries no complete study identifier: the Authors field is
# blank for 581 of 688 rows (84.4%) and Case_studies is a row index rather than a source
# publication. The site coordinates, by contrast, are present on every row and resolve to 110
# distinct locations, so the coordinate pair is used as the clustering unit and the author
# string is carried forward within each site to recover the source publication where it exists.
x$site <- paste(trimws(x$Northing), trimws(x$Easting))
bad <- function(v) is.na(v) | trimws(as.character(v)) %in% c("", "NA", "na")
au <- ifelse(bad(x$Authors), NA_character_, trimws(x$Authors))
x$source <- ave(au, x$site, FUN = function(v) { u <- unique(v[!is.na(v)])
  if (length(u) == 1) u else NA_character_ })
x$study <- x$site

# ---- classify response variables ------------------------------------------------------
# The classification is functional, not statistical, and is fixed before any model is fitted.
CARBON_FLUX <- c("Soil respiration")
CARBON_ENZ_PAT <- "glucosidase|Cellulase|Invertase|Glucosamidase|oxidase|Peroxidase|Catalase"
NUTRIENT_ENZ <- c("Urease", "Acid phosphotase", "Alkaline phosphotase", "Protase",
                  "Glycine amino-peptidase")
NUTRIENT_RATE <- c("N-Mineralization", "N-nitrification")
MICROBIAL_POOL <- c("Microbial biomass", "MBC", "MBN", "Bacteria biomass",
                    "Fungal biomass", "AMF biomass", "Actinomycete biomass")

x$class <- ifelse(x$var %in% CARBON_FLUX,    "carbon flux",
           ifelse(grepl(CARBON_ENZ_PAT, x$var, ignore.case = TRUE), "carbon-acquiring enzyme",
           ifelse(x$var %in% NUTRIENT_ENZ,   "nutrient-acquiring enzyme",
           ifelse(x$var %in% NUTRIENT_RATE,  "nutrient transformation rate",
           ifelse(x$var %in% MICROBIAL_POOL, "microbial pool", "faunal abundance")))))

num <- function(v) suppressWarnings(as.numeric(as.character(v)))
x$mc <- num(x$Mean_Control); x$sc <- num(x$SD_Control); x$nc <- num(x$N_Control)
x$mt <- num(x$Mean_Treatment); x$st <- num(x$SD_Treatment); x$nt <- num(x$N_Treatment)

# ---- construct missing dispersion, as in the stock limb --------------------------------
cvp <- function(m, s, n) { ok <- is.finite(m) & is.finite(s) & is.finite(n) & m > 0
  sqrt(sum((n[ok]-1)*(s[ok]/m[ok])^2)/sum(n[ok]-1)) }
cv_c <- cvp(x$mc, x$sc, x$nc); cv_t <- cvp(x$mt, x$st, x$nt)
x$sd_imputed <- !is.finite(x$sc) | !is.finite(x$st)
x$sc[!is.finite(x$sc)] <- cv_c * x$mc[!is.finite(x$sc)]
x$st[!is.finite(x$st)] <- cv_t * x$mt[!is.finite(x$st)]
nmin <- min(c(x$nc, x$nt), na.rm = TRUE)
x$nc[!is.finite(x$nc)] <- nmin; x$nt[!is.finite(x$nt)] <- nmin

x <- x[is.finite(x$mc) & is.finite(x$mt) & x$mc > 0 & x$mt > 0, ]
es <- escalc(measure = "ROM", m1i = x$mt, sd1i = x$st, n1i = x$nt,
                              m2i = x$mc, sd2i = x$sc, n2i = x$nc)
x$yi <- as.numeric(es$yi) +
  0.5*((x$st^2)/(x$nt*x$mt^2) - (x$sc^2)/(x$nc*x$mc^2))   # Lajeunesse (2015)
x$vi <- as.numeric(es$vi)
x <- x[is.finite(x$yi) & is.finite(x$vi) & x$vi > 0, ]
x$obs <- seq_len(nrow(x))

cat(sprintf("usable paired observations: %d from %d sites in %d countries on %d continents\n",
            nrow(x), length(unique(x$study)), length(unique(x$Country)),
            length(unique(x$Continent))))
cat(sprintf("named source publications recovered for %d of %d sites; dispersion imputed for %.1f%%\n\n",
            length(unique(na.omit(x$source))), length(unique(x$study)), 100*mean(x$sd_imputed)))

pct <- function(b) (exp(b)-1)*100
fitc <- function(s, lab) {
  if (nrow(s) < 6 || length(unique(s$study)) < 3) return(NULL)
  m <- try(rma.mv(yi, vi, random = ~ 1 | study/obs, data = s, method = "REML"), silent = TRUE)
  if (inherits(m, "try-error")) return(NULL)
  data.frame(class = lab, k_obs = m$k, k_study = length(unique(s$study)),
             pct = pct(as.numeric(m$b)), lo = pct(m$ci.lb), hi = pct(m$ci.ub),
             p = m$pval, stringsAsFactors = FALSE)
}

CLS <- c("carbon flux", "nutrient transformation rate", "nutrient-acquiring enzyme",
         "carbon-acquiring enzyme", "microbial pool", "faunal abundance")
fx <- do.call(rbind, lapply(CLS, function(k) fitc(x[x$class == k, ], k)))
cat("=== effect of invasion by functional class ===\n")
print(data.frame(Class = fx$class, k = fx$k_obs, Studies = fx$k_study,
                 `Change (%)` = sprintf("%+.1f", fx$pct),
                 CI = sprintf("%+.1f to %+.1f", fx$lo, fx$hi),
                 p = signif(fx$p, 3), check.names = FALSE), row.names = FALSE)
write.csv(fx, file.path(TBL, "table-flux-classes.csv"), row.names = FALSE)

# ---- soil respiration alone, the headline carbon flux ---------------------------------
sr <- x[x$class == "carbon flux", ]
m_sr <- rma.mv(yi, vi, random = ~ 1 | study/obs, data = sr, method = "REML")
cat(sprintf("\nsoil respiration: %+.1f%% (95%% CI %+.1f to %+.1f), k = %d from %d sites, p = %.4f\n",
            pct(as.numeric(m_sr$b)), pct(m_sr$ci.lb), pct(m_sr$ci.ub),
            m_sr$k, length(unique(sr$study)), m_sr$pval))

# ---- the carbon versus nutrient enzyme asymmetry --------------------------------------
en <- x[x$class %in% c("carbon-acquiring enzyme", "nutrient-acquiring enzyme"), ]
m_en <- rma.mv(yi, vi, mods = ~ factor(class), random = ~ 1 | study/obs,
               data = en, method = "REML")
cat(sprintf("carbon vs nutrient enzymes: QM = %.2f, df = %d, p = %.4f\n",
            m_en$QM, m_en$m, m_en$QMp))

# ---- the formal flux-against-stock contrast -------------------------------------------
# Soil respiration from this dataset is set against soil carbon stocks from the stock limb in a
# single model with a limb indicator as moderator. The stock limb is restricted to observations
# reported on an areal basis, because a concentration is not a stock: expressing carbon per unit
# mass of soil leaves the bulk density change under invasion uncontrolled, and it is precisely
# that confound the areal restriction removes. The contrast against the unrestricted stock limb
# is reported alongside it, so the effect of the restriction is visible rather than assumed.
o <- readRDS("03.outputs/analysis-objects.rds"); soc <- o$soc
AREAL <- c("g/cm2", "kg/m2", "mg ha-1", "mg/ha")
soc$basis <- ifelse(soc$units %in% AREAL, "areal", "concentration")

fl <- data.frame(yi = sr$yi, vi = sr$vi,
                 study = paste0("F_", sr$study), limb = "flux", stringsAsFactors = FALSE)
contrast <- function(sub, lab) {
  st <- data.frame(yi = sub$yi, vi = sub$vi,
                   study = paste0("S_", sub$study), limb = "stock", stringsAsFactors = FALSE)
  both <- rbind(st, fl); both$obs <- seq_len(nrow(both))
  m <- rma.mv(yi, vi, mods = ~ factor(limb), random = ~ 1 | study/obs,
              data = both, method = "REML")
  cat(sprintf("  %-28s QM = %5.2f, df = %d, p = %.5f   flux exceeds stock by %+.1f%%  (%d stock obs)\n",
              lab, m$QM, m$m, m$QMp, pct(-m$b[2]), nrow(st)))
  m
}
cat("\n=== flux versus stock, formal contrast ===\n")
cat(sprintf("  soil respiration limb: %d observations from %d sites\n",
            nrow(fl), length(unique(sr$study))))
m_areal <- contrast(soc[soc$basis == "areal", ],        "against areal stock")
m_conc  <- contrast(soc[soc$basis == "concentration", ],"against concentration stock")
m_all   <- contrast(soc,                                 "against all stock observations")

# ---- forest subset --------------------------------------------------------------------
# The paper concerns forest carbon, so the flux result is refitted on the forest observations
# alone. This is a subset of an existing analysis, not a new hypothesis.
fo <- x[trimws(x$Forest.vs.Non.forest) == "Forest", ]
m_for <- rma.mv(yi, vi, random = ~ 1 | study/obs, data = fo, method = "REML")
frs <- fo[fo$class == "carbon flux", ]
cat(sprintf("\n=== forest subset ===\n  all responses  %+.1f%% (%+.1f to %+.1f), k = %d from %d sites, p = %.4f\n",
            pct(as.numeric(m_for$b)), pct(m_for$ci.lb), pct(m_for$ci.ub),
            m_for$k, length(unique(fo$study)), m_for$pval))
m_frs <- NULL
if (nrow(frs) >= 6 && length(unique(frs$study)) >= 3) {
  m_frs <- rma.mv(yi, vi, random = ~ 1 | study/obs, data = frs, method = "REML")
  cat(sprintf("  soil respiration %+.1f%% (%+.1f to %+.1f), k = %d from %d sites, p = %.4f\n",
              pct(as.numeric(m_frs$b)), pct(m_frs$ci.lb), pct(m_frs$ci.ub),
              m_frs$k, length(unique(frs$study)), m_frs$pval))
} else {
  cat(sprintf("  soil respiration: too few forest observations to fit (k = %d from %d sites)\n",
              nrow(frs), length(unique(frs$study))))
}

saveRDS(list(x = x, classes = fx, respiration = m_sr, enzymes = m_en,
             contrast_areal = m_areal, contrast_conc = m_conc, contrast_all = m_all,
             forest = m_for, forest_resp = m_frs,
             n_forest_site = length(unique(fo$study)),
             n_forest_resp_site = length(unique(frs$study)),
             n_obs = nrow(x), n_study = length(unique(x$study)),
             n_country = length(unique(x$Country)),
             n_source = length(unique(na.omit(x$source)))), "03.outputs/flux.rds")

# ---- figure ---------------------------------------------------------------------------
png(file.path(FIG, "figure-6-flux.png"), width = 2300, height = 1450, res = 300)
op <- par(mar = c(4.6, 13.5, 1.4, 5.0), family = "sans")
fx2 <- fx[order(fx$pct), ]; yy <- seq_len(nrow(fx2))
xr <- range(c(fx2$lo, fx2$hi)); xr <- xr + c(-0.08, 0.10)*diff(xr)
plot(NA, xlim = xr, ylim = c(0.4, nrow(fx2)+0.6), axes = FALSE, xlab = "", ylab = "")
abline(v = 0, col = "grey55", lwd = 1.2)
GREEN <- "#2f6b4f"; RED <- "#9b3b3b"; GREY <- "#7a7a7a"
sig <- fx2$p < 0.05; col <- ifelse(sig, ifelse(fx2$pct > 0, GREEN, RED), GREY)
segments(fx2$lo, yy, fx2$hi, yy, lwd = 2.4, col = col)
points(fx2$pct, yy, pch = 21, cex = 1.6, lwd = 1.6,
       bg = ifelse(sig, col, "white"), col = col)
axis(1, cex.axis = 0.9)
mtext("Change under invasion (%)", side = 1, line = 2.6, cex = 0.95)
for (i in yy) mtext(fx2$class[i], side = 2, at = i, las = 1, line = 0.4, cex = 0.8, adj = 1)
for (i in yy) mtext(sprintf("k=%d (%d)", fx2$k_obs[i], fx2$k_study[i]), side = 4, at = i,
                    las = 1, line = 0.3, cex = 0.7, adj = 0, col = "grey35")
par(op); invisible(dev.off())
cat("\nfigure written\n")
