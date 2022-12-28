clear all
set more off

// First, handle the paper data from Tanzania. Replace
// Big-5 answer with mean answer for that question if
// two or less are missing for a particular category.
insheet using ./raw_data/jonasbig5.csv, clear

gen byte sesnr = 5 if sessionid =="GYOVF"
replace  sesnr = 7 if sessionid =="HJSCV"
replace  sesnr = 8 if sessionid =="AFKYR"
gen int ID = 100*sesnr + computerid
drop sessionid computerid sesnr o1
reshape long bf, i(ID) j(item)
rename bf answer
// For some reason, it seems that big 705 has both paper
// and computer big5. This is because of a punching error,
// should have been punched as an "AFKYR" session.
replace ID=805 if ID==705
tempfile punched
save `punched'

insheet using ./raw_data/noincentivequestions.csv, comma clear
rename id ID
keep if inlist(question,"BFS1","BFS2","BFS3", "BFS4")
destring item, force replace ignore(bf)
drop if item>=.
destring answer, replace
preserve
drop question
append using `punched'
rename item B5item
save ./data/big5items, replace
restore
append using `punched'
gen acc = inlist(item,1,6,16,21,31,36,2,7,12,17,27,32,37,42,3,8,13,18)
replace acc = 1 if inlist(item,23,28,33,43,9,19,24,29,34,39,5,30,35,41)
bys ID: egen bfiavet = mean(answer) if acc==1
bys ID: egen bfistdt = sd(answer) if acc ==1
bys ID: egen bfiave = min(bfiavet)
bys ID: egen bfistd = min(bfistdt)
gen zbfi = (answer - bfiave)/bfistd
keep ID item zbfi

/*
        Pragmatic approach: replace b5 answer with mean answer if 
        two or less are missing for a particular categori.
*/
gen     cat = 1 if inlist(item,1,6,11,16,21,26,31,36)
replace cat = 2 if inlist(item,2,7,12,17,22,27,32,37,42)
replace cat = 3 if inlist(item,3,8,13,18,23,28,33,38,43)
replace cat = 4 if inlist(item,4,9,14,19,24,29,34,39)
replace cat = 5 if inlist(item,5,10,15,20,25,30,35,40,41,44)
bys cat: egen mcat=mean(zbfi)
bys ID cat: egen ncat = count(zbfi)
replace zbfi = mcat if (zbfi>=. & ncat>6 & cat==1)
replace zbfi = mcat if (zbfi>=. & ncat>7 & cat==2)
replace zbfi = mcat if (zbfi>=. & ncat>7 & cat==3)
replace zbfi = mcat if (zbfi>=. & ncat>5 & cat==4) 
replace zbfi = mcat if (zbfi>=. & ncat>7 & cat==5)
drop mcat ncat cat

reshape wide zbfi , i(ID) j(item)
gen BF_E = (zbfi1 - zbfi6 + zbfi11 + zbfi16 ///
                  - zbfi21 + zbfi26 - zbfi31 + zbfi36)/8
gen BF_A = (-zbfi2 + zbfi7 - zbfi12 + zbfi17 ///
                   + zbfi22 - zbfi27 + zbfi32 - zbfi37 + zbfi42)/9
gen BF_C = (zbfi3 - zbfi8 + zbfi13 - zbfi18 ///
                       - zbfi23 + zbfi28 + zbfi33 + zbfi38 - zbfi43)/9
gen BF_N = (zbfi4 - zbfi9 + zbfi14 + zbfi19 - zbfi24 ///
                 + zbfi29 - zbfi34 + zbfi39)/8
gen BF_O = (zbfi5 + zbfi10 + zbfi15 + zbfi20 + zbfi25 ///
              +zbfi30 - zbfi35 + zbfi40 - zbfi41 + zbfi44)/10
keep ID BF*
label var BF_E "Extraversion (BFI)"
label var BF_A "Agreeableness (BFI)"
label var BF_C "Conscientiousness (BFI)"
label var BF_N "Neuroticism (BFI)"
label var BF_O "Openness (BFI)"
sort ID
save ./processed/big5, replace
