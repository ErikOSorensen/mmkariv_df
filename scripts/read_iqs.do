clear all
set more off
// First, reading in the punched data.
insheet using ./processed/jonasiq.csv, comma
gen byte sesnr = 5 if sessionid =="GYOVF"
replace  sesnr = 7 if sessionid =="HJSCV"
replace  sesnr = 8 if sessionid =="AFKYR"
gen int ID = 100*sesnr + computerid
drop sesnr sessionid
count if ID==705
tempfile jonasiq
save `jonasiq'

insheet using ./raw_data/iqfasit.csv, comma clear
tempfile iqfasit
save `iqfasit'
insheet using ./raw_data/iqmatrices.csv, comma clear
rename id ID
count if ID==705
append using `jonasiq'
merge m:1 mnr using `iqfasit'
drop _merge

drop test
gen byte point = (answer==correct)
gen double ts = clock(timestamp, "YMDhms")
gen double iqstart = clock(start, "YMDhms")
label var iqstart "IQ started"
label var ID "personal id"
label var mnr "matrix no."
label var answer "Answer given"
label var correct "Correct answer"
label var point "Points from this matrix"
label var ts "Timestamp"
format %tc ts iqstart
drop timestamp
order ID iqstart mnr ts answer correct point
keep if answer<.
drop computerid
sort ID mnr
saveold ./data/iqmatrices, replace
tempfile playersiq
keep if mnr>2
collapse (sum) iq = point, by(ID)
label var iq "points on WAIS-IV matrix test (out of 26 possible)"
order ID
compress
save ./processed/playersiq, replace
