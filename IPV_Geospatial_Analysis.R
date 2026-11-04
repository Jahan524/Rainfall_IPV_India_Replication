###############################################################################
# IPV GEOSPATIAL ANALYSIS
# STAGE 1: SPATIAL DATA AUDIT
# NFHS-5 INDIA (2019–21)
###############################################################################

library(sf)
library(dplyr)
library(spdep)
library(ggplot2)
library(tidyr)

# 1. Verify required objects
stopifnot(
  exists("IPV_district_spatial"),
  exists("ADM1_state"),
  exists("IPV_district"),
  exists("ADM2_crosswalk")
)

# 2. Dataset dimensions
cat("\n--- DATASET DIMENSIONS ---\n")

cat(
  "IPV district estimates:",
  nrow(IPV_district), "\n"
)

cat(
  "District spatial polygons:",
  nrow(IPV_district_spatial), "\n"
)

cat(
  "State spatial polygons:",
  nrow(ADM1_state), "\n"
)

# 3. Coordinate reference systems
cat("\n--- COORDINATE REFERENCE SYSTEMS ---\n")

print(st_crs(IPV_district_spatial))
print(st_crs(ADM1_state))

# 4. Geometry validity
cat("\n--- GEOMETRY VALIDATION ---\n")

cat(
  "Invalid district geometries:",
  sum(!st_is_valid(IPV_district_spatial)),
  "\n"
)

cat(
  "Invalid state geometries:",
  sum(!st_is_valid(ADM1_state)),
  "\n"
)

# 5. Missing prevalence estimates
cat("\n--- MISSING IPV ESTIMATES ---\n")

cat(
  "Districts with estimates:",
  sum(!is.na(IPV_district_spatial$ipv_prevalence)),
  "\n"
)

cat(
  "Districts without estimates:",
  sum(is.na(IPV_district_spatial$ipv_prevalence)),
  "\n"
)

# 6. Summary statistics
cat("\n--- IPV PREVALENCE DISTRIBUTION ---\n")

summary(
  IPV_district_spatial$ipv_prevalence
)

# 7. Standard errors and confidence intervals
cat("\n--- UNCERTAINTY VARIABLES ---\n")

names(IPV_district_spatial)

###############################################################################
# STAGE 2: SPATIAL NEIGHBOURHOOD STRUCTURE
# Method: Queen contiguity
###############################################################################

library(sf)
library(dplyr)
library(spdep)

# Keep only districts with IPV estimates
IPV_analysis_sf <- IPV_district_spatial %>%
  filter(!is.na(ipv_prevalence)) %>%
  mutate(
    spatial_id = row_number()
  )

# Check observations
cat("Analytical districts:", nrow(IPV_analysis_sf), "\n")

# Ensure unique district identifiers
stopifnot(
  !anyDuplicated(IPV_analysis_sf$spatial_id),
  !anyDuplicated(IPV_analysis_sf$shapeID)
)

# Repair geometry defensively
IPV_analysis_sf <- st_make_valid(IPV_analysis_sf)

# Transform to projected equal-area CRS
IPV_analysis_projected <- st_transform(
  IPV_analysis_sf,
  crs = 6933
)

cat(
  "Projected CRS:",
  st_crs(IPV_analysis_projected)$input,
  "\n"
)

###############################################################################
# QUEEN CONTIGUITY NEIGHBOURS
###############################################################################

queen_nb <- poly2nb(
  IPV_analysis_projected,
  queen = TRUE,
  row.names = as.character(IPV_analysis_projected$spatial_id),
  snap = 1
)

# Number of neighbours per district
neighbour_count <- card(queen_nb)

# Summary
cat("\n--- QUEEN CONTIGUITY SUMMARY ---\n")

cat("Total districts:", length(queen_nb), "\n")

cat("Minimum neighbours:", min(neighbour_count), "\n")

cat("Maximum neighbours:", max(neighbour_count), "\n")

cat("Average neighbours:", mean(neighbour_count), "\n")

cat("Median neighbours:", median(neighbour_count), "\n")

cat("Districts without neighbours:",
    sum(neighbour_count == 0), "\n")

# Neighbour count distribution
Neighbour_Summary <- data.frame(
  spatial_id = IPV_analysis_projected$spatial_id,
  state = IPV_analysis_projected$state_name_geo,
  district = IPV_analysis_projected$district_name_geo,
  ipv_prevalence = IPV_analysis_projected$ipv_prevalence,
  n_neighbours = neighbour_count
)

summary(Neighbour_Summary$n_neighbours)

View(Neighbour_Summary)