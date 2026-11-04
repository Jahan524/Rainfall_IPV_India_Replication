###############################################################################
# IPV spatial crosswalk and mapping
# Required objects: state_ipv, district_ipv, india_adm1, india_adm2
# Required fields: state_ipv(state_name, ipv_prevalence);
# district_ipv(state_name, district_name, ipv_prevalence)
# NFHS-5 INDIA (2019–21)
###############################################################################

library(sf)
library(dplyr)
library(stringr)
library(stringi)
library(ggplot2)

stopifnot(
  exists("state_ipv"), exists("district_ipv"),
  exists("india_adm1"), exists("india_adm2"),
  all(c("state_name", "ipv_prevalence") %in% names(state_ipv)),
  all(c("state_name", "district_name", "ipv_prevalence") %in% names(district_ipv))
)

normalize_name <- function(x) {
  x |>
    stringi::stri_trans_general("Latin-ASCII") |>
    stringr::str_to_lower() |>
    stringr::str_replace_all("&", "and") |>
    stringr::str_replace_all("[^a-z0-9 ]", " ") |>
    stringr::str_squish()
}

# ADM1 state lookup
ADM1_lookup <- india_adm1 |>
  st_drop_geometry() |>
  transmute(state_name_geo = shapeName, state_iso_geo = shapeISO,
            state_match = normalize_name(shapeName))


###############################################################################
# REBUILD ADM2 STATE ASSIGNMENT
###############################################################################

# 1. Repair ADM2 geometry
ADM2_valid <- india_adm2 %>%
  st_make_valid()

# 2. Transform both boundary layers to a projected CRS
# EPSG:7755 is an India-wide projected CRS (check availability in your sf/GDAL).
# Use this only for the point-in-polygon operation.
ADM1_projected <- st_transform(india_adm1, 7755)
ADM2_projected <- st_transform(ADM2_valid, 7755)

# 3. Prepare ADM1 lookup AS AN sf OBJECT
ADM1_lookup <- ADM1_projected %>%
  select(
    state_name_geo = shapeName,
    state_iso_geo = shapeISO
  ) %>%
  mutate(
    state_match = normalize_name(state_name_geo)
  )

# 4. Create internal points for ADM2 districts
ADM2_points <- st_point_on_surface(ADM2_projected)

# 5. Spatially assign ADM1 state to each ADM2 district
ADM2_state_lookup <- ADM2_points %>%
  st_join(
    ADM1_lookup,
    join = st_within,
    left = TRUE
  ) %>%
  st_drop_geometry() %>%
  select(
    shapeID,
    state_name_geo,
    state_iso_geo,
    state_match
  )

# 6. Attach state information to original ADM2 geometry
ADM2_crosswalk <- ADM2_valid %>%
  left_join(
    ADM2_state_lookup,
    by = "shapeID"
  ) %>%
  rename(
    district_name_geo = shapeName
  )

# 7. Correct Lakshadweep if necessary
ADM2_crosswalk <- ADM2_crosswalk %>%
  mutate(
    state_name_geo = if_else(
      normalize_name(district_name_geo) == "lakshadweep" &
        is.na(state_name_geo),
      "Lakshadweep",
      state_name_geo
    ),
    state_iso_geo = if_else(
      normalize_name(district_name_geo) == "lakshadweep" &
        is.na(state_iso_geo),
      "IN-LD",
      state_iso_geo
    ),
    state_match = if_else(
      normalize_name(district_name_geo) == "lakshadweep" &
        is.na(state_match),
      "lakshadweep",
      state_match
    )
  )

###############################################################################
# VALIDATION
###############################################################################

cat("ADM2 polygons:", nrow(ADM2_crosswalk), "\n")

cat(
  "Districts without state assignment:",
  sum(is.na(ADM2_crosswalk$state_name_geo)),
  "\n"
)

cat(
  "States represented:",
  n_distinct(ADM2_crosswalk$state_match, na.rm = TRUE),
  "\n"
)

ADM2_District_Count <- ADM2_crosswalk %>%
  st_drop_geometry() %>%
  count(state_name_geo, sort = TRUE)

print(as_tibble(ADM2_District_Count), n = Inf)

