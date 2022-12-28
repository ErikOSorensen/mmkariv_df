clear all
set more off
insheet using ./raw_data/jonasothers.csv, delimit(";") names
gen byte session = 5 if sessionid=="GYOVF"
replace  session = 7 if sessionid=="HJSCV"
replace  session = 8 if sessionid=="AFKYR"
gen int ID = 100*session + computerid
replace ID=805 if ID==705 // Punching error
drop sessionid computerid
drop program age session sex
foreach t in mother2school father2school motheruni fatheruni workincome ypleased yworried yhappy {
  rename `t' `t't
  gen byte `t' = (`t't=="Y" | `t't=="y")
  drop `t't
}

tempfile jonaso
save `jonaso'

clear all
insheet using ./raw_data/noincentivequestions.csv, comma clear
rename id ID
keep if inlist(question,"BO1","BO2") | item=="o1"
replace item = "bo0" if item=="o1"
drop question
destring item, replace ignore("bo") force
// A few managed to report duplicates.
bys ID item (answer): keep if _n==_N

drop v5 v6
reshape wide answer, i(ID) j(item)


destring answer0, gen(gambling)
label var gambling "I am someone who likes to gamble for its own sake"
label define agree 1 "disagree strongly" 2 "disagree a little" 3 "neutral" 4 "agree a little" 5 "agree strongly"
label values gambling agree
drop answer0

gen mother2school = 1*(answer1=="yes")
gen father2school = 1*(answer2=="yes")
gen motheruni = 1*(answer3=="yes")
gen fatheruni = 1*(answer4=="yes")
drop answer1 answer2 answer3 answer4
label var mother2school "Did your mother go to secondary school?"
label var father2school "Did your father go to secondary school?"
label var motheruni "Did your mother go to university?"
label var fatheruni "Did your father go to university?"
label define yes 0 "no" 1 "yes"
label values mother2school yes
label values father2school yes
label values motheruni yes
label values fatheruni yes

gen workincome = 1*(answer5=="yes")
label values workincome yes
label var workincome "Do you have income from work?"
label values workincome yes
drop answer5
rename answer6 worktype 
label var worktype "type of work? (workincome)"

destring answer7 , gen(withonemillion)
label var withonemillion "What would you do if you had 1 millon Tsh?"
drop answer7
label define with1m 1 "Buy something nice for my self or my family"
label define with1m 2 "Start a business", add
label define with1m 3 "Pay for my education", add
label define with1m 4 "Other (specify)", add 
label values withonemillion with1m
rename answer8 withonemillionspecify
label var withonemillionspecify "Specify other (4) of withonemillion"

destring answer20, gen(jobopp_govm) 
destring answer21, gen(jobopp_ownb)
destring answer22, gen(jobopp_farm)
label define jobopp 1 "Not so good" 2 "Neutral" 3 "Very good"
label values jobopp_govm jobopp
label values jobopp_ownb jobopp
label values jobopp_farm jobopp
label var jobopp_govm "How would you rate being government employee?"
label var jobopp_ownb "How would you rate having own business?" 
label var jobopp_farm "How would you rate being a farmer?"
drop answer20 answer21 answer22

drop answer23
// Bug in data collection in question about fairness of income difference.

destring answer24, gen(happy)
label var happy "How happy with your life these days?"
label define happy 0 "unhappy" 10 "happy"
label values happy happy
drop answer24

gen ypleased = 1*(answer25=="yes")
gen yworried = 1*(answer26=="yes")
gen yhappy   = 1*(answer27=="yes")
label values ypleased yes
label values yworried yes
label values yhappy yes
label var ypleased "Were you pleased most of yesterday?"
label var yworried "Were you worried most of yesterday?"
label var yhappy   "Were you happy most of yesterday?"
drop answer27 answer25 answer26

append using `jonaso'

label var withonemillion2 "Some (on paper) indicated two answers to 'withonemillion'"
label values  withonemillion2 with1m

order ID gambling worktype withonemillion withonemillion2

compress
save ./processed/others, replace
