clear all
use ./processed/playersiq, replace
merge 1:1 ID using ./processed/big5
drop _merge
merge 1:1 ID using ./processed/others
drop _merge
merge 1:1 ID using ./processed/questions
drop _merge

compress
sort ID
replace country = 1*(ID < 900) + 2*(ID>=900)

label var ID "Participant identifier"
order ID country sex age program iq BF_A BF_C BF_E BF_N BF_O
save ./data/background, replace
