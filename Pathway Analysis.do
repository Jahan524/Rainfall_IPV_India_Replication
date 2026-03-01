

//Main Result:GLMM
melogit anyviolence rainvar i.wealth i.wemploy i.informal i.residence i.education  i.age i.maryears i.partnereduc i.wealth i.bankaccount i.children i.religion i.drinkalcohl  i.year i.month ||state: ||distric:,or
melogit physicviolence rainvar i.wealth i.wemploy i.informal i.residence i.education  i.age i.maryears i.partnereduc i.wealth i.bankaccount i.children i.religion i.drinkalcohl  i.year i.month ||state: ||distric:,or 
melogit sexviolence rainvar i.wealth i.wemploy i.informal i.residence i.education  i.age i.maryears i.partnereduc i.wealth i.bankaccount i.children i.religion i.drinkalcohl  i.year i.month ||state: ||distric:,or
melogit emoviolence rainvar i.wealth i.wemploy i.informal i.residence i.education  i.age i.maryears i.partnereduc i.wealth i.bankaccount i.children i.religion i.drinkalcohl  i.year i.month ||state: ||distric:,or


//Quadratic Analysis
melogit anyviolence rainvar rainvarsqr ///
    i.wealth i.wemploy i.informal i.residence i.education i.age i.maryears ///
    i.partnereduc i.bankaccount i.children i.religion i.drinkalcohl ///
    i.year i.month || state: || distric:, or

melogit physicviolence rainvar rainvarsqr ///
    i.wealth i.wemploy i.informal i.residence i.education i.age i.maryears ///
    i.partnereduc i.bankaccount i.children i.religion i.drinkalcohl ///
    i.year i.month || state: || distric:, or
melogit sexviolence rainvar rainvarsqr ///
    i.wealth i.wemploy i.informal i.residence i.education i.age i.maryears ///
    i.partnereduc i.bankaccount i.children i.religion i.drinkalcohl ///
    i.year i.month || state: || distric:, or
melogit emoviolence rainvar rainvarsqr ///
    i.wealth i.wemploy i.informal i.residence i.education i.age i.maryears ///
    i.partnereduc i.bankaccount i.children i.religion i.drinkalcohl ///
    i.year i.month || state: || distric:, or
	

	
//Precipitory Zone Analysis

preserve
keep if prezon==2|prezon==1|prezon==3
bootstrap _b, reps(500) seed(12345): ///
melogit anyviolence stdrainvar  i.residence i.education  i.age i.maryears i.wealth i.informal i.wemploy i.partnereduc i.bankaccount i.children i.religion i.drinkalcohl  i.year i.month ||state: ||distric:,or
restore

preserve
keep if prezon==4
bootstrap _b, reps(500) seed(12345): ///
melogit anyviolence stdrainvar  i.residence i.education  i.age i.maryears i.wealth i.informal i.wemploy i.partnereduc i.bankaccount i.children i.religion i.drinkalcohl  i.year i.month ||state: ||distric:,or
restore

preserve
keep if prezon==5|prezon==6|prezon==7
bootstrap _b, reps(500) seed(12345): ///
melogit anyviolence stdrainvar  i.residence i.education  i.age i.maryears i.wealth i.informal i.wemploy i.partnereduc i.bankaccount i.children i.religion i.drinkalcohl  i.year i.month ||state: ||distric:,or
restore

//Mechanism Analysis
melogit anyviolence c.rainvar##i.wealth i.wemploy i.informal i.residence i.education  i.age i.maryears i.partnereduc i.wealth i.bankaccount i.children i.religion i.drinkalcohl  i.year i.month ||state: ||distric:,or

melogit anyviolence c.rainvar##i.wemploy i.wealth  i.informal i.residence i.education  i.age i.maryears i.partnereduc i.wealth i.bankaccount i.children i.religion i.drinkalcohl  i.year i.month ||state: ||distric:,or

melogit anyviolence c.rainvar##i.informal i.wemploy i.wealth  i.residence i.education  i.age i.maryears i.partnereduc i.wealth i.bankaccount i.children i.religion i.drinkalcohl  i.year i.month ||state: ||distric:,or

melogit anyviolence c.rainvar##i.drinkalcohl i.informal i.wemploy i.wealth  i.residence i.education  i.age i.maryears i.partnereduc i.wealth i.bankaccount i.children i.religion   i.year i.month ||state: ||distric:,or