Unassigned_ADM2 <- ADM2_crosswalk %>%
  filter(is.na(state_name_geo))

st_drop_geometry(Unassigned_ADM2) %>%
  select(shapeName = district_name_geo,
         shapeID,
         state_name_geo,
         state_iso_geo)

plot(
  st_geometry(india_adm1),
  col = "grey95",
  border = "grey50"
)

plot(
  st_geometry(Unassigned_ADM2),
  add = TRUE,
  col = "red",
  border = "red",
  lwd = 2
)

###############################################################################
# CORRECT SOUTH TWENTY FOUR PARGANAS
###############################################################################

ADM2_crosswalk <- ADM2_crosswalk %>%
  mutate(
    state_name_geo = if_else(
      normalize_name(district_name_geo) == "south twenty four parganas",
      "West Bengal",
      state_name_geo
    ),
    state_iso_geo = if_else(
      normalize_name(district_name_geo) == "south twenty four parganas",
      "IN-WB",
      state_iso_geo
    ),
    state_match = if_else(
      normalize_name(district_name_geo) == "south twenty four parganas",
      "west bengal",
      state_match
    )
  )

# Validate the correction
cat(
  "Unassigned districts:",
  sum(is.na(ADM2_crosswalk$state_name_geo)),
  "\n"
)

cat(
  "Represented states/UTs:",
  n_distinct(ADM2_crosswalk$state_match, na.rm = TRUE),
  "\n"
)

# Verify the corrected district
ADM2_crosswalk %>%
  st_drop_geometry() %>%
  filter(normalize_name(district_name_geo) == "south twenty four parganas") %>%
  select(district_name_geo, state_name_geo, state_iso_geo, state_match)

ADM2_District_Count <- ADM2_crosswalk %>%
  st_drop_geometry() %>%
  count(state_name_geo, sort = TRUE)

View(ADM2_District_Count)

dir.create(
  "D:/SNCC/IPV_Mapping_Output",
  recursive = TRUE,
  showWarnings = FALSE
)
write.csv(
  ADM2_District_Count,
  "D:/SNCC/IPV_Mapping_Output/ADM2_District_Count.csv",
  row.names = FALSE
)
###############################################################################
# CORRECT SOUTH TWENTY FOUR PARGANAS
###############################################################################

ADM2_crosswalk <- ADM2_crosswalk %>%
  mutate(
    state_name_geo = if_else(
      normalize_name(district_name_geo) == "south twenty four parganas",
      "West Bengal",
      state_name_geo
    ),
    state_iso_geo = if_else(
      normalize_name(district_name_geo) == "south twenty four parganas",
      "IN-WB",
      state_iso_geo
    ),
    state_match = if_else(
      normalize_name(district_name_geo) == "south twenty four parganas",
      "west bengal",
      state_match
    )
  )

# Recreate the unassigned object AFTER correction
Unassigned_ADM2 <- ADM2_crosswalk %>%
  filter(is.na(state_name_geo))

# Validation
cat("Unassigned districts:",
    nrow(Unassigned_ADM2), "\n")

cat("Represented states:",
    n_distinct(ADM2_crosswalk$state_match, na.rm = TRUE), "\n")

# Inspect the corrected district
ADM2_crosswalk %>%
  st_drop_geometry() %>%
  filter(normalize_name(district_name_geo) == "south twenty four parganas") %>%
  select(district_name_geo, state_name_geo, state_iso_geo)

#Save the crosswalks

saveRDS(
  ADM2_crosswalk,
  "D:/SNCC/IPV_Mapping_Output/ADM2_Crosswalk_Corrected.rds"
)

write.csv(
  st_drop_geometry(ADM2_crosswalk),
  "D:/SNCC/IPV_Mapping_Output/ADM2_Crosswalk_Corrected.csv",
  row.names = FALSE
)

options(na.print = "NA")

ADM2_District_Count <- ADM2_crosswalk %>%
  st_drop_geometry() %>%
  count(state_name_geo, sort = TRUE)

print(as.data.frame(ADM2_District_Count))

###############################################################################
# PREPARE IPV DISTRICT MATCHING DATA
###############################################################################

