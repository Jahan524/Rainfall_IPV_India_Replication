* Step 1: Preserve the original data and create a subset where rainvar > 0
preserve
keep if rainvar < 0

* Step 2: Run the melogit model on the subset
melogit anyviolence rainvar rainvarsqr i.education i.maryears i.residence i.bankaccount i.workstatus i.children i.drinkalcohl i.partnereduc i.partneroccup i.wealth i.religion i.caste i.year i.month || state: || sdist:, or

* Step 3: Restore the original data
restore

preserve
sum rainvar, detail
keep if rainvar > r(p1) & rainvar < r(p99)
melogit anyviolence rainvar rainvarsqr i.education i.maryears i.residence i.bankaccount i.workstatus i.children i.drinkalcohl i.partnereduc i.partneroccup i.wealth i.religion i.caste i.year i.month || state: || sdist:, or
restore

melogit anyviolence stdrainvar  i.education i.maryears i.residence i.bankaccount i.workstatus i.children i.drinkalcohl i.partnereduc i.partneroccup i.wealth i.religion i.caste i.year i.month || state: || sdist:, or

levelsof pregion, local(pregion)
foreach r of local pregion {
    preserve
    keep if pregion == `r'
    bootstrap, reps(500): melogit anyviolence rainvar rainvarsqr i.education i.maryears i.residence i.bankaccount i.workstatus i.children i.drinkalcohl i.partnereduc i.partneroccup i.wealth i.religion i.caste i.year i.month || state: || sdist:, or
    restore
}



bootstrap, reps(500): melogit anyviolence rainvar c.rainvar#i.education i.maryears i.residence i.bankaccount i.workstatus i.children i.drinkalcohl i.partnereduc i.partneroccup i.wealth i.religion i.caste i.year i.month || state: || sdist:, or 
bootstrap, reps(500): melogit physicviolence rainvar c.rainvar#i.education i.maryears i.residence i.bankaccount i.workstatus i.children i.drinkalcohl i.partnereduc i.partneroccup i.wealth i.religion i.caste i.year i.month || state: || sdist:, or 
bootstrap, reps(500): melogit sexviolence rainvar c.rainvar#i.education i.maryears i.residence i.bankaccount i.workstatus i.children i.drinkalcohl i.partnereduc i.partneroccup i.wealth i.religion i.caste i.year i.month || state: || sdist:, or 
bootstrap, reps(500): melogit emoviolence rainvar c.rainvar#i.education i.maryears i.residence i.bankaccount i.workstatus i.children i.drinkalcohl i.partnereduc i.partneroccup i.wealth i.religion i.caste i.year i.month || state: || sdist:, or

gen agroincome=.
replace agroincome=1 if partneroccup==6
replace agroincome=0 if agroincome==.
tab agroincome,m



preserve
sum rainvar, detail
keep if rainvar > r(p1) & rainvar < r(p99)
bootstrap, reps (500): melogit anyviolence rainvar  c.rainvar#i.education i.education i.maryears i.residence i.bankaccount i.workstatus i.children i.drinkalcohl i.partnereduc i.agroincome i.wealth i.religion i.caste i.year i.month || state: || sdist:, or
restore

gen agro=.
replace agro=1 if occupation==6
replace agro=0 if agro==.
tab agro,m

gsem (agro <- rainvar i.education i.maryears i.residence i.bankaccount i.workstatus i.children i.drinkalcohl i.partnereduc i.wealth i.religion i.caste i.year i.month M1[state] M2[sdist], family(gaussian) link(identity)) ///
     (anyviolence <- rainvar i.agro i.education i.maryears i.residence i.bankaccount i.workstatus i.children i.drinkalcohl i.partnereduc i.wealth i.religion i.caste i.year i.month M1[state] M2[sdist], family(gaussian) link(identity)), ///
     vce(robust) 
	 
	 gsem (agro <- rainvar i.education i.maryears i.residence i.bankaccount i.workstatus i.children i.drinkalcohl i.partnereduc i.wealth i.religion i.caste i.year i.month  M1[sdist], family(gaussian) link(identity)) ///
     (anyviolence <- rainvar i.agro i.education i.maryears i.residence i.bankaccount i.workstatus i.children i.drinkalcohl i.partnereduc i.wealth i.religion i.caste i.year i.month  M1[sdist], family(gaussian) link(identity)), ///
     vce(robust) nocapslatent iterate(500)
	 
	 
preserve
sum rainvar, detail
keep if rainvar > r(p1) & rainvar < r(p99)
melogit anyviolence rainvar c.rainvar#i.soi i.soi i.education i.maryears i.residence i.bankaccount i.workstatus i.children i.drinkalcohl i.partnereduc i.wealth i.religion i.caste i.year i.month || state: || sdist:, or
restore