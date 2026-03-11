********************************************************************************
* FILE 1: DATA CLEANING & VARIABLE GENERATION
* Purpose: Prepare NFHS-5 variables and merge with environmental data
********************************************************************************
use "C:\Users\jahan\AppData\Local\Temp\abc7aa50-7540-4438-867e-668f88b5508d_IAIR7EDT(Women).zip.IAIR7EDT(Women).zip\IAIR7EFL.DTA" 
set maxvar 30000
use "C:\Users\jahan\AppData\Local\Temp\abc7aa50-7540-4438-867e-668f88b5508d_IAIR7EDT(Women).zip.IAIR7EDT(Women).zip\IAIR7EFL.DTA" 
save "C:\Users\jahan\OneDrive\Desktop\RV_IPV.dta"

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
* Partner's Occupation (Formal/Informal sector)
rename v... partneroccup
gen informal=.
replace informal=1 if partneroccup==6 | partneroccup==7| partneroccup==9
replace informal=0 if informal==.
label var informal "Husband's occupation (formal/informal)"

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

* WOMEN EMPOWERMENT INDEX CONSTRUCTION

(A) Decision-making Autonomy

gen dm_health = inlist(v743a, 1, 2)
gen dm_purchases = inlist(v743b, 1, 2)
gen dm_visits = inlist(v743d, 1, 2)

(B) Attitude Toward Domestic Violence (Does NOT justify)

gen no_violence1 = v744a == 0
gen no_violence2 = v744b == 0
gen no_violence3 = v744c == 0
gen no_violence4 = v744d == 0
gen no_violence5 = v744e == 0

(C) Education & Media Access

gen educated = v106 >= 2   // Secondary or higher
gen reads_news = v157 >= 1
gen watches_tv = v158 >= 1
gen listens_radio = v159 >= 1

(D) Employment & Income Control

gen working = v731 == 1
gen earnings_control = inlist(v739, 1, 2)  // respondent or joint

(E) Mobility (No need for permission)

gen move_health = v467d == 0
gen move_market = v467e == 0
gen move_family = v467b == 0
gen mobility_total = move_health + move_market + move_family
gen mobility_3places = mobility_total == 3

(F) Economic Empowerment

gen bank_account = v170 == 1
gen own_mobile = v169a == 1
gen owns_house = inlist(v745a, 1, 2)
gen owns_land = inlist(v745b, 1, 2)
gen control_cash = inlist(v739, 1, 2)   // already covered, but can rename if preferred

# Check Missing Values (Optional)

misstable summarize dm_health dm_purchases dm_visits ///
    no_violence1-no_violence5 ///
    educated reads_news watches_tv listens_radio ///
    working earnings_control ///
    move_health move_market move_family mobility_3places ///
    bank_account own_mobile owns_house owns_land control_cash
	
# Standardize Variables

foreach var in dm_health dm_purchases dm_visits ///
    no_violence1 no_violence2 no_violence3 no_violence4 no_violence5 ///
    educated reads_news watches_tv listens_radio ///
    working earnings_control ///
    move_health move_market move_family mobility_3places ///
    bank_account own_mobile owns_house owns_land control_cash
 {
    egen z_`var' = std(`var')
}

# pca of standardized variables

pca z_dm_health z_dm_purchases z_dm_visits ///
    z_no_violence1 z_no_violence2 z_no_violence3 z_no_violence4 z_no_violence5 ///
    z_educated z_reads_news z_watches_tv z_listens_radio ///
    z_working earnings_control ///
    z_move_health z_move_market z_move_family z_mobility_3places ///
    z_bank_account z_own_mobile z_owns_house z_owns_land z_control_cash

screeplot

# Predict and Normalize the Index

predict wei_pca1  // First principal component
label variable wei_pca1 "Women Empowerment Index (PCA Comp1)"

egen wei_min = min(wei_pca1)
egen wei_max = max(wei_pca1)

gen wei_index = (wei_pca1 - wei_min)/(wei_max - wei_min)


** RAINFALL ANOMALY CALCULATION

* Rainfall Variation
* Standardized Rainfall Variation
* Precipitation Zone

** MERGING DATASETS (NFHS 5 & CRUTS 4.5)
** KEEP THE VARIABLES
** CLEANSE THE MISSING VALUES