IPV_district <- district_ipv %>%
  mutate(
    state_match = normalize_name(state_name),
    district_match = normalize_name(district_name)
  ) %>%
  mutate(
    state_match = case_when(
      state_match == "nct of delhi" ~ "delhi",
      TRUE ~ state_match
    ),
    match_key = paste(
      state_match,
      district_match,
      sep = " | "
    )
  )

###############################################################################
# CREATE DISTRICT MATCHING NAMES FOR GEOBOUNDARIES
###############################################################################

ADM2_crosswalk <- ADM2_crosswalk %>%
  mutate(
    district_match = normalize_name(district_name_geo)
  )

# Prepare geographic matching keys
ADM2_crosswalk <- ADM2_crosswalk %>%
  mutate(
    match_key = paste(
      state_match,
      district_match,
      sep = " | "
    )
  )

###############################################################################
# APPLY PREVIOUSLY DOCUMENTED DISTRICT NAME CORRECTIONS
###############################################################################

ADM2_crosswalk <- ADM2_crosswalk %>%
  mutate(
    district_match = case_when(
      
      # Assam
      state_match == "assam" &
        district_match == "karbi anglong east" ~ "karbi anglong",
      
      state_match == "assam" &
        district_match == "karbi anglong west" ~ "west karbi anglong",
      
      state_match == "assam" &
        district_match == "south salmara mankachar" ~ "south salmara mancachar",
      
      # Andhra Pradesh
      state_match == "andhra pradesh" &
        district_match == "kadapa ysr" ~ "y s r",
      
      # Chhattisgarh
      state_match == "chhattisgarh" &
        district_match == "dakshin bastar dantewada" ~ "dantewada",
      
      state_match == "chhattisgarh" &
        district_match == "kondagaon" ~ "kodagaon",
      
      state_match == "chhattisgarh" &
        district_match == "gariaband" ~ "gariyaband",
      
      state_match == "chhattisgarh" &
        district_match == "bemetra" ~ "bemetara",
      
      # Gujarat
      state_match == "gujarat" &
        district_match == "batod" ~ "botad",
      
      # Madhya Pradesh
      state_match == "madhya pradesh" &
        district_match == "agar" ~ "agar malwa",
      
      # Meghalaya
      state_match == "meghalaya" &
        district_match == "east jaintia hills" ~ "east jantia hills",
      
      # Telangana
      state_match == "telangana" &
        district_match == "bhadradri" ~ "bhadradri kothagudem",
      
      state_match == "telangana" &
        district_match == "hydrabad" ~ "hyderabad",
      
      state_match == "telangana" &
        district_match == "jagtial" ~ "jagitial",
      
      state_match == "telangana" &
        district_match == "jangaon" ~ "jangoan",
      
      state_match == "telangana" &
        district_match == "jayashankar" ~ "jayashankar bhupalapally",
      
      state_match == "telangana" &
        district_match == "jogulamba" ~ "jogulamba gadwal",
      
      state_match == "telangana" &
        district_match == "komaram bheem" ~ "komaram bheem asifabad",
      
      state_match == "telangana" &
        district_match == "medchal" ~ "medchal malkajgiri",
      
      state_match == "telangana" &
        district_match == "rangareddy" ~ "ranga reddy",
      
      state_match == "telangana" &
        district_match == "warangal r" ~ "warangal rural",
      
      state_match == "telangana" &
        district_match == "warangal u" ~ "warangal urban",
      
      state_match == "telangana" &
        district_match == "yadadri bhongiri" ~ "yadadri bhuvanagiri",
      
      # Tripura
      state_match == "tripura" &
        district_match == "sipahijula" ~ "sepahijala",
      
      state_match == "tripura" &
        district_match == "unokoti" ~ "unakoti",
      
      # Uttar Pradesh
      state_match == "uttar pradesh" &
        district_match == "samli" ~ "shamli",
      
      # West Bengal
      state_match == "west bengal" &
        district_match == "barddhaman" ~ "purba barddhaman",
      
      TRUE ~ district_match
    ),
    
    match_key = paste(
      state_match,
      district_match,
      sep = " | "
    )
  )

###############################################################################
# DUPLICATE KEY AUDIT
###############################################################################

IPV_duplicate_keys <- IPV_district %>%
  count(match_key) %>%
  filter(n > 1)

