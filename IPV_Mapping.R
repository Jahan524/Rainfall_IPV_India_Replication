# ============================================================
# STEP 1: PROJECT SETUP AND DATA IMPORT
# NFHS-5 IPV analysis
# ============================================================

# 1. Set project directory
project_dir <- "D:/SNCC"

setwd(project_dir)

# 2. Create output folders if they do not already exist
folders <- c(
  "Script",
  "Output",
  "Output/Tables",
  "Output/Figures",
  "Output/Data",
  "Output/Logs"
)

for (folder in folders) {
  dir.create(folder, recursive = TRUE, showWarnings = FALSE)
}

# 3. Install required packages only if missing
required_packages <- c(
  "haven",
  "dplyr",
  "tidyr",
  "ggplot2",
  "labelled",
  "janitor"
)

missing_packages <- required_packages[
  !required_packages %in% installed.packages()[, "Package"]
]

if (length(missing_packages) > 0) {
  install.packages(missing_packages)
}

# 4. Load packages
library(haven)
library(dplyr)
library(tidyr)
library(ggplot2)
library(labelled)
library(janitor)

# 5. Define source file
data_file <- "D:/SNCC/NFHS5_IPV_Study.dta"

# 6. Confirm file exists
if (!file.exists(data_file)) {
  stop("The .dta file was not found. Please check the file path.")
}

# 7. Import Stata dataset
ipv <- read_dta(data_file)

# 8. Basic dataset audit
cat("Number of observations:", nrow(ipv), "\n")
cat("Number of variables:", ncol(ipv), "\n")

# 9. Inspect structure
glimpse(ipv)

# 10. Inspect variable names
names(ipv)

# 11. Inspect first few rows
head(ipv)

# 12. Check duplicate respondent IDs
ipv %>%
  summarise(
    total_rows = n(),
    unique_ids = n_distinct(v001, v002, v003),
    duplicate_id_rows = total_rows - unique_ids
  )

# ============================================================
# STEP 2A: IPV OUTCOME VALIDATION
# ============================================================

# Main IPV outcome frequencies
table(ipv$dv_aprtnr_phy_sex_emot_any_12m, useNA = "always")

# Alternative composite outcome frequencies
table(ipv$dv_prtnr_phy_sex_emot_any_12m, useNA = "always")

# Individual IPV indicators
ipv_indicators <- c(
  "dv_prtnr_phy_12m",
  "dv_aprtnr_phy_12m",
  "dv_prtnr_sex_12m",
  "dv_prtnr_emot_12m",
  "dv_aprtnr_emot_12m",
  "dv_abusedhus_phy_12m"
)

# Frequencies for each indicator
for (v in ipv_indicators) {
  cat("\n------------------------------\n")
  cat("Variable:", v, "\n")
  print(table(ipv[[v]], useNA = "always"))
}

# ============================================================
# STEP 2B: COMPARE COMPOSITE IPV OUTCOMES
# ============================================================

# Cross-tabulation
with(
  ipv,
  table(
    dv_aprtnr_phy_sex_emot_any_12m,
    dv_prtnr_phy_sex_emot_any_12m,
    useNA = "always"
  )
)

# Agreement among respondents with both outcomes observed
outcome_comparison <- ipv %>%
  filter(
    !is.na(dv_aprtnr_phy_sex_emot_any_12m),
    !is.na(dv_prtnr_phy_sex_emot_any_12m)
  ) %>%
  summarise(
    n_compared = n(),
    n_agree = sum(
      dv_aprtnr_phy_sex_emot_any_12m ==
        dv_prtnr_phy_sex_emot_any_12m
    ),
    n_disagree = sum(
      dv_aprtnr_phy_sex_emot_any_12m !=
        dv_prtnr_phy_sex_emot_any_12m
    ),
    agreement_percent = 100 * mean(
      dv_aprtnr_phy_sex_emot_any_12m ==
        dv_prtnr_phy_sex_emot_any_12m
    )
  )

outcome_comparison

# ============================================================
# STEP 2C: MISSINGNESS AUDIT
# ============================================================

audit_vars <- c(
  "dv_aprtnr_phy_sex_emot_any_12m",
  "dv_prtnr_phy_sex_emot_any_12m",
  "decision_autonomy",
  "reject_dv",
  "education_media",
  "worked_past_year",
  "mobility_autonomy",
  "economic_assets",
  "financial_autonomy"
)

missingness_audit <- ipv %>%
  summarise(
    across(
      all_of(audit_vars),
      list(
        missing_n = ~ sum(is.na(.)),
        missing_pct = ~ mean(is.na(.)) * 100
      )
    )
  ) %>%
  pivot_longer(
    cols = everything(),
    names_to = "variable_statistic",
    values_to = "value"
  )

missingness_audit

# ============================================================
# STEP 3A: DESCRIPTIVE PROFILE
# ============================================================

library(dplyr)
library(tidyr)
library(purrr)

