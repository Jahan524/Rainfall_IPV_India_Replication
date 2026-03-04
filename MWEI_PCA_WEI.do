use "C:\Users\jahan\AppData\Local\Temp\abc7aa50-7540-4438-867e-668f88b5508d_IAIR7EDT(Women).zip.IAIR7EDT(Women).zip\IAIR7EFL.DTA" 
set maxvar 30000
use "C:\Users\jahan\AppData\Local\Temp\abc7aa50-7540-4438-867e-668f88b5508d_IAIR7EDT(Women).zip.IAIR7EDT(Women).zip\IAIR7EFL.DTA" 
save "C:\Users\jahan\OneDrive\Desktop\RM\MWEI\MWEI_PCA.dta"

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
	



# PCA on All Indicators

pca dm_health dm_purchases dm_visits ///
    no_violence1 no_violence2 no_violence3 no_violence4 no_violence5 ///
    educated reads_news watches_tv listens_radio ///
    working earnings_control ///
    move_health move_market move_family mobility_3places ///
    bank_account own_mobile owns_house owns_land control_cash

screeplot

# Predict and Standardize the WEI

predict wei_pca1  // First principal component
egen wei_std = std(wei_pca1)
label variable wei_std "Standardized Women Empowerment Index (PCA Comp1)"


#Calculate and Rank State-wise WEI
preserve
collapse (mean) wei_std, by(v024)   // calculate average WEI per state
gen rank = -wei_std                 // for descending order
gsort rank                          // sort in descending order of empowerment
drop rank
gen state_rank = _n                // assign rank
restore


# Present Table in Paper

list v024 wei_std state_rank, sepby(v024)

# Categorize States into Empowerment Levels

xtile wei_quintile = wei_std, nq(5)
label define wei_lbl 1 "Very Low" 2 "Low" 3 "Medium" 4 "High" 5 "Very High"
label values wei_quintile wei_lbl

graph bar wei_std, over(wei_quintile, label(angle(45))) blabel(bar)

# For District-wise Rankings
preserve
collapse (mean) wei_std, by(sdist)   // sdist = district ID
gsort -wei_std
gen dist_rank = _n
export excel using "districtwise_wei.xlsx", firstrow(variables) replace
restore

# categorize based on empowerment level

xtile wei_quintile = wei_std, nq(5)
label define wei_lbl 1 "Very Low" 2 "Low" 3 "Medium" 4 "High" 5 "Very High"
label values wei_quintile wei_lbl
graph bar wei_std, over(wei_quintile, label(angle(45))) blabel(bar)
list v024 wei_std wei_quintile , sepby( wei_quintile )

xtile wei_quintile = wei_std, nq(5)
label define wei_lbl 1 "Very Low" 2 "Low" 3 "Medium" 4 "High" 5 "Very High"
label values wei_quintile wei_lbl
graph bar wei_std, over(wei_quintile, label(angle(45))) blabel(bar)
list  sdist wei_std wei_quintile , sepby( wei_quintile )



//Alternatively,

//Standardize Variables

foreach var in dm_health dm_purchases dm_visits ///
    no_violence1 no_violence2 no_violence3 no_violence4 no_violence5 ///
    educated reads_news watches_tv listens_radio ///
    working earnings_control ///
    move_health move_market move_family mobility_3places ///
    bank_account own_mobile owns_house owns_land control_cash
 {
    egen z_`var' = std(`var')
}

//pca of standardized variables

pca z_dm_health z_dm_purchases z_dm_visits ///
    z_no_violence1 z_no_violence2 z_no_violence3 z_no_violence4 z_no_violence5 ///
    z_educated z_reads_news z_watches_tv z_listens_radio ///
    z_working earnings_control ///
    z_move_health z_move_market z_move_family z_mobility_3places ///
    z_bank_account z_own_mobile z_owns_house z_owns_land z_control_cash
	
// Predict and Normalize the Index

predict wei_pca1  // First principal component
label variable wei_pca1 "Women Empowerment Index (PCA Comp1)"

egen wei_min = min(wei_pca1)
egen wei_max = max(wei_pca1)

gen wei_index = (wei_pca1 - wei_min)/(wei_max - wei_min)