GEO_duplicate_keys <- ADM2_crosswalk %>%
  st_drop_geometry() %>%
  count(match_key) %>%
  filter(n > 1)

cat("IPV duplicate keys:", nrow(IPV_duplicate_keys), "\n")

cat("Geographic duplicate keys:", nrow(GEO_duplicate_keys), "\n")

###############################################################################
# NATIONAL IPV–GEOBOUNDARIES MATCHING AUDIT
###############################################################################

# 1. Convert ADM2 crosswalk to a regular data frame
GEO_table <- ADM2_crosswalk %>%
  st_drop_geometry()

# 2. Exact matched IPV district records
IPV_matched <- IPV_district %>%
  semi_join(GEO_table, by = "match_key")

# 3. Unmatched IPV analytical districts
IPV_unmatched <- IPV_district %>%
  anti_join(GEO_table, by = "match_key")

# 4. Unmatched geographic polygons
GEO_unmatched <- GEO_table %>%
  anti_join(IPV_district, by = "match_key")

# 5. National matching summary
Matching_Summary <- data.frame(
  Indicator = c(
    "IPV district estimates",
    "ADM2 geographic polygons",
    "Matched IPV districts",
    "Unmatched IPV districts",
    "Unmatched geographic polygons",
    "Districts with duplicate IPV keys",
    "Districts with duplicate geographic keys"
  ),
  Count = c(
    nrow(IPV_district),
    nrow(GEO_table),
    nrow(IPV_matched),
    nrow(IPV_unmatched),
    nrow(GEO_unmatched),
    nrow(IPV_duplicate_keys),
    nrow(GEO_duplicate_keys)
  )
)

print(Matching_Summary)

# 6. Matching percentage
cat(
  "\nIPV district matching coverage:",
  round(100 * nrow(IPV_matched) / nrow(IPV_district), 2),
  "%\n"
)

# 7. Unmatched IPV districts by state
Unmatched_IPV_By_State <- IPV_unmatched %>%
  count(state_name, sort = TRUE)

# 8. Save all audit outputs
output_dir <- "D:/SNCC/IPV_Mapping_Output"

dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)

write.csv(
  Matching_Summary,
  file.path(output_dir, "IPV_National_Matching_Summary.csv"),
  row.names = FALSE
)

write.csv(
  IPV_unmatched,
  file.path(output_dir, "IPV_Unmatched_Districts.csv"),
  row.names = FALSE
)

write.csv(
  GEO_unmatched,
  file.path(output_dir, "IPV_Unmatched_Geographic_Polygons.csv"),
  row.names = FALSE
)

write.csv(
  Unmatched_IPV_By_State,
  file.path(output_dir, "IPV_Unmatched_By_State.csv"),
  row.names = FALSE
)

##Inspect

View(Matching_Summary)
View(IPV_unmatched)
View(GEO_unmatched)
View(Unmatched_IPV_By_State)

###############################################################################
# MANUAL ADMINISTRATIVE CORRECTION: YANAM
###############################################################################

ADM2_crosswalk <- ADM2_crosswalk %>%
  mutate(
    state_name_geo = if_else(
      normalize_name(district_name_geo) == "yanam",
      "Puducherry",
      state_name_geo
    ),
    state_iso_geo = if_else(
      normalize_name(district_name_geo) == "yanam",
      "IN-PY",
      state_iso_geo
    ),
    state_match = if_else(
      normalize_name(district_name_geo) == "yanam",
      "puducherry",
      state_match
    )
  )

# Rebuild the composite key
ADM2_crosswalk <- ADM2_crosswalk %>%
  mutate(
    match_key = paste(
      state_match,
      district_match,
      sep = " | "
    )
  )

# Verify Yanam
ADM2_crosswalk %>%
  st_drop_geometry() %>%
  filter(normalize_name(district_name_geo) == "yanam") %>%
  select(
    district_name_geo,
    state_name_geo,
    state_iso_geo,
    state_match,
    match_key
  )

###############################################################################
# REVISED NATIONAL MATCHING AUDIT
###############################################################################

GEO_table <- ADM2_crosswalk %>%
  st_drop_geometry()

IPV_matched <- IPV_district %>%
  semi_join(GEO_table, by = "match_key")