//subgroup analyses

foreach w in 1 2 3 4 5 {
    melogit anyviolence rainvar i.wealth i.wemploy i.informal i.residence i.education ///
        i.age i.partnereduc i.bankaccount i.children i.religion i.drinkalcohl ///
        i.year i.month if wealth == `w' || state: || distric:, or
}
foreach r in 1 2 {
    melogit anyviolence rainvar i.wealth i.wemploy i.informal i.education ///
        i.age i.partnereduc i.bankaccount i.children i.religion i.drinkalcohl ///
        i.year i.month if residence == `r' || state: || distric:, or
}
foreach e in 0 1 {
    melogit anyviolence rainvar i.wealth i.informal i.residence i.education ///
        i.age i.partnereduc i.bankaccount i.children i.religion i.drinkalcohl ///
        i.year i.month if wemploy == `e' || state: || distric:, or
}
foreach i in 0 1 {
    melogit anyviolence rainvar i.wealth i.wemploy i.residence i.education ///
        i.age i.partnereduc i.bankaccount i.children i.religion i.drinkalcohl ///
        i.year i.month if informal == `i' || state: || distric:, or
}
foreach a in 0 1 {
    melogit anyviolence rainvar i.wealth i.wemploy i.informal i.residence ///
        i.education i.age i.partnereduc i.bankaccount i.children i.religion ///
        i.year i.month if drinkalcohl == `a' || state: || distric:, or
}
foreach e in 0 1 2 3 {
    melogit anyviolence rainvar i.wealth i.wemploy i.informal i.residence ///
        i.age i.partnereduc i.bankaccount i.children i.religion i.drinkalcohl ///
        i.year i.month if education == `e' || state: || distric:, or
}



//Backlash theory
gsem ///
   (wei_index <-  c.rainvar##wemploy z_wealth i.informal i.age i.maryears ///
       i.residence i.education i.partnereduc i.bankaccount i.children ///
       i.religion i.drinkalcohl i.year i.month, family(gaussian)) ///
   (anyviolence <- wei_index weisq  rainvar wemploy z_wealth i.informal i.age i.maryears ///
       i.residence i.education i.partnereduc i.bankaccount i.children ///
       i.religion i.drinkalcohl i.year i.month L1[district] L2[state], ///
       family(bernoulli) link(logit))

