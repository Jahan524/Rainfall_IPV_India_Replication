********************************************************************************
* FILE 1: DATA CLEANING & VARIABLE GENERATION
* Purpose: Prepare NFHS-5 variables and merge with environmental data
********************************************************************************
* limiting to women age 15-49
drop if v012<15 | v012>49

cap gen dwt = d005/1000000

** 1. GENERATE IPV INDICATORS (Past 12 Months) 
* Physical Violence
		gen physicviolence = 0 if v044==1 & v502>0
		replace physicviolence = 1 if (physicviolence==1 | d130a==1)
		label val physicviolence yesno
		label var physicviolence "Experienced physical violence in past 12 mos. by any partner"
		
* Sexual Violence
		gen sexviolence = 0 if v044==1 & v502>0
		replace sexviolence = 1 if (sexviolence==1 | d130b==1)
		label val sexviolence yesno
		label var sexviolence "Experienced sexual violence in past 12 mos. by any partner"

* Emotional Violence
		gen emoviolence = 0 if v044==1 & v502>0
		replace emoviolence = 1 if (emoviolence==1 | d130c==1)
		label val emoviolence yesno
		label var emoviolence "Experienced emotional violence in past 12 mos. by any partner"
		
* Any Kind of Violence
		gen anyviolence = 0 if v044==1 & v502>0
		replace anyviolence = 1 if (dv_aprtnr_phy_12m==1 | dv_aprtnr_sex_12m==1 | dv_aprtnr_emot_12m==1)
		label val anyviolence yesno
		label var anyviolence "Experienced physical OR sexual OR emotional violence in past 12 mos. by any partner"

** 2. SOCIOECONOMIC COVARIATES 
* Demographic variables
		
* Duration of Marriage
	recode v512 (0/1= 1 "<2") (2/4=2 "2-4") (5/9=3 "5-9") (10/50=4 "10+"), gen(maryears)
	label var maryears "Years since first cohabitation"
	
* Age Groups
	gen age = v013
	replace age = 4 if v013==5
	replace age = 5 if (v013==6 | v013==7)
	label define age 1 "15-19" 2 "20-24" 3 "25-29" 4 "30-39" 5 "40-49"
	label values age age
	label var age "age groups"
	
* Religion
	gen religion=.
	replace religion=1 if v130==1
	replace religion=2 if v130==2
	replace religion=3 if v130==3
	replace religion=4 if v130>3
	label define religion 1 "hindu" 2"muslim" 3"christian" 4"others"
	label val religion religion
	label var religion religion
		
* Caste
	gen caste=.
	replace caste=1 if s116==1
	replace caste=2 if s116==2
	replace caste=3 if s116==3
	replace caste=4 if s116==4
	replace caste=4 if s116==8
	label define caste 1"schedule caste" 2"schedule tribe" 3"obc" 4"others"
	label val caste caste
	label var caste "belong to a SC,ST,OBC"
	
* Living Children
	egen children = cut(v218), at(0,1,3,5,98)
	label define children 0 "0" 1 "1-2" 3 "3-4" 5 "5+" 98 "DK/missing"
	label values children children 
	label var children "living children"
	
* Employment Status  
	gen wemploy = 0
	replace wemploy = 1 if (v741==1 | v741==2 | v741==3) //earns cash or non-cash income
	replace wemploy = 9 if (v741==9)
	label define wemploy 0 "not employed" 1 "employed" 9 "missing type of earnings"
	label values wemploy wemploy
	label var wemploy "Employment status either cash or non-cash"
	
* Husband's Alcohol Consumption
	gen drinkalcohl = d113
	replace drinkalcohl = 0 if d114==0 | d114==1
	replace drinkalcohl = 1 d114==2| d114==3 
	label define drinkalcohl 0 "Not drunk" 1 "drunk"
	label val drinkalcohl drinkalcohl
	label var drinkalcohl "husband's drinking habits"
		
		
* Education
* Partner's Education
* Occupation (Formal/Informal sector)
* Financial Inclusion (Bank Account)
* Wealth Status
* Year of Interview
* Month of Interview
* District

//Rename for convenience

rename v190 wealth
rename v106 education
rename v024 state
rename v025 residence

** RAINFALL ANOMALY CALCULATION
* Rainfall Variation
* Standardized Rainfall Variation
* Precipitation Zone

** MERGING DATASETS (NFHS 5 & CRUTS 4.5)
** KEEP THE VARIABLES
** CLEANSE THE MISSING VALUES






