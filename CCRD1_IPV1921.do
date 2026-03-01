 logit anyviolence rainvar i.age i.maryears i.residence i.education i.partnereduc i.occupation i.partneroccup i.wealth i.bankaccount i.children i.religion i.drinkalcohl i.workstatus, robust
 //multicollinearity for workstatus and occupation
 
 logit anyviolence rainvar i.age i.maryears i.residence i.education i.partnereduc i.partneroccup i.wealth i.bankaccount i.children i.religion i.drinkalcohl i.workstatus, robust

//logit with fixed effects, clustered within state

logit anyviolence rainvar i.age i.maryears i.residence i.education i.partnereduc i.partneroccup i.wealth i.bankaccount i.children i.religion i.drinkalcohl i.workstatus i.year i.month i.district, vce(cluster state)

logistic anyviolence rainvar i.age i.maryears i.residence i.education i.partnereduc i.partneroccup i.wealth i.bankaccount i.children i.religion i.drinkalcohl i.workstatus i.year i.month i.district, vce(cluster state)


estat ic
estat gof

//GLMM with fixed and random effects
melogit anyviolence rainvar i.age i.maryears i.residence i.education i.partnereduc i.partneroccup i.wealth i.bankaccount i.children i.religion i.drinkalcohl i.workstatus i.year i.month ||state: ||district:

melogit anyviolence rainvar i.age i.maryears i.residence i.education i.partnereduc i.partneroccup i.wealth i.bankaccount i.children i.religion i.drinkalcohl i.workstatus i.year i.month ||state: ||district:, or
estat ic
estat icc

//Logit on different categories
logistic physicviolence rainvar i.age i.maryears i.residence i.education i.partnereduc i.partneroccup i.wealth i.bankaccount i.children i.religion i.drinkalcohl i.workstatus i.year i.month i.district, vce(cluster state)

logistic sexviolence rainvar i.age i.maryears i.residence i.education i.partnereduc i.partneroccup i.wealth i.bankaccount i.children i.religion i.drinkalcohl i.workstatus i.year i.month i.district, vce(cluster state)

logistic emoviolence rainvar i.age i.maryears i.residence i.education i.partnereduc i.partneroccup i.wealth i.bankaccount i.children i.religion i.drinkalcohl i.workstatus i.year i.month i.district, vce(cluster state)

//GLMM on different categories

melogit anyviolence rainvar i.age i.maryears i.residence i.education i.partnereduc i.partneroccup i.wealth i.bankaccount i.children i.religion i.drinkalcohl i.workstatus i.year i.month ||state: ||district:, or
melogit physicviolence rainvar i.age i.maryears i.residence i.education i.partnereduc i.partneroccup i.wealth i.bankaccount i.children i.religion i.drinkalcohl i.workstatus i.year i.month ||state: ||district:, or
melogit sexviolence rainvar i.age i.maryears i.residence i.education i.partnereduc i.partneroccup i.wealth i.bankaccount i.children i.religion i.drinkalcohl i.workstatus i.year i.month ||state: ||district:, or
melogit emoviolence rainvar i.age i.maryears i.residence i.education i.partnereduc i.partneroccup i.wealth i.bankaccount i.children i.religion i.drinkalcohl i.workstatus i.year i.month ||state: ||district:, or

// Sensitivity analysis