IPV_unmatched <- IPV_district %>%
  anti_join(GEO_table, by = "match_key")

GEO_unmatched <- GEO_table %>%
  anti_join(IPV_district, by = "match_key")

cat("IPV estimates:", nrow(IPV_district), "\n")
cat("Matched IPV districts:", nrow(IPV_matched), "\n")
cat("Unmatched IPV districts:", nrow(IPV_unmatched), "\n")
cat("Unmatched geographic polygons:", nrow(GEO_unmatched), "\n")

cat(
  "Matching coverage:",
  round(100 * nrow(IPV_matched) / nrow(IPV_district), 2),
  "%\n"
)

View(IPV_unmatched)
View(GEO_unmatched)

###############################################################################
# FINAL IPV–ADM2 MATCHING AUDIT
###############################################################################

GEO_table <- ADM2_crosswalk %>%
  st_drop_geometry()

IPV_matched <- IPV_district %>%
  semi_join(GEO_table, by = "match_key")

IPV_unmatched <- IPV_district %>%
  anti_join(GEO_table, by = "match_key")

GEO_unmatched <- GEO_table %>%
  anti_join(IPV_district, by = "match_key")

# Final summary
Final_Matching_Summary <- data.frame(
  Indicator = c(
    "IPV district estimates",
    "ADM2 geographic polygons",
    "Matched IPV districts",
    "Unmatched IPV districts",
    "Unmatched geographic polygons"
  ),
  Count = c(
    nrow(IPV_district),
    nrow(GEO_table),
    nrow(IPV_matched),
    nrow(IPV_unmatched),
    nrow(GEO_unmatched)
  )
)

View(Final_Matching_Summary)
View(IPV_unmatched)
View(GEO_unmatched)

# Save final audit
write.csv(
  Final_Matching_Summary,
  "D:/SNCC/IPV_Mapping_Output/Final_Matching_Summary.csv",
  row.names = FALSE
)

###############################################################################
# FINAL DISTRICT-LEVEL IPV SPATIAL DATASET
###############################################################################

# Join IPV estimates to geographic polygons
IPV_district_spatial <- ADM2_crosswalk %>%
  left_join(
    IPV_district %>%
      select(-state_match, -district_match),
    by = "match_key",
    suffix = c("_geo", "_ipv")
  )

# Validate the spatial dataset
cat("Total geographic polygons:",
    nrow(IPV_district_spatial), "\n")

cat("Polygons with IPV estimates:",
    sum(!is.na(IPV_district_spatial$ipv_prevalence)), "\n")

cat("Polygons without IPV estimates:",
    sum(is.na(IPV_district_spatial$ipv_prevalence)), "\n")

cat("Unique geographic features:",
    n_distinct(IPV_district_spatial$shapeID), "\n")

# Inspect unmatched polygon names
IPV_district_spatial %>%
  filter(is.na(ipv_prevalence)) %>%
  st_drop_geometry() %>%
  select(district_name_geo, state_name_geo)

###############################################################################
# STATE-LEVEL IPV SPATIAL DATASET
###############################################################################

IPV_state <- state_ipv %>%
  mutate(
    state_match = normalize_name(state_name)
  ) %>%
  mutate(
    state_match = if_else(
      state_match == "nct of delhi",
      "delhi",
      state_match
    )
  )

ADM1_state <- india_adm1 %>%
  mutate(
    state_match = normalize_name(shapeName)
  ) %>%
  left_join(
    IPV_state %>%
      select(-state_name),
    by = "state_match"
  )

cat("ADM1 geographic features:", nrow(ADM1_state), "\n")

cat("States with IPV estimates:",
    sum(!is.na(ADM1_state$ipv_prevalence)), "\n")

cat("States without IPV estimates:",
    sum(is.na(ADM1_state$ipv_prevalence)), "\n")

###############################################################################
# SAVE FINAL SPATIAL DATASETS
###############################################################################

output_dir <- "D:/SNCC/IPV_Mapping_Output"

saveRDS(
  IPV_district_spatial,
  file.path(output_dir, "IPV_District_Spatial.rds")
)

saveRDS(
  ADM1_state,
  file.path(output_dir, "IPV_State_Spatial.rds")
)



