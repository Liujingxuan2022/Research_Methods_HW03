* Read in data: 
insheet using sports-and-education.csv

* Balance tables 

global balanceopts "prehead(\begin{tabular}{l*{6}{c}}) postfoot(\end{tabular}) noisily noeqlines nonumbers varlabels(_cons Constant, end("" ) nolast)  starlevels(* 0.1 ** 0.05 *** 0.01)"

estpost ttest academicquality athleticquality nearbigmarket, by(ranked2017) unequal welch

esttab using test.rtf, cell("mu_1(f(3)) mu_2(f(3)) b(f(3) star)") wide label collabels("Control" "Treatment" "Difference")

* Constructing model

logit ranked2017 academicquality athleticquality nearbigmarket

eststo logit_regression 

global tableoptions "bf(%15.2gc) sfmt(%15.2gc) se label noisily noeqlines nonumbers varlabels(_cons Constant, end("" ) nolast)  starlevels(* 0.1 ** 0.05 *** 0.01) replace r2"

esttab regression_one using HW3-Table2.rtf, $tableoptions

* Predict propensity_score 

predict propensity_score, pr

* Propensity score graph: 

twoway (hist propensity_score if ranked2017 == 0, frac lcolor(none) fcolor(green%30)) (hist  propensity_score if ranked2017 == 1, frac fcolor(red%30) lcolor(none)), legend(off) xtitle("Green: Ranked; red: Not-ranked")

* Filtering out non-overlapped region

summarize propensity_score if ranked2017 == 0
summarize propensity_score if ranked2017 == 1

** from the tables generated from the above code, we found the minimum of overlap to be .1999533 and 
** maximum of overlap to be .7788376 we filter out values that lie beyond these boundaries 

keep if  propensity_score <=.7788376 & propensity_score >= .1999533

* Generate blocks
sort propensity_score
gen block = floor(_n/4)

* Estimating effect
reg alumnidonations2018 ranked2017 academicquality athleticquality nearbigmarket, absorb(block)

eststo main_regression
esttab main_regression using HW3-Table3.rtf, $tableoptions


