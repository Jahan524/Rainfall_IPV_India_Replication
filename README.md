# Rainfall_IPV_India_Replication
Replication code for "Rainfall Variation and Intimate Partner Violence in India: Stress and Backlash Mechanisms" (RSOS-260304)
# Rainfall Variation and IPV in India: Replication Repository

This repository contains the statistical code (Stata/Python) required to replicate the findings of the study: **"Rainfall Variation and Intimate Partner Violence in India: Stress and Backlash Mechanisms."**

## 📊 Study Overview
This research investigates the intersection of climate shocks (rainfall variation) and social vulnerability (IPV) in India using Generalized Structural Equation Modeling (GSEM).

## 📁 Repository Contents
- `/scripts`: Contains `.do` files for data cleaning, variable construction, and GSEM/GLMM analysis.
- `/docs`: Detailed description of variables used from NFHS-5 and CRU TS4.07.

## 🔓 Data Access
As per the terms of the data providers, raw datasets are not hosted in this repository. Researchers can access them via:
1. **NFHS-5 (2019-21):** [The DHS Program](https://dhsprogram.com/data/available-datasets.cfm) (Registration required).
2. **Rainfall Data (CRU TS4.07):**[https://crudata.uea.ac.uk/cru/data/hrg/] or [https://geo.aiddata.org/query/#!/status/629e24d1809e383f4a3c3722] (Public access).

## 🚀 Usage
1. Download the raw data from the links above.
2. Run `01_cleaning.do` to merge GPS cluster coordinates with rainfall grids.
3. Run `02_analysis.do` to generate the path coefficients and models presented in the manuscript.

## ⚖️ License
This code is licensed under the MIT License.
