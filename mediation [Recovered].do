melogit anyviolence i.agro i.agro#c.rainvar i.education i.age i.maryears i.residence i.partnereduc i.partneroccup i.wealth i.bankaccount i.children i.religion i.drinkalcohl i.workstatus i.year i.month ||state: ||district:, or
melogit anyviolence i.agro i.agro#c.rainvarsqr i.education i.age i.maryears i.residence i.partnereduc i.partneroccup i.wealth i.bankaccount i.children i.religion i.drinkalcohl i.workstatus i.year i.month ||state: ||district:, or
melogit anyviolence i.wealth i.wealth#c.rainvarsqr i.education i.age i.maryears i.residence i.partnereduc i.partneroccup i.wealth i.bankaccount i.children i.religion i.drinkalcohl i.workstatus i.year i.month ||state: ||district:, or
gen pagro=.
replace pagro=1 if partneroccup ==6
replace pagro=0 if pagro==.
melogit anyviolence i.pagro i.pagro#c.rainvar i.education i.age i.maryears i.residence i.partnereduc i.partneroccup i.wealth i.bankaccount i.children i.religion i.drinkalcohl i.workstatus i.year i.month ||state: ||district:, or
gen bagro=.
replace bagro=1 if agro==1 | pagro==1
replace bagro=0 if bagro==.
tab bagro
melogit anyviolence i.bagro i.bagro#c.rainvar i.education i.age i.maryears i.residence i.partnereduc i.partneroccup i.wealth i.bankaccount i.children i.religion i.drinkalcohl i.workstatus i.year i.month ||state: ||district:, or
tab partneroccup, nolab
tab partneroccup,
gen informal=.
replace informal=1 if partneroccup==6 | partneroccup==7| partneroccup==9
replace informal=0 if informal==.
tab informal
melogit anyviolence i.informal i.informal#c.rainvar i.education i.age i.maryears i.residence i.partnereduc i.partneroccup i.wealth i.bankaccount i.children i.religion i.drinkalcohl i.workstatus i.year i.month ||state: ||district:, or
melogit anyviolence rainvar c.rainvar#i.informal i.informal i.education i.age i.maryears i.residence i.partnereduc i.partneroccup i.wealth i.bankaccount i.children i.religion i.drinkalcohl i.workstatus i.year i.month ||state: ||district:, or