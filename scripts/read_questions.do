clear all
insheet using ../processed/jonasothers.csv, delimit(";") names
gen byte session = 5 if sessionid=="GYOVF"
replace  session = 7 if sessionid=="HJSCV"
replace  session = 8 if sessionid=="AFKYR"
gen int ID = 100*session + computerid
replace ID=805 if ID==705 // Punching error
drop sessionid
rename sex gender
gen byte sex = 1 + (gender=="Female")
drop gender
rename program programt
gen byte kull = programt=="Bachelor"
drop programt
keep ID sex kull age session
tempfile jonasq
save `jonasq'

clear all
insheet using ../raw/players.csv, clear
rename id ID
append using `jonasq'
gen country = 1*(session < 9) + 2*(session>=9)
label var country "Country of experiment"
label define country 1 "Tanzania" 2 "United States"
label values country country

drop session



rename kull program
label define program 1 "bachelor" 2 "master" 9 "other"
label var program "Which educational program are you in"
label values program program

label define sex 1 "male" 2 "female"
label values sex sex
label var sex "Your gender"
label var age "Your age"

compress
save ../processed/questions, replace