# Variables for the initial descriptive profile
desc_vars <- c(
  "dv_aprtnr_phy_sex_emot_any_12m",
  "age_group",
  "residence",
  "education",
  "wealth",
  "religion_group",
  "caste_group",
  "union_duration",
  "living_children_group",
  "prtnr_alcohol",
  "prtnr_education",
  "prtnr_occupation",
  "decision_autonomy",
  "reject_dv",
  "education_media",
  "worked_past_year",
  "mobility_autonomy",
  "economic_assets",
  "financial_autonomy"
)

# Check that all requested variables exist
missing_vars <- setdiff(desc_vars, names(ipv))

if (length(missing_vars) > 0) {
  stop(
    "These variables are missing from the dataset: ",
    paste(missing_vars, collapse = ", ")
  )
}

# Produce a frequency table for each variable
descriptive_table <- map_dfr(
  desc_vars,
  function(var_name) {
    
    x <- ipv[[var_name]]
    
    tibble(
      variable = var_name,
      category = as.character(x)
    ) %>%
      count(category, name = "n") %>%
      mutate(
        percent = 100 * n / sum(n),
        variable = var_name
      ) %>%
      select(variable, category, n, percent)
  }
)

descriptive_table

# ============================================================
# STEP 3B: SURVEY WEIGHT AND DESIGN AUDIT
# ============================================================

# Check weight distribution
summary(ipv$dwt)

# Check missing or non-positive weights
ipv %>%
  summarise(
    n_total = n(),
    n_missing_dwt = sum(is.na(dwt)),
    n_zero_dwt = sum(dwt == 0, na.rm = TRUE),
    n_negative_dwt = sum(dwt < 0, na.rm = TRUE),
    min_dwt = min(dwt, na.rm = TRUE),
    max_dwt = max(dwt, na.rm = TRUE)
  )

# Check PSU and strata counts
ipv %>%
  summarise(
    n_psu = n_distinct(v021),
    n_strata = n_distinct(v022),
    n_missing_psu = sum(is.na(v021)),
    n_missing_strata = sum(is.na(v022))
  )

# Inspect the weight alongside the standard NFHS weight
summary(ipv$v005)
summary(ipv$dwt)

# ============================================================
# STEP 4A: SURVEY DESIGN STRUCTURE CHECK
# ============================================================

library(dplyr)

# Check whether each PSU belongs to one stratum
psu_strata_check <- ipv %>%
  distinct(v022, v021) %>%
  count(v021, name = "n_strata_per_psu") %>%
  filter(n_strata_per_psu > 1)

psu_strata_check

# Number of PSUs in each stratum
strata_psu_counts <- ipv %>%
  distinct(v022, v021) %>%
  count(v022, name = "n_psu") %>%
  arrange(n_psu)

summary(strata_psu_counts$n_psu)

# Check whether the domestic violence weight is normalized
ipv %>%
  summarise(
    sum_dwt = sum(dwt, na.rm = TRUE),
    mean_dwt = mean(dwt, na.rm = TRUE),
    n = n()
  )

# ============================================================
# STEP 4B: SURVEY-WEIGHTED IPV PREVALENCE
# ============================================================

if (!requireNamespace("survey", quietly = TRUE)) {
  install.packages("survey")
}

library(survey)

# Handle strata containing only one PSU
options(survey.lonely.psu = "adjust")

# Create survey design
ipv_design <- svydesign(
  ids = ~v021,
  strata = ~v022,
  weights = ~dwt,
  data = ipv,
  nest = TRUE
)

# Restrict to respondents with a non-missing IPV outcome
ipv_design_main <- subset(
  ipv_design,
  !is.na(dv_aprtnr_phy_sex_emot_any_12m)
)

# Estimate weighted IPV prevalence
ipv_prevalence <- svymean(
  ~dv_aprtnr_phy_sex_emot_any_12m,
  design = ipv_design_main,
  na.rm = TRUE
)

# Display estimate and 95% confidence interval
ipv_prevalence
confint(ipv_prevalence)

#Create percentage table

prevalence_result <- data.frame(
  estimate = coef(ipv_prevalence),
  standard_error = SE(ipv_prevalence),
  conf_low = confint(ipv_prevalence)[, 1],
  conf_high = confint(ipv_prevalence)[, 2]
) %>%
  mutate(
    prevalence_percent = estimate * 100,
    conf_low_percent = conf_low * 100,
    conf_high_percent = conf_high * 100
  )

prevalence_result

# ============================================================
# STEP 4C: Compare weighted and unweighted estimates
# ============================================================

# Unweighted prevalence among non-missing outcome observations
unweighted_prevalence <- ipv %>%
  filter(!is.na(dv_aprtnr_phy_sex_emot_any_12m)) %>%
  summarise(
    n_valid = n(),
    n_ipv = sum(dv_aprtnr_phy_sex_emot_any_12m == 1),
    prevalence_percent =
      mean(dv_aprtnr_phy_sex_emot_any_12m) * 100
  )

# Weighted prevalence from the survey design
weighted_prevalence <- data.frame(
  n_valid = nrow(ipv_design_main$variables),
  prevalence_percent = as.numeric(coef(ipv_prevalence)) * 100,
  ci_lower = as.numeric(confint(ipv_prevalence)[1]) * 100,
  ci_upper = as.numeric(confint(ipv_prevalence)[2]) * 100
)

