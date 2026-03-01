//ANY PARTNER VIOLENCE
//in last 12 months (current partner)
		gen dv_prtnr_phy_12m = 0 if v044==1 & v502>0
		foreach x in a b c d e f g j {
			replace dv_prtnr_phy_12m = 1 if (d105`x'==1 | d105`x'==2)
			}
		label val dv_prtnr_phy_12m yesno
		label var dv_prtnr_phy_12m	"Any physical violence in past 12 mos. by partner"

//in the last 12 months (any partner)
		gen dv_aprtnr_phy_12m = 0 if v044==1 & v502>0
		replace dv_aprtnr_phy_12m = 1 if (dv_prtnr_phy_12m==1 | d130a==1)
		label val dv_aprtnr_phy_12m yesno
		label var dv_aprtnr_phy_12m "Experienced physical violence in past 12 mos. by any partner"
		
//ANY SEXUAL VIOLENCE
//in last 12 months (current partner)
		gen dv_prtnr_sex_12m = 0 if v044==1 & v502>0
		foreach x in h i k {
			replace dv_prtnr_sex_12m = 1 if (d105`x'==1 | d105`x'==2)
			}
		label val dv_prtnr_sex_12m yesno
		label var dv_prtnr_sex_12m	"Any sexual violence in past 12 mos. by partner"
		
//in the last 12 months (any partner)
		gen dv_aprtnr_sex_12m = 0 if v044==1 & v502>0
		replace dv_aprtnr_sex_12m = 1 if (dv_prtnr_sex_12m==1 | d130b==1)
		label val dv_aprtnr_sex_12m yesno
		label var dv_aprtnr_sex_12m "Experienced sexual violence in past 12 mos. by any partner"

//EXPERIENCED EMOTIONAL VIOLENCE
//in last 12 months (current partner)
		gen dv_prtnr_emot_12m = 0 if v044==1 & v502>0
		foreach x in a b c {
			replace dv_prtnr_emot_12m = 1 if (d103`x'==1 | d103`x'==2)
			}
		label val dv_prtnr_emot_12m yesno
		label var dv_prtnr_emot_12m	"Any emotional violence by partner in past 12 mos. by partner"
//in the last 12 months (any partner)
		gen dv_aprtnr_emot_12m = 0 if v044==1 & v502>0
		replace dv_aprtnr_emot_12m = 1 if (dv_prtnr_emot_12m==1 | d130c==1)
		label val dv_aprtnr_emot_12m yesno
		label var dv_aprtnr_emot_12m "Experienced emotional violence in past 12 mos. by any partner"
		
//EXPERIENCED PHYSICAL AND SEXUAL VIOLENCE BY PARTNER
//in the last 12 months (current partner)
		gen dv_prtnr_phy_sex_12m = 0 if v044==1 & v502>0
		replace dv_prtnr_phy_sex_12m = 1 if (dv_prtnr_phy_12m==1 & dv_prtnr_sex_12m==1)
		label val dv_prtnr_phy_sex_12m yesno
		label var dv_prtnr_phy_sex_12m	"Experienced physical and sexual violence by partner in the last 12 months"
//in the last 12 months (any partner)
		gen dv_aprtnr_phy_sex_12m = 0 if v044==1 & v502>0
		replace dv_aprtnr_phy_sex_12m = 1 if (dv_aprtnr_phy_12m==1 & dv_aprtnr_sex_12m==1)
		label val dv_aprtnr_phy_sex_12m yesno
		label var dv_aprtnr_phy_sex_12m "Experienced physical AND sexual violence in past 12 mos. by any partner"
			
//EXPERIENCED PHYSICAL AND EMOTIONAL VIOLENCE BY PARTNER
//in the last 12 months(current partner)
		gen dv_prtnr_phy_emot_12m = 0 if v044==1 & v502>0
		replace dv_prtnr_phy_emot_12m = 1 if (dv_prtnr_phy_12m==1 & dv_prtnr_emot_12m==1)
		label val dv_prtnr_phy_emot_12m yesno
		label var dv_prtnr_phy_emot_12m	"Experienced physical and emotional violence by partner in the last 12 months"
//in the last 12 months (any partner)
        gen dv_aprtnr_phy_emot_12m = 0 if v044==1 & v502>0
		replace dv_aprtnr_phy_emot_12m = 1 if (dv_aprtnr_phy_12m==1 & dv_aprtnr_emot_12m==1)
		label val dv_aprtnr_phy_emot_12m yesno
		label var dv_aprtnr_phy_emot_12m "Experienced physical AND emotional violence in past 12 mos. by any partner"	
		
/EXPERIENCED EMOTIONAL AND SEXUAL VIOLENCE BY PARTNER
//in the last 12 months(current partner)
		gen dv_prtnr_emot_sex_12m = 0 if v044==1 & v502>0
		replace dv_prtnr_emot_sex_12m = 1 if (dv_prtnr_emot_12m==1 & dv_prtnr_sex_12m==1)
		label val dv_prtnr_emot_sex_12m yesno
		label var dv_prtnr_emot_sex_12m	"Experienced emotional and sexual violence by partner in the last 12 months"
//in the last 12 months (any partner)
		gen dv_aprtnr_emot_sex_12m = 0 if v044==1 & v502>0
		replace dv_aprtnr_emot_sex_12m = 1 if (dv_aprtnr_emot_12m==1 & dv_aprtnr_sex_12m==1)
		label val dv_aprtnr_emot_sex_12m yesno
		label var dv_aprtnr_emot_sex_12m "Experienced emotional AND sexual violence in past 12 mos. by any partner"
		
//EXPERIENCED PHYSICAL AND SEXUAL AND EMOTIONAL VIOLENCE BY PARTNER
//in the last 12 months (current partner)
		gen dv_prtnr_phy_sex_emot_12m = 0 if v044==1 & v502>0
		replace dv_prtnr_phy_sex_emot_12m = 1 if (dv_prtnr_phy_12m==1 & dv_prtnr_sex_12m==1 & dv_prtnr_emot_12m==1)
		label val dv_prtnr_phy_sex_emot_12m yesno
		label var dv_prtnr_phy_sex_emot_12m	"Experienced physical and sexual and emotional violence by partner in the last 12 months"
//in the last 12 months (any partner)
		gen dv_aprtnr_phy_sex_emot_12m = 0 if v044==1 & v502>0
		replace dv_aprtnr_phy_sex_emot_12m = 1 if (dv_aprtnr_phy_12m==1 & dv_aprtnr_sex_12m==1 & dv_aprtnr_emot_12m==1)
		label val dv_aprtnr_phy_sex_emot_12m yesno
		label var dv_aprtnr_phy_sex_emot_12m "Experienced physical AND sexual AND emotional violence in past 12 mos. by any partner"

	
//EXPERIENCED PHYSICAL OR SEXUAL OR EMOTIONAL VIOLENCE BY PARTNER
//in the last 12 months(current partner)
		gen dv_prtnr_phy_sex_emot_any_12m = 0 if v044==1 & v502>0
		replace dv_prtnr_phy_sex_emot_any_12m = 1 if (dv_prtnr_phy_12m==1 | dv_prtnr_sex_12m==1 | dv_prtnr_emot_12m==1)
		label val dv_prtnr_phy_sex_emot_any_12m yesno
		label var dv_prtnr_phy_sex_emot_any_12m	"Experienced physical OR sexual OR emotional violence by partner in the last 12 months"

//in the last 12 months (any partner)
		gen dv_aprtnr_phy_sex_emot_any_12m = 0 if v044==1 & v502>0
		replace dv_aprtnr_phy_sex_emot_any_12m = 1 if (dv_aprtnr_phy_12m==1 | dv_aprtnr_sex_12m==1 | dv_aprtnr_emot_12m==1)
		label val dv_aprtnr_phy_sex_emot_any_12m yesno
		label var dv_aprtnr_phy_sex_emot_any_12m "Experienced physical OR sexual OR emotional violence in past 12 mos. by any partner"


		
		
**SET UP COVARIATES and labels
	//subgroups
	label var v502 "marital status"
	label define NA 0 "NA" //for sub groups where no median can be defined

	//marital group of never married and ever married
	recode v502 (0=1 "never married") (1/2=2 "ever married"), gen(marital_2)
	label var marital_2 "Ever or never married"
	
	//duration of marriage
	recode v512 (0/1= 1 "<2") (2/4=2 "2-4") (5/9=3 "5-9") (10/50=4 "10+"), gen(mar_years)
	label var mar_years "Years since first cohabitation"
	
	//DV age groups
	gen dv_age = v013
	replace dv_age = 4 if v013==5
	replace dv_age = 5 if (v013==6 | v013==7)
	label define dv_age 1 "15-19" 2 "20-24" 3 "25-29" 4 "30-39" 5 "40-49"
	label values dv_age dv_age
	label var dv_age "age groups"
	
	//religion
	gen religion=.
	replace religion=1 if v130==1
	replace religion=2 if v130==2
	replace religion=3 if v130==3
	replace religion=4 if v130>3
	label define religion 1 "hindu" 2"muslim" 3"christian" 4"others"
	label val religion religion
	label var religion religion
	rename religion dv_religion
	
	//Caste
	gen dv_caste=.
	replace dv_caste=1 if s116==1
	replace dv_caste=2 if s116==2
	replace dv_caste=3 if s116==3
	replace dv_caste=4 if s116==4
	replace dv_caste=4 if s116==8
	label define dv_caste 1"schedule caste" 2"schedule tribe" 3"obc" 4"others"
	label val dv_caste dv_caste
	label var dv_caste "belong to a SC,ST,OBC"
	
	//living children
	egen livingchild = cut(v218), at(0,1,3,5,98)
	label define livingchild 0 "0" 1 "1-2" 3 "3-4" 5 "5+" 98 "DK/missing"
	label values livingchild livingchild
	label var livingchild "living children"
	
	//work status and type of earnings 
	gen work = 0
	replace work = 1 if (v741==1 | v741==2) //earns cash
	replace work = 2 if (v741==0 | v741==3) //does not earn cash
	replace work = 9 if (v741==9)
	label define work 0 "not employed" 1 "earns cash" 2 "does not earn cash" 9 "missing type of earnings"
	label values work work
	label var work "work status and type of earnings"
	
	//gen husband/wife education difference
	gen edu_diff = 0 if v502==1 
	replace edu_diff = 1 if (v715>v133) & v502==1
	replace edu_diff = 2 if (v715<v133) & v502==1
	replace edu_diff = 3 if (v715==v133) & v502==1
	replace edu_diff = 4 if (v715==0 & v133==0 & v502==1)
	replace edu_diff = 5 if (v715==98 | v133==98) & v502==1
	label define edu_diff 1 "husband better educated" 2 "wife better educated" 3 "equally educated" 4 "neither educated" 5 "DK/missing"
	label val edu_diff edu_diff
	label var edu_diff "Spousal education difference"
	
	//gen husband/wife age difference
	gen age_diff_temp = v730-v012 if v502==1 
	recode age_diff_temp (-50/-1 = 1 "Wife older") (0=2 "Same age") (1/4=3 "Wife 1-4 yrs younger") (5/9=4 "Wife 5-9 yrs younger") (10/max=5 "Wife 10+ yrs younger"), gen (age_diff)
	label var age_diff "Spousal age difference"
	rename age_diff dv_age_diff
    tab dv_age_diff
	
	//husband's alcohol consumption
	gen husb_drink = d113
	replace husb_drink = 1 if d114==0
	replace husb_drink = 2 if d114==2
	replace husb_drink = 3 if d114==1
	label define husb_drink 0 "doesn't drink" 1 "drinks, never drunk" 2 "drinks, sometimes drunk" 3 "drinks, often drunk"
	label val husb_drink husb_drink
	label var husb_drink "husband's drinking habits"
	// rename to allign the variable
	rename husb_drink dv_husb_drink
    tab dv_husb_drink
	
	// Just Drunk or not
	gen dv_drunk=.
	replace dv_drunk=0 if dv_husb_drink==0 | dv_husb_drink==1
	replace dv_drunk=1 if dv_husb_drink==2 | dv_husb_drink==3
	label define dv_drunk 0 " never drunk" 1 "drunk"
	label val dv_drunk dv_drunk
	label var dv_drunk "Husband is drunk or not"
	
	//number of decisions women participate in
	foreach x in a b d {
		recode v743`x' (1/2=1) (4/6=0), gen(decision_`x')
		}
	egen decisions = rowtotal(decision_a decision_b decision_d) if v502==1
	label var decisions "Number of decisions in which women participate"
	
//Rename for convenience

rename v190 dv_wealth
rename v106 dv_education
rename livingchild dv_liv_child
rename work dv_work
rename v024 dv_state
rename mar_years dv_mar_years
rename  marital_2  dv_mari_status
rename v025 dv_residence
rename edu_diff dv_edu_diff
rename d121 dv_tv
rename v136 dv_hhold_size


* limiting to women age 15-49
drop if v012<15 | v012>49

cap gen dwt = d005/1000000

//subgroups
local subgroup dv_age dv_residence dv_state dv_mari_status dv_work dv_liv_child dv_education dv_wealth

local subgroup dv_age dv_residence dv_state dv_mari_status dv_work dv_liv_child dv_education dv_wealth dv_age_diff dv_edu_diff dv_husb_drink dv_mar_years dv_work
	
//v024 by state or region sdist for district wise	
tab sdist   dv_aprtnr_phy_12m  [iw=dwt], row nofreq
tab sdist   dv_aprtnr_sex_12m  [iw=dwt], row nofreq
tab sdist   dv_aprtnr_emot_12m  [iw=dwt], row nofreq
tab sdist   dv_aprtnr_phy_sex_emot_any_12m  [iw=dwt], row nofreq
tab dv_state   dv_age  [iw=dwt], row nofreq 
tab sdist   dv_age  [iw=dwt], row nofreq
tab dv_state  dv_age_diff [iw=dwt], row freq
tab sdist  dv_age_diff [iw=dwt], row nofreq
tab dv_state dv_edu_diff [iw=dwt], row freq
tab sdist  dv_edu_diff [iw=dwt], row nofreq
tab dv_state  dv_work  [iw=dwt], row freq
tab sdist  dv_work  [iw=dwt], row nofreq
tab dv_state  dv_mar_years  [iw=dwt], row freq
tab sdist  dv_mar_years  [iw=dwt], row nofreq
tab dv_state  dv_husb_drink [iw=dwt], row freq
tab sdist  dv_husb_drink [iw=dwt], row nofreq
tab dv_state   dv_liv_child  [iw=dwt], row freq
tab sdist  dv_liv_child  [iw=dwt], row nofreq
tab dv_state   dv_residence  [iw=dwt], row freq 
tab sdist   dv_residence   [iw=dwt], row nofreq
tab dv_state   dv_education  [iw=dwt], row freq 
tab sdist   dv_education  [iw=dwt], row nofreq
tab dv_state   dv_wealth  [iw=dwt], row nofreq
tab sdist   dv_wealth   [iw=dwt], row freq 
tab sdist   dv_religion   [iw=dwt], row nofreq
tab sdist   dv_caste   [iw=dwt], row nofreq


