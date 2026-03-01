keep  caseid YoI MoI sdist distcode dv_state dv_aprtnr_phy_12m dv_aprtnr_sex_12m dv_aprtnr_emot_12m dv_aprtnr_phy_sex_12m dv_aprtnr_phy_emot_12m dv_aprtnr_emot_sex_12m  dv_aprtnr_phy_sex_emot_any_12m dv_husb_drink dv_age_diff dv_edu_diff dv_work dv_liv_child dv_age dv_mari_status dv_mar_years dv_religion dv_caste dv_drunk rainfall

drop if missing( dv_aprtnr_phy_sex_emot_any_12m )

tab dv_aprtnr_phy_sex_emot_any_12m

gen time=ym( YoI , MoI )

format time %tm

encode caseid, gen(id)

xtset id time

tab time

pwcorr dv_aprtnr_phy_sex_emot_any_12m dv_husb_drink dv_age dv_religion dv_caste dv_mar_years dv_liv_child dv_work rainfall, sig

logistic dv_aprtnr_phy_sex_emot_any_12m rainfall i.dv_age i.dv_religion i.dv_drunk i.dv_edu_diff

xtlogit dv_aprtnr_phy_sex_emot_any_12m rainfall i.dv_age i.dv_religion i.dv_drunk i.dv_edu_diff, re




