# Pilot summary for the counterfactual audit. Run from this directory:
#   Rscript summarise-pilot.R
# Every number quoted in PILOT-RESULTS.md comes from this script.

d <- read.csv("pilot-coding.csv", stringsAsFactors = FALSE)
n <- nrow(d)

cat("Studies coded:", n, "\n")
cat("  full text:", sum(d$access == "full_text"),
    " partial:", sum(d$access == "partial"), "\n\n")

pc <- function(x) sprintf("%d/%d (%.0f%%)", sum(x), length(x), 100 * mean(x))

cat("H1, prevalence\n")
cat("  reference class present:            ", pc(d$has_reference == 1), "\n")
cat("  degraded-uninvaded class present:   ", pc(d$has_degraded == 1), "\n")
cat("  restored class present:             ", pc(d$has_restored == 1), "\n")
cat("  land-use history of reference: none ", pc(d$history_reported == 0), "\n")
cat("                            quantitative", pc(d$history_reported == 2), "\n")
cat("  states a counterfactual:            ", pc(d$states_counterfactual == 1), "\n")
cat("  acknowledges reverse causation:     ", pc(d$acknowledges_reverse_causation == 1), "\n\n")

cat("Control for confounding\n")
print(table(factor(d$control_method,
                   levels = c("none", "asserted_similarity",
                              "measured_covariates", "statistical_matching"))))

cat("\nDesign\n")
print(table(d$design))

cat("\nSign of the reported carbon effect of invasion\n")
print(table(d$sign))

cat("\nH2, consequence\n")
flip <- d[!is.na(d$sign_flips) & d$sign_flips == 1, ]
cat("  studies with both a reference and a degraded class:",
    sum(d$has_reference == 1 & d$has_degraded == 1), "\n")
cat("  demonstrated sign flips:", nrow(flip),
    if (nrow(flip)) paste0(" (", paste(flip$study, collapse = ", "), ")") else "", "\n\n")

# The Baringo existence proof, computed rather than asserted. Soil organic carbon to 1 m
# plus aboveground carbon, Mbaabu et al. Table 1 and Supplementary Table S7.
baringo <- data.frame(
  class = c("pristine grassland", "degraded grassland", "restored grassland",
            "Prosopis high density"),
  soc   = c(49.76, 31.52, 44.68, 40.05),
  agc   = c( 6.02,  0.69,  3.19, 12.46))
baringo$total <- baringo$soc + baringo$agc
inv <- baringo$total[baringo$class == "Prosopis high density"]

cat("Baringo: total ecosystem carbon by class (Mg C/ha)\n")
print(baringo, row.names = FALSE)
cat("\nEffect of invasion, by choice of counterfactual:\n")
for (i in which(baringo$class != "Prosopis high density")) {
  d_i <- inv - baringo$total[i]
  cat(sprintf("  vs %-22s %+6.2f Mg C/ha  -> %s\n",
              baringo$class[i], d_i, ifelse(d_i > 0, "GAIN", "LOSS")))
}

cat("\nGo / no-go\n")
g1 <- mean(d$history_reported == 2) < 0.5
g2 <- nrow(flip) >= 1
cat("  fewer than half report quantitative history of the reference:", g1, "\n")
cat("  at least one demonstrated sign flip:", g2, "\n")
cat("  VERDICT:", if (g1 && g2) "GO" else "NO-GO", "\n")