unweighted_prevalence
weighted_prevalence

##Let's inspect all variables

# List all variables in the dataset
names(ipv)

# Create a complete variable inventory
variable_inventory <- data.frame(
  variable = names(ipv),
  
  class = vapply(
    ipv,
    function(x) as.character(class(x)[1]),
    character(1)
  ),
  
  label = vapply(
    ipv,
    function(x) {
      lbl <- attr(x, "label")
      
      if (is.null(lbl) || length(lbl) == 0) {
        return(NA_character_)
      }
      
      as.character(lbl[1])
    },
    character(1)
  ),
  
  stringsAsFactors = FALSE
)

# View the full inventory
View(variable_inventory)

# Print all 83 rows
print(variable_inventory, row.names = FALSE)

# Export the inventory
write.csv(
  variable_inventory,
  "Output/Variable_Inventory.csv",
  row.names = FALSE
)

# ============================================================
# STEP 5A: Calculate state-wise and district-wise IPV prevalence
# ============================================================

# 1. Prepare the analysis dataset
library(dplyr)
library(survey)
library(haven)

# Use the selected IPV outcome and geographic identifiers
ipv_mapdata <- ipv %>%
  mutate(
    state_name = as.character(as_factor(state)),
    district_name = as.character(as_factor(district)),
    ipv_outcome = as.numeric(dv_aprtnr_phy_sex_emot_any_12m)
  ) %>%
  filter(
    !is.na(ipv_outcome),
    !is.na(dwt),
    dwt > 0,
    !is.na(state_name),
    !is.na(district_name)
  )

# Check sample size and geographic coverage
nrow(ipv_mapdata)

n_distinct(ipv_mapdata$state_name)
n_distinct(ipv_mapdata$district_name)

# Check outcome coding
table(ipv_mapdata$ipv_outcome, useNA = "ifany")

##2. Create the survey design

options(survey.lonely.psu = "adjust")

ipv_map_design <- svydesign(
  ids = ~v021,
  strata = ~v022,
  weights = ~dwt,
  data = ipv_mapdata,
  nest = TRUE
)

##3. Estimate state-wise IPV prevalence
state_ipv <- svyby(
  ~ipv_outcome,
  ~state_name,
  design = ipv_map_design,
  FUN = svymean,
  vartype = c("se", "ci"),
  na.rm = TRUE,
  keep.names = FALSE
)

# Convert prevalence and confidence intervals to percentages
state_ipv <- state_ipv %>%
  mutate(
    ipv_prevalence = ipv_outcome * 100,
    se_percent = se * 100,
    ci_lower_percent = ci_l * 100,
    ci_upper_percent = ci_u * 100
  )

# View state-wise results
state_ipv

##4. Estimate district-wise IPV prevalence

district_ipv <- svyby(
  ~ipv_outcome,
  ~state_name + district_name,
  design = ipv_map_design,
  FUN = svymean,
  vartype = c("se", "ci"),
  na.rm = TRUE,
  keep.names = FALSE
)

# Convert estimates to percentages
district_ipv <- district_ipv %>%
  mutate(
    ipv_prevalence = ipv_outcome * 100,
    se_percent = se * 100,
    ci_lower_percent = ci_l * 100,
    ci_upper_percent = ci_u * 100
  )

# View district-wise results
district_ipv

##5. Check the highest and lowest prevalence estimates
# 10 states with highest IPV prevalence
state_ipv %>%
  arrange(desc(ipv_prevalence)) %>%
  select(
    state_name,
    ipv_prevalence,
    ci_lower_percent,
    ci_upper_percent
  ) %>%
  head(10)

# 10 districts with highest IPV prevalence
district_ipv %>%
  arrange(desc(ipv_prevalence)) %>%
  select(
    state_name,
    district_name,
    ipv_prevalence,
    ci_lower_percent,
    ci_upper_percent
  ) %>%
  head(10)

# ============================================================
# STEP 5B: Load the administrative boundary shapefiles
# ============================================================

##1. Find the shapefiles
# Search for shapefiles in your existing project folders
list.files(
  "D:/Climate",
  pattern = "\\.shp$",
  recursive = TRUE,
  full.names = TRUE,
  ignore.case = TRUE
)

##2. Load the state and district boundaries
library(sf)
library(dplyr)
library(stringr)
library(ggplot2)

# State-level boundaries
india_adm1 <- st_read(
  "D:/Climate/Shapefile/geoBoundaries-IND-ADM1.shp"
)

# District-level boundaries
india_adm2 <- st_read(
  "D:/Climate/Shapefile/geoBoundaries-IND-ADM2.shp"
)

##3. Inspect the boundary attributes
# State boundaries
names(india_adm1)
nrow(india_adm1)
head(st_drop_geometry(india_adm1))

# District boundaries
names(india_adm2)
nrow(india_adm2)
head(st_drop_geometry(india_adm2))

# Coordinate reference systems
st_crs(india_adm1)
st_crs(india_adm2)