nlcom (indirect:_b[wei_index: 1.wemploy#c.rainvar]*_b[anyviolence:wei_index])
nlcom (direct: _b[anyviolence:rainvar])	
nlcom (total:_b[anyviolence:rainvar] + _b[wei_index: 1.wemploy#c.rainvar]*_b[anyviolence:wei_index])

nlcom (indirect_or:exp(_b[wei_index: 1.wemploy#c.rainvar]*_b[anyviolence:wei_index]))
nlcom (direct_or: exp(_b[anyviolence:rainvar]))	
nlcom (total_or:exp(_b[anyviolence:rainvar] + _b[wei_index: 1.wemploy#c.rainvar]*_b[anyviolence:wei_index]))

//Stress thory


gsem ///
   (z_wealth <- c.rainvar##i.informal i.age i.maryears ///
       i.residence i.education i.partnereduc i.bankaccount i.children ///
       i.religion i.wemploy i.year i.month, family(gaussian)) ///
   (drinkalcohl <- z_wealth c.rainvar##i.informal i.age i.maryears ///
       i.residence i.education i.partnereduc i.bankaccount i.children ///
       i.religion i.wemploy i.year i.month, family(bernoulli)) ///
   (anyviolence <- drinkalcohl z_wealth c.rainvar##i.informal i.age i.maryears ///
       i.residence i.education i.partnereduc i.bankaccount i.children ///
       i.religion i.wemploy i.year i.month L1[district] L2[state], ///
       family(bernoulli) link(logit))

nlcom (indirect:_b[z_wealth:1.informal#c.rainvar]*_b[drinkalcohl:z_wealth]*_b[anyviolence:drinkalcohl])
nlcom (direct: _b[anyviolence:rainvar])	
nlcom (total:_b[anyviolence:rainvar] + _b[z_wealth:1.informal#c.rainvar]*_b[drinkalcohl:z_wealth]*_b[anyviolence:drinkalcohl] )

nlcom (indirect_or:exp(_b[z_wealth:1.informal#c.rainvar]*_b[drinkalcohl:z_wealth]*_b[anyviolence:drinkalcohl]))
nlcom (direct_or: exp(_b[anyviolence:rainvar]))	
nlcom (total_or:exp(_b[anyviolence:rainvar] + _b[z_wealth:1.informal#c.rainvar]*_b[drinkalcohl:z_wealth]*_b[anyviolence:drinkalcohl] ))

//Robustness Check


* First install ftools (helper for fast fixed effects)
ssc install ftools, replace

* Then install reghdfe (main command for LPM with FE)
ssc install reghdfe, replace

* Optionally install dependencies (if prompted)
ssc install hdfe, replace
ssc install ivreg2, replace


* LPM with district FE, cluster SE at district
reghdfe anyviolence rainvar i.wealth i.wemploy i.informal i.residence i.education i.age ///
        i.partnereduc i.bankaccount i.children i.religion i.drinkalcohl i.year i.month, ///
        absorb(district) vce(cluster district)
		
reghdfe physicviolence rainvar i.wealth i.wemploy i.informal i.residence i.education i.age ///
        i.partnereduc i.bankaccount i.children i.religion i.drinkalcohl i.year i.month, ///
        absorb(district) vce(cluster district)
		
reghdfe sexviolence rainvar i.wealth i.wemploy i.informal i.residence i.education i.age ///
        i.partnereduc i.bankaccount i.children i.religion i.drinkalcohl i.year i.month, ///
        absorb(district) vce(cluster district)
		
reghdfe emoviolence rainvar i.wealth i.wemploy i.informal i.residence i.education i.age ///
        i.partnereduc i.bankaccount i.children i.religion i.drinkalcohl i.year i.month, ///
        absorb(district) vce(cluster district)

//Probit link with mixed effects

meprobit anyviolence rainvar i.wealth i.wemploy i.informal i.residence i.education  i.age i.maryears i.partnereduc i.wealth i.bankaccount i.children i.religion i.drinkalcohl  i.year i.month ||state: ||distric:, robust
estat icc

meprobit physicviolence rainvar i.wealth i.wemploy i.informal i.residence i.education  i.age i.maryears i.partnereduc i.wealth i.bankaccount i.children i.religion i.drinkalcohl  i.year i.month ||state: ||distric:
estat icc
meprobit sexviolence rainvar i.wealth i.wemploy i.informal i.residence i.education  i.age i.maryears i.partnereduc i.wealth i.bankaccount i.children i.religion i.drinkalcohl  i.year i.month ||state: ||distric:
estat icc
meprobit emoviolence rainvar i.wealth i.wemploy i.informal i.residence i.education  i.age i.maryears i.partnereduc i.wealth i.bankaccount i.children i.religion i.drinkalcohl  i.year i.month ||state: ||distric:
estat icc

//Positive or Negative Rainfall Variation
preserve
keep if rainvar<0
melogit anyviolence rainvar  i.residence i.education  i.age i.maryears i.wealth i.informal i.wemploy i.partnereduc i.bankaccount i.children i.religion i.drinkalcohl  i.year i.month ||state: ||distric:,or
restore
estat icc

preserve
keep if rainvar<0
melogit physicviolence rainvar  i.residence i.education  i.age i.maryears i.wealth i.informal i.wemploy i.partnereduc i.bankaccount i.children i.religion i.drinkalcohl  i.year i.month ||state: ||distric:,or
restore
estat icc

preserve
keep if rainvar<0
melogit sexviolence rainvar  i.residence i.education  i.age i.maryears i.wealth i.informal i.wemploy i.partnereduc i.bankaccount i.children i.religion i.drinkalcohl  i.year i.month ||state: ||distric:,or
restore
estat icc

preserve
keep if rainvar<0
melogit emoviolence rainvar  i.residence i.education  i.age i.maryears i.wealth i.informal i.wemploy i.partnereduc i.bankaccount i.children i.religion i.drinkalcohl  i.year i.month ||state: ||distric:,or
restore
estat icc

preserve
keep if rainvar>0
melogit anyviolence rainvar  i.residence i.education  i.age i.maryears i.wealth i.informal i.wemploy i.partnereduc i.bankaccount i.children i.religion i.drinkalcohl  i.year i.month ||state: ||distric:,or
restore
estat icc 

preserve
keep if rainvar>0
melogit physicviolence rainvar  i.residence i.education  i.age i.maryears i.wealth i.informal i.wemploy i.partnereduc i.bankaccount i.children i.religion i.drinkalcohl  i.year i.month ||state: ||distric:,or
restore
estat icc 

preserve
keep if rainvar>0
melogit sexviolence rainvar  i.residence i.education  i.age i.maryears i.wealth i.informal i.wemploy i.partnereduc i.bankaccount i.children i.religion i.drinkalcohl  i.year i.month ||state: ||distric:,or
restore
estat icc 

preserve
keep if rainvar>0
melogit emoviolence rainvar  i.residence i.education  i.age i.maryears i.wealth i.informal i.wemploy i.partnereduc i.bankaccount i.children i.religion i.drinkalcohl  i.year i.month ||state: ||distric:,or
restore
estat icc 

//Stadardized Rainfall Variation

melogit anyviolence stdrainvar i.age i.maryears i.residence i.education i.wemploy i.bankaccount i.children i.partnereduc i.informal i.drinkalcohl i.religion  i.wealth i.year i.month ||state: ||distric: ,or 
estat icc
melogit physicviolence stdrainvar  i.wemploy i.informal i.residence i.education  i.age i.maryears i.partnereduc i.wealth i.bankaccount i.children i.religion i.drinkalcohl  i.year i.month ||state: ||distric:,or 
estat icc
melogit sexviolence stdrainvar  i.wemploy i.informal i.residence i.education  i.age i.maryears i.partnereduc i.wealth i.bankaccount i.children i.religion i.drinkalcohl  i.year i.month ||state: ||distric:,or
estat icc
melogit emoviolence stdrainvar  i.wemploy i.informal i.residence i.education  i.age i.maryears i.partnereduc i.wealth i.bankaccount i.children i.religion i.drinkalcohl  i.year i.month ||state: ||distric:,or

////Trimmed Values
preserve
sum rainvar, detail
keep if rainvar> r(p1) & rainvar < r(p99)
melogit anyviolence rainvar i.wealth i.wemploy i.informal i.residence i.education  i.age i.maryears i.partnereduc i.wealth i.bankaccount i.children i.religion i.drinkalcohl  i.year i.month ||state: ||distric:,or
restore

preserve
sum rainvar, detail
keep if rainvar> r(p1) & rainvar < r(p99)
melogit physicviolence rainvar i.wealth i.wemploy i.informal i.residence i.education  i.age i.maryears i.partnereduc i.wealth i.bankaccount i.children i.religion i.drinkalcohl  i.year i.month ||state: ||distric:,or
restore

preserve
sum rainvar, detail
keep if rainvar> r(p1) & rainvar < r(p99)
melogit sexviolence rainvar i.wealth i.wemploy i.informal i.residence i.education  i.age i.maryears  i.partnereduc i.wealth i.bankaccount i.children i.religion i.drinkalcohl  i.year i.month ||state: ||distric:,or
restore

preserve
sum rainvar, detail
keep if rainvar> r(p1) & rainvar < r(p99)
melogit emoviolence rainvar  i.wealth i.wemploy i.informal i.residence i.education  i.age i.maryears i.partnereduc i.wealth i.bankaccount i.children i.religion i.drinkalcohl  i.year i.month ||state: ||distric:,or
restore

//Trimmed with LPM

preserve
sum rainvar, detail
local p1 = r(p1)
local p99 = r(p99)

keep if rainvar > `p1' & rainvar < `p99'
display "Observations after trimming: " _N

* LPM with district FE (reghdfe)
reghdfe anyviolence rainvar i.wealth i.wemploy i.informal i.residence i.education i.age i.maryears///
        i.partnereduc i.bankaccount i.children i.religion i.drinkalcohl i.year i.month, ///
        absorb(district) vce(cluster district)

restore

preserve
sum rainvar, detail
local p1 = r(p1)
local p99 = r(p99)

keep if rainvar > `p1' & rainvar < `p99'
display "Observations after trimming: " _N

* LPM with district FE (reghdfe)
reghdfe physicviolence rainvar i.wealth i.wemploy i.informal i.residence i.education i.age i.maryears ///
        i.partnereduc i.bankaccount i.children i.religion i.drinkalcohl i.year i.month, ///
        absorb(district) vce(cluster district)

restore

preserve
sum rainvar, detail
local p1 = r(p1)
local p99 = r(p99)

keep if rainvar > `p1' & rainvar < `p99'
display "Observations after trimming: " _N

* LPM with district FE (reghdfe)
reghdfe sexviolence rainvar i.wealth i.wemploy i.informal i.residence i.education i.age i.maryears ///
        i.partnereduc i.bankaccount i.children i.religion i.drinkalcohl i.year i.month, ///
        absorb(district) vce(cluster district)

restore

preserve
sum rainvar, detail
local p1 = r(p1)
local p99 = r(p99)

keep if rainvar > `p1' & rainvar < `p99'
display "Observations after trimming: " _N

* LPM with district FE (reghdfe)
reghdfe emoviolence rainvar i.wealth i.wemploy i.informal i.residence i.education i.age i.maryears///
        i.partnereduc i.bankaccount i.children i.religion i.drinkalcohl i.year i.month, ///
        absorb(district) vce(cluster district)

restore

//Trimmed with Probit model

preserve
sum rainvar, detail
local p1 = r(p1)
local p99 = r(p99)

keep if rainvar > `p1' & rainvar < `p99'
display "Observations after trimming: " _N

meprobit anyviolence rainvar i.wealth i.wemploy i.informal i.residence i.education i.age i.maryears ///
        i.partnereduc i.bankaccount i.children i.religion i.drinkalcohl i.year i.month ///
        || state: || district:

restore
estat icc

preserve
sum rainvar, detail
local p1 = r(p1)
local p99 = r(p99)

keep if rainvar > `p1' & rainvar < `p99'
display "Observations after trimming: " _N

meprobit physicviolence rainvar i.wealth i.wemploy i.informal i.residence i.education i.age i.maryears///
        i.partnereduc i.bankaccount i.children i.religion i.drinkalcohl i.year i.month ///
        || state: || district:

restore
estat icc

preserve
sum rainvar, detail
local p1 = r(p1)
local p99 = r(p99)

keep if rainvar > `p1' & rainvar < `p99'
display "Observations after trimming: " _N

meprobit sexviolence rainvar i.wealth i.wemploy i.informal i.residence i.education i.age i.maryears///
        i.partnereduc i.bankaccount i.children i.religion i.drinkalcohl i.year i.month ///
        || state: || district:

restore
estat icc

preserve
sum rainvar, detail
local p1 = r(p1)
local p99 = r(p99)

keep if rainvar > `p1' & rainvar < `p99'
display "Observations after trimming: " _N

meprobit emoviolence rainvar i.wealth i.wemploy i.informal i.residence i.education i.age i.maryears///
        i.partnereduc i.bankaccount i.children i.religion i.drinkalcohl i.year i.month ///
        || state: || district:

restore
estat icc

//Non-Linearity with Z value
bootstrap _b, reps(500) seed(12345): ///
melogit anyviolence stdrainvar stdrainvarsqr ///
    i.wealth i.wemploy i.informal i.residence i.education i.age i.maryears ///
    i.partnereduc i.bankaccount i.children i.religion i.drinkalcohl ///
    i.year i.month || state: || distric:, or

bootstrap _b, reps(500) seed(12345): ///
melogit physicviolence stdrainvar stdrainvarsqr ///
    i.wealth i.wemploy i.informal i.residence i.education i.age i.maryears ///
    i.partnereduc i.bankaccount i.children i.religion i.drinkalcohl ///
    i.year i.month || state: || distric:, or
	
bootstrap _b, reps(500) seed(12345): ///
melogit sexviolence stdrainvar stdrainvarsqr ///
    i.wealth i.wemploy i.informal i.residence i.education i.age i.maryears ///
    i.partnereduc i.bankaccount i.children i.religion i.drinkalcohl ///
    i.year i.month || state: || distric:, or
	
bootstrap _b, reps(500) seed(12345): ///
melogit emoviolence stdrainvar stdrainvarsqr ///
    i.wealth i.wemploy i.informal i.residence i.education i.age i.maryears ///
    i.partnereduc i.bankaccount i.children i.religion i.drinkalcohl ///
    i.year i.month || state: || distric:, or
	