###############################################################################
# DISTRICT-LEVEL IPV MAP
###############################################################################

p_district <- ggplot(IPV_district_spatial) +
  geom_sf(
    aes(fill = ipv_prevalence),
    colour = "white",
    linewidth = 0.08
  ) +
  scale_fill_viridis_c(
    name = "IPV prevalence (%)",
    limits = c(0, 100),
    na.value = "grey90"
  ) +
  labs(
    title = "District-Level Prevalence of Intimate Partner Violence",
    subtitle = "India, NFHS-5 (2019–21); survey-weighted estimates",
    caption = "Grey areas indicate districts without matched estimates."
  ) +
  theme_void() +
  theme(
    plot.title = element_text(face = "bold", size = 14),
    plot.subtitle = element_text(size = 10),
    legend.position = "right"
  )

ggsave(
  file.path(output_dir, "IPV_District_Prevalence_Map.png"),
  p_district,
  width = 11,
  height = 11,
  dpi = 300
)

print(p_district)

###############################################################################
# STATE-LEVEL IPV MAP
###############################################################################

p_state <- ggplot(ADM1_state) +
  geom_sf(
    aes(fill = ipv_prevalence),
    colour = "white",
    linewidth = 0.25
  ) +
  scale_fill_viridis_c(
    name = "IPV prevalence (%)",
    limits = c(0, 100),
    na.value = "grey90"
  ) +
  labs(
    title = "State-Level Prevalence of Intimate Partner Violence",
    subtitle = "India, NFHS-5 (2019–21); survey-weighted estimates"
  ) +
  theme_void() +
  theme(
    plot.title = element_text(face = "bold", size = 14),
    plot.subtitle = element_text(size = 10),
    legend.position = "right"
  )

ggsave(
  file.path(output_dir, "IPV_State_Prevalence_Map.png"),
  p_state,
  width = 10,
  height = 10,
  dpi = 300
)

print(p_state)


###############################################################################
# AUDIT: ISLAND IPV ESTIMATES
###############################################################################

# District-level island estimates
Island_District_IPV <- IPV_district_spatial %>%
  st_drop_geometry() %>%
  filter(
    state_match %in% c(
      "andaman and nicobar islands",
      "lakshadweep"
    )
  ) %>%
  select(
    state_name_geo,
    district_name_geo,
    ipv_prevalence,
    se,
    ci_l,
    ci_u
  )

View(Island_District_IPV)

# State-level island estimates
Island_State_IPV <- ADM1_state %>%
  st_drop_geometry() %>%
  filter(
    state_match %in% c(
      "andaman and nicobar islands",
      "lakshadweep"
    )
  ) %>%
  select(
    shapeName,
    ipv_prevalence,
    se,
    ci_l,
    ci_u
  )

View(Island_State_IPV)

if (!requireNamespace("patchwork", quietly = TRUE)) {
  install.packages("patchwork")
}

library(patchwork)

###############################################################################
# PUBLICATION-QUALITY DISTRICT IPV MAP WITH ISLAND INSETS
###############################################################################

# Common colour scale
ipv_palette <- scale_fill_viridis_c(
  option = "magma",
  direction = 1,
  limits = c(0, 100),
  breaks = seq(0, 100, 25),
  name = "IPV prevalence (%)",
  na.value = "grey85"
)

# Common map theme
map_theme <- theme_void() +
  theme(
    plot.title = element_text(
      face = "bold",
      size = 14
    ),
    plot.subtitle = element_text(size = 10),
    legend.title = element_text(size = 10),
    legend.text = element_text(size = 9),
    legend.position = "right",
    plot.caption = element_text(size = 8)
  )

# Main India map
p_district_main <- ggplot(IPV_district_spatial) +
  geom_sf(
    aes(fill = ipv_prevalence),
    colour = "white",
    linewidth = 0.07
  ) +
  ipv_palette +
  coord_sf(
    xlim = c(67, 98),
    ylim = c(5, 38),
    expand = FALSE
  ) +
  labs(
    title = "District-level IPV prevalence in India",
    subtitle = "NFHS-5 (2019–21), survey-weighted estimates"
  ) +
  map_theme

