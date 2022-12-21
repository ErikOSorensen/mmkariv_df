clear all
set more off

// First process the free form specifications of q 2.1, 2.2, 2.5




import excel ./raw_data/data_tanzania_26JUNI.xlsx, ///
       sheet("Short follow-up p2") cellrange(B3:G2645) clear firstrow
replace q = trim(q)
replace text = trim(text)

preserve
  gen byte total = text=="total"
  keep if q =="q2.1"
  collapse (sum) amount, by(ID total)
  reshape wide amount, i(ID) j(total)
  rename amount0 yday_expenses1 
  rename amount1 yday_expenses2 
  label var yday_expenses1 "2.1 Expenses yesterday (sum of specifications)"
  label var yday_expenses2 "2.1 Expenses yesterday (reported total)"
  // Correct obvious error in summation
  replace yday_expenses2 = 653200 if ID==147
  tempfile temp21
  summ
  corr yday_expenses1 yday_expenses2
  save `temp21'
restore

preserve
  gen byte total = text=="total"
  keep if q=="q2.2"
  collapse (sum) amount, by(ID total)
  reshape wide amount, i(ID) j(total)
  rename amount0 year_expenses1
  rename amount1 year_expenses2
  label var year_expenses1 "2.2 Expenses in year (sum of specifications)"
  label var year_expenses2 "2.2 Expenses in year (reported total)"
  tempfile temp22
  summ
  corr year_expenses1 year_expenses2
  save `temp22'
restore


preserve 
  gen byte total = text=="total"
  keep if q=="q2.5"
  destring hours, replace
  list ID text hours if hours>=168 & hours<.
  replace hours = . if hours>=168
  collapse (sum) amount hours, by(ID total)
  reshape wide amount hours, i(ID) j(total)
  rename amount0 year_income1
  rename amount1 year_income2
  rename hours0 hrs_week1
  rename hours1 hrs_week2
  label var year_income1 "2.5 Earnings per year (sum of specifications)"
  label var year_income2 "2.5 Earnings per year (reported total)"
  label var hrs_week1 "2.5 Hours per week (sum of specifications)"
  label var hrs_week2 "2.5 Hours per week (reported total)"
  summ
  corr year* hrs*
  tempfile temp25
  save `temp25'
restore 

save ./processed/tanzaniasurvey_specifications, replace

import excel ./raw_data/data_tanzania_26JUNI.xlsx, clear ///
  sheet("Short follow-up p1") cellrange(B3:AK218) firstrow


gen sex = 2 if q13=="F"
replace sex =1 if q13=="M"
drop q13
label define sex 1 "male" 2 "female"
label values sex sex
label var sex "1.3 Sex"

rename q14 age
label var age "1.4 Age (in yrs)"

order ID sex age 
rename q15 birthplace
label var birthplace  "1.5 In which county were you born?"

rename q16 studysubject
label var studysubject "1.6 What subjects are you studying?"

rename q17 household
label define household 1 "on your own" 2 "w. close relatives" 3 "w. other econ supporters" 4 "w. econ dependents"
label values household household
label var household "1.7 How do you live?"

rename q18 yrs_study 
label var yrs_study "1.8 How many years have you studied"

rename q19 graduation
label var graduation "1.9 When do you plan to complete undergrad studies?"
replace graduation="2013" if graduation=="2012/2013"
destring graduation, replace force



rename q23 ann_expenses 
label var ann_expenses "2.3 Specify an estimate of your total annual expenses last year."


rename q241 ann_finance1
rename q242 ann_finance2
rename q243 ann_finance3
rename q244 ann_finance4
rename q245 ann_finance5
rename q246 ann_finance6
rename q247 ann_finance7
rename q248 ann_finance8
rename q248specifiy ann_finance8_specification
rename q249 ann_finance

label var ann_finance1 "2.4.1 Support/loan from government"
label var ann_finance2 "2.4.2 Support from family"
label var ann_finance3 "2.4.3 Loan from family"
label var ann_finance4 "2.4.4 Own work"
label var ann_finance5 "2.4.5 Scholarship grant"
label var ann_finance6 "2.4.6 Other grants"
label var ann_finance7 "2.4.7 Support from NGO"
label var ann_finance8 "2.4.8 Other (see ann_finance8specification)"
label var ann_finance8_specification "2.4.8 Specification of ann_finance8"
label var ann_finance "2.4.9 Total annual financing of expenses"

gen familysupport = (q26=="Y")
drop q26
label var familysupport "2.6 Do you receive any support from family (free meals, clothes etc.)?"
label define noyes 0 "no" 1 "yes"
label values familysupport noyes
rename q27 familysupport_value
label var familysupport_value "2.7 Value of family support in typical week"

rename q28 savings
label var savings "2.8 Estimate of savings you have available"
replace q294 = "Y" if q294=="O"
replace q291 = "N" if q291=="N "
gen byte savings_work = (q291=="Y")
gen byte savings_pargard = (q292=="Y")
gen byte savings_loans = (q293=="Y")
gen byte savings_other = (q294=="Y")
label var savings_work "2.9.1 Savings from work"
label var savings_pargard "2.9.2 Savings from parents/guardians"
label var savings_loans "2.9.3 Savings from loans"
label var savings_other "2.9.4 Savings from other sources"
label values savings_work noyes
label values savings_pargard noyes
label values savings_loans noyes
label values savings_other noyes
drop q291 q292 q293 q294


rename q210 govloan
label var govloan "2.10 How large share of your student costs is covered by government loan (% points)?"



gen byte notenough = 1 if q211=="N"
replace  notenough = 2 if q211=="S"
replace  notenough = 3 if q211=="R"
replace  notenough = 4 if q211=="A"
label define ne 1 "Never" 2 "Sometimes" 3 "Regularly" 4 "Always"
label values notenough ne
label var notenough "2.11 ..not.. enough money to buy food or any other basic items during the lst yr"
drop q211
rename q2111 notenough_comment
label var notenough_comment "2.11 Comment regarding 'notenough'"

gen byte ew_gov  = (q2121=="Y")
gen byte ew_priv = (q2122=="Y")
gen byte ew_se   = (q2123=="Y")
gen byte ew_farm = (q2124=="Y")
gen byte ew_u    = (q2125=="Y")
label var ew_gov  "2.12.1 Expect to work in government after studies"
label var ew_priv "2.12.2 Expect to be private sector employee"
label var ew_se   "2.12.3 Expect to be self-employed"
label var ew_farm "2.12.4 Expect to be in farming"
label var ew_u    "2.12.5 Expect to be unemployed"
drop q2121 q2122 q2123 q2124 q2125
label values ew_gov noyes
label values ew_priv noyes
label values ew_se noyes
label values ew_farm noyes
label values ew_u noyes

rename q213 e_salary
label var e_salary "2.13 Expected annual salary when working?"
rename q213commnets e_salary_comment
label var e_salary_comment "2.13 (comment)"


merge 1:1 ID using `temp21'
drop _merge
merge 1:1 ID using `temp22'
drop _merge
merge 1:1 ID using `temp25'
drop _merge

