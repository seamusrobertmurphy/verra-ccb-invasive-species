# Taxonomic, geographic and methodological coverage of the compiled evidence.
# The pooled estimates are only as general as the studies behind them, so the composition
# of the evidence base is reported as a result rather than left implicit.
# Run: Rscript 02.inputs/scripts/05-coverage.R

o <- readRDS("03.outputs/analysis-objects.rds")
d <- o$d; soc <- o$soc
TBL <- "03.outputs/tables"; dir.create(TBL, recursive = TRUE, showWarnings = FALSE)

# Species names in the source are run together, carry trailing authorities, and contain
# transcription errors. They are mapped explicitly rather than reformatted by rule, so that
# every correction is visible and auditable. Source spelling is retained on the left.
SPECIES_MAP <- c(
  "S.alterniflora"                        = "Spartina alterniflora",
  "Phyllostachysedulis"                   = "Phyllostachys edulis",
  "P.australis"                           = "Phragmites australis",
  "Leucaeleucocephala(Lam.)deWit"         = "Leucaena leucocephala",
  "Prosopisjuliflora (Sw.)DC."            = "Prosopis juliflora",
  "Bromustectorum L."                     = "Bromus tectorum",
  "Mikaniamicrantha KunthinHumb.&al."     = "Mikania micrantha",
  "Ipomoeacairica (L.)Sweet)"             = "Ipomoea cairica",
  "Sphagneticolatrilobata(L.)Pruski"      = "Sphagneticola trilobata",
  "Chromolaeodorata (L.)R.M.King&H.Rob.)" = "Chromolaena odorata",
  "Chromolaeodorata L."                   = "Chromolaena odorata",
  "AmbrosiaartemisiifoliaL."              = "Ambrosia artemisiifolia",
  "Sonneratiaapetala Buch.-Ham."          = "Sonneratia apetala",
  "Robiniapseudoacacia L."                = "Robinia pseudoacacia",
  "Bidenspilosa L."                       = "Bidens pilosa",
  "Polygonumcuspidatum"                   = "Reynoutria japonica",
  "Puerariamonta"                         = "Pueraria montana",
  "Praxelisclematidea"                    = "Praxelis clematidea",
  "A.fruticosa"                           = "Amorpha fruticosa")
# note: Chromolaena is misspelled "Chromolaeo" throughout the source; Polygonum cuspidatum
# is the basionym of Reynoutria japonica and is standardised to the accepted name.

# Matching is done on a normalised key (letters only, lower case) because the source varies
# in spacing, authority citation and punctuation for the same taxon, for example
# "Phyllostachysedulis" and "Phyllostachy sedulis".
norm_key <- function(x) tolower(gsub("[^A-Za-z]", "", x))
KEY_MAP <- setNames(SPECIES_MAP, norm_key(names(SPECIES_MAP)))

tidy_sp <- function(x) {
  k <- norm_key(x)
  out <- unname(KEY_MAP[k])
  fallback <- trimws(gsub("\\s*\\(.*?\\)|[A-Z]\\.[A-Za-z]*&.*$|\\s+[A-Z][a-z]*\\.?$", "", x))
  ifelse(is.na(out), fallback, out)
}
soc$species <- tidy_sp(soc$invasive_species)
cat("species names resolved by explicit map:",
    sum(norm_key(soc$invasive_species) %in% names(KEY_MAP)), "of", nrow(soc),
    "observations\n\n")
soc$family  <- trimws(gsub("[A-Z][a-z]*\\.\\s*&.*$|Bercht.*$|Juss\\.$", "", soc$invasive_family))

# ---- species concentration -----------------------------------------------------------
sp <- sort(table(soc$species), decreasing = TRUE)
top <- data.frame(Species = names(sp), Observations = as.integer(sp),
                  `Share (%)` = round(100 * as.integer(sp) / nrow(soc), 1),
                  check.names = FALSE)
top$Studies <- vapply(top$Species, function(s)
  length(unique(soc$study[soc$species == s])), 0L)
cat("=== invasive taxa contributing soil organic carbon observations ===\n")
print(head(top, 10), row.names = FALSE)
cat(sprintf("\ntaxa represented: %d; top taxon share: %.1f%%; top three share: %.1f%%\n",
            nrow(top), top$`Share (%)`[1], sum(top$`Share (%)`[1:3])))
write.csv(top, file.path(TBL, "table-coverage-species.csv"), row.names = FALSE)

# ---- family concentration ------------------------------------------------------------
fm <- sort(table(soc$family), decreasing = TRUE)
famtab <- data.frame(Family = names(fm), Observations = as.integer(fm),
                     `Share (%)` = round(100 * as.integer(fm) / nrow(soc), 1),
                     check.names = FALSE)
cat("\n=== families ===\n"); print(head(famtab, 6), row.names = FALSE)
write.csv(famtab, file.path(TBL, "table-coverage-family.csv"), row.names = FALSE)

# ---- study design --------------------------------------------------------------------
cat("\n=== design and setting ===\n")
cat("  field studies    :", sum(soc$methods == "field"), "observations\n")
cat("  greenhouse       :", sum(soc$methods == "greenhouse"), "observations\n")
cat("  invasion phase   :", paste(names(table(soc$invasion_phase)),
                                  table(soc$invasion_phase), collapse = "; "), "\n")

# ---- coordinate integrity -------------------------------------------------------------
# latitudes above 90 degrees indicate longitude values entered in the latitude field, so
# the coordinates are not used as moderators; this is recorded rather than silently ignored
lat <- suppressWarnings(as.numeric(sub("[-–].*", "", soc$latitude)))
bad <- sum(is.finite(lat) & abs(lat) > 90)
cat(sprintf("\ncoordinates: %d of %d observations parse; %d give latitudes beyond 90 degrees,\n",
            sum(is.finite(lat)), nrow(soc), bad))
cat("so the coordinate fields are unreliable and were not used as moderators.\n")

saveRDS(list(species = top, family = famtab), "03.outputs/coverage.rds")
