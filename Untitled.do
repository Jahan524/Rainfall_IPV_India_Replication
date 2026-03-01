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