# Lakshadweep inset
p_lakshadweep <- ggplot(
  IPV_district_spatial %>%
    filter(state_match == "lakshadweep")
) +
  geom_sf(
    aes(fill = ipv_prevalence),
    colour = "white",
    linewidth = 0.3
  ) +
  ipv_palette +
  coord_sf(
    xlim = c(71, 74),
    ylim = c(8, 13),
    expand = FALSE
  ) +
  labs(title = "Lakshadweep") +
  theme_void() +
  theme(
    plot.title = element_text(face = "bold", size = 10),
    legend.position = "none"
  )

# Andaman & Nicobar inset
p_andaman <- ggplot(
  IPV_district_spatial %>%
    filter(state_match == "andaman and nicobar islands")
) +
  geom_sf(
    aes(fill = ipv_prevalence),
    colour = "white",
    linewidth = 0.3
  ) +
  ipv_palette +
  coord_sf(
    xlim = c(91, 94),
    ylim = c(6, 14),
    expand = FALSE
  ) +
  labs(title = "Andaman & Nicobar Islands") +
  theme_void() +
  theme(
    plot.title = element_text(face = "bold", size = 10),
    legend.position = "none"
  )

# Combine main map and island insets
p_district_final <- (
  p_district_main |
    (p_lakshadweep / p_andaman)
) +
  plot_layout(
    widths = c(3.5, 1.3),
    guides = "collect"
  ) +
  plot_annotation(
    caption = paste(
      "Source: NFHS-5 (2019–21).",
      "Grey polygons indicate unavailable matched estimates.",
      "Island regions are magnified in separate insets."
    )
  ) &
  theme(legend.position = "right")

# Display
print(p_district_final)

# Save high-resolution output
ggsave(
  file.path(output_dir, "IPV_District_Map_With_Island_Insets.png"),
  p_district_final,
  width = 13,
  height = 10,
  dpi = 600,
  bg = "white"
)

ggsave(
  file.path(output_dir, "IPV_District_Map_With_Island_Insets.pdf"),
  p_district_final,
  width = 13,
  height = 10,
  bg = "white"
)


###############################################################################
# STATE-LEVEL IPV MAP WITH ISLAND INSETS
###############################################################################

p_state_main <- ggplot(ADM1_state) +
  geom_sf(
    aes(fill = ipv_prevalence),
    colour = "white",
    linewidth = 0.25
  ) +
  ipv_palette +
  coord_sf(
    xlim = c(67, 98),
    ylim = c(5, 38),
    expand = FALSE
  ) +
  labs(
    title = "State-level IPV prevalence in India",
    subtitle = "NFHS-5 (2019–21), survey-weighted estimates"
  ) +
  map_theme

p_state_lak <- ggplot(
  ADM1_state %>%
    filter(state_match == "lakshadweep")
) +
  geom_sf(aes(fill = ipv_prevalence)) +
  ipv_palette +
  coord_sf(
    xlim = c(71, 74),
    ylim = c(8, 13),
    expand = FALSE
  ) +
  labs(title = "Lakshadweep") +
  theme_void() +
  theme(
    plot.title = element_text(face = "bold", size = 10),
    legend.position = "none"
  )

p_state_andaman <- ggplot(
  ADM1_state %>%
    filter(state_match == "andaman and nicobar islands")
) +
  geom_sf(aes(fill = ipv_prevalence)) +
  ipv_palette +
  coord_sf(
    xlim = c(91, 94),
    ylim = c(6, 14),
    expand = FALSE
  ) +
  labs(title = "Andaman & Nicobar Islands") +
  theme_void() +
  theme(
    plot.title = element_text(face = "bold", size = 10),
    legend.position = "none"
  )

p_state_final <- (
  p_state_main |
    (p_state_lak / p_state_andaman)
) +
  plot_layout(
    widths = c(3.5, 1.3),
    guides = "collect"
  ) &
  theme(legend.position = "right")

print(p_state_final)

ggsave(
  file.path(output_dir, "IPV_State_Map_With_Island_Insets.png"),
  p_state_final,
  width = 13,
  height = 10,
  dpi = 600,
  bg = "white"
)

ggsave(
  file.path(output_dir, "IPV_State_Map_With_Island_Insets.pdf"),
  p_state_final,
  width = 13,
  height = 10,
  bg = "white"
)
