
	   
melogit anyviolence rainvar i.pagro  i.wealth i.bankaccount i.children i.religion i.drinkalcohl i.workstatus i.year i.month ||state: ||district:, or

gsem ///
    (z_wealth <- rainvar i.pagro i.age i.maryears i.residence ///
        i.education i.partnereduc i.bankaccount i.children i.religion ///
        i.workstatus i.year i.month L1[district] L2[state], ///
        family(gaussian) link(identity)) ///
    (wei_index <- z_wealth rainvar i.pagro i.age i.maryears i.residence ///
        i.education i.partnereduc i.bankaccount i.children i.religion ///
        i.workstatus i.year i.month L1[district] L2[state], ///
        family(gaussian) link(identity)) ///
    (anyviolence <- wei_index z_wealth rainvar i.pagro i.age i.maryears ///
        i.residence i.education i.partnereduc i.bankaccount i.children ///
        i.religion i.workstatus i.year i.month L1[district] L2[state], ///
        family(bernoulli) link(logit))


gsem ///
    (drinkalcohl <- c.rainvar##i.wealth ///
        i.bagro i.age i.maryears i.residence i.education i.partnereduc ///
        i.bankaccount i.children i.religion i.workstatus i.year i.month ///
        L1[district] L2[state], ///
        family(bernoulli) link(logit)) ///
    (anyviolence <- rainvar drinkalcohl i.wealth  ///
        i.bagro i.age i.maryears i.residence i.education i.partnereduc ///
        i.bankaccount i.children i.religion i.workstatus i.year i.month ///
        L1[district] L2[state], ///
        family(bernoulli) link(logit))

gsem ///
    (fdi_index <- rainvar i.wealth i.bagro i.age i.maryears i.residence ///
                 i.education i.partnereduc i.bankaccount i.children ///
                 i.religion i.workstatus i.year i.month L1[district] L2[state], ///
                 family(gaussian) link(identity)) ///
    (wei_index <- fdi_index rainvar i.wealth i.bagro i.age i.maryears i.residence ///
                 i.education i.partnereduc i.bankaccount i.children ///
                 i.religion i.workstatus i.year i.month L1[district] L2[state], ///
                 family(gaussian) link(identity)) ///
    (drinkalcohl <- wei_index fdi_index rainvar i.wealth i.bagro i.age i.maryears ///
                   i.residence i.education i.partnereduc i.bankaccount ///
                   i.children i.religion i.workstatus i.year i.month ///
                   L1[district] L2[state], ///
                   family(bernoulli) link(logit)) ///
    (anyviolence <- drinkalcohl wei_index fdi_index rainvar i.wealth i.bagro i.age ///
                    i.maryears i.residence i.education i.partnereduc ///
                    i.bankaccount i.children i.religion i.workstatus ///
                    i.year i.month L1[district] L2[state], ///
                    family(bernoulli) link(logit))



// RV -> BAGRO -> IPV
gsem ///
    (wealth <- rainvar ///
       i.bagro i.age i.maryears i.residence i.education i.partnereduc ///
       i.bankaccount i.children i.religion i.workstatus i.year i.month ///
       L1[district] L2[state], family(bernoulli) link(logit)) ///
	(drinkalcohl <- rainvar wealth ///
       i.bagro i.age i.maryears i.residence i.education i.partnereduc ///
       i.bankaccount i.children i.religion i.workstatus i.year i.month ///
       L1[district] L2[state], family(bernoulli) link(logit)) ///
    (anyviolence <- rainvar wealth i.bagro  ///
       i.age i.maryears i.residence i.education i.partnereduc ///
       wealth i.bankaccount i.children i.religion i.drinkalcohl i.workstatus i.year i.month ///
       L1[district] L2[state], family(bernoulli) link(logit))
	   
// Indirect effect path: RV -> BAGRO -> IPV
 nlcom (indirect: ///
   _b[bagro:rainvar] * _b[anyviolence:bagro])
    indirect: _b[bagro:rainvar] * _b[anyviolence:bagro] 

// Direct effect of RV on IPV
  nlcom (direct: _b[anyviolence:rainvar])
  direct: _b[anyviolence:rainvar]

// Total effect = direct + indirect
 nlcom (total: ///
   _b[anyviolence:rainvar] + _b[bagro:rainvar] * _b[anyviolence:bagro])

   total:  _b[anyviolence:rainvar] + _b[bagro:rainvar] * _b[anyviolence:bagro]
   
//For easier interpretation

nlcom (indirect_or: exp(_b[bagro:rainvar] * _b[anyviolence:bagro]))
nlcom (direct_or: exp(_b[anyviolence:rainvar]))
nlcom (total_or: exp(_b[anyviolence:rainvar] + (_b[bagro:rainvar] * _b[anyviolence:bagro])))

 bootstrap r(indirect), reps(1000) seed(12345): indirect_effect
  

// RV -> residence -> IPV
gsem ///
   (drinkalcohl <- rainvar i.pagro///
       i.age i.maryears i.education i.residence i.partnereduc ///
       i.wealth i.bankaccount i.children i.religion i.workstatus i.year i.month ///
       L1[district] L2[state], family(bernoulli) link(logit)) ///
   (anyviolence <- rainvar drinkalcohl i.residence i.pagro  ///
       i.wealth i.bankaccount i.children i.religion  ///
       i.workstatus i.year i.month ///
       L1[district] L2[state], family(bernoulli) link(logit))
	   
// Indirect effect path: RV -> PAGRO -> IPV
 nlcom (indirect: ///
   _b[pagro:rainvar] * _b[anyviolence:pagro])
    indirect: _b[pagro:rainvar] * _b[anyviolence:pagro] 

// Direct effect of RV on IPV
  nlcom (direct: _b[anyviolence:rainvar])
  direct: _b[anyviolence:rainvar]

// Total effect = direct + indirect
 nlcom (total: ///
   _b[anyviolence:rainvar] + _b[pagro:rainvar] * _b[anyviolence:pagro])

   total:  _b[anyviolence:rainvar] + _b[pagro:rainvar] * _b[anyviolence:pagro]