gen agroincome=.
replace agroincome=1 if partneroccup==6
replace agroincome=0 if agroincome==.
tab agroincome,m



preserve
sum rainvar, detail
keep if rainvar > r(p1) & rainvar < r(p99)
bootstrap, reps (500): melogit anyviolence rainvar  c.rainvar#i.education i.education i.maryears i.residence i.bankaccount i.workstatus i.children i.drinkalcohl i.partnereduc i.agroincome i.wealth i.religion i.caste i.year i.month || state: || sdist:, or
restore



melogit anyviolence rainvar i.agroincome c.rainvar#i.agroincome i.education i.maryears i.residence i.bankaccount i.workstatus i.children i.drinkalcohl i.partnereduc  i.wealth i.religion i.caste i.year i.month || state: || sdist:, or

gsem ()