rename ID survey_id
label var survey_id "ID (not linkable to experiment decisions)"



/*
	Recoding a couple of fields that are way to detailed.
	
	Manual recoding of birthplace and study subject
*/ 
preserve
	insheet using "./processed/studysubjects_categorized.csv", clear
	drop n_responses
	tempfile ss
	save `ss'
	insheet using "./processed/birthplaces_categorized.csv", clear
	drop n_responses
	tempfile bp
	save `bp'
restore
replace studysubject = strtrim(studysubject)
replace birthplace = strtrim(birthplace)
merge m:1 studysubject using `ss'
rename category studysubject_categorized
tab _merge
drop _merge
merge m:1 birthplace using `bp'
tab _merge
drop _merge
rename region birth_region
label var birth_region "1.5 (Recoding of) self-reported birthplace"
label var studysubject_categorized "1.6 (Recoding of) self-reported study subject"

order survey_id sex age birth_region studysubject_categorized household yrs_study ///
  graduation yday_expenses1 yday_expenses2 year_expenses1 year_expenses2 ///
  year_income1 year_income2 hrs_week1 hrs_week2 ///
  ann_expenses ann_finance ann_finance1 ann_finance2 ///
  ann_finance3  ann_finance4  ann_finance5  ann_finance6  ann_finance7 ///
  ann_finance8 ann_finance8_specification ///
  familysupport familysupport_value savings savings_work savings_pargard ///
  savings_loans savings_other govloan notenough notenough_comment ///
  ew_gov ew_priv ew_se ew_farm ew_u e_salary e_salary_comment

drop notenough_comment birthplace studysubject


label data
compress
note : All monetary amounts in Tanzania shillings (at the time, 1USD ~= 1600 Tsh)
note : Comment on not having enough removed from dataset due to privacy.
note e_salary_comment: No comment field in survey, note made by transcriber
// note : Questions 2.1, 2.2, 2.5 with specification in separate file tanzaniasurvey_specifications
note hrs_week1: Ridiculous hours per week at 168 (survey_id=117) set to missing.
note hrs_week2: Ridiculous hours per week at 4380 (survey_id=109) set to missing.



save ./data/tanzaniasurvey, replace



