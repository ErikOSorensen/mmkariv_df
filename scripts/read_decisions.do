clear all
use ../raw/050112_S9, clear
keep ID Treatment Round Y X YM XM
drop if ID<100
label var ID "Participant identifier"
label var Treatment "High or low prices in Tanzania"
label var Round "Sequence number of decision"
label var Y "Y coordinate of decision"
label var X "X coordinate of decision"
label var YM "Maximum attainable Y (at X=0)"
label var XM "Maximum attainable X (at Y=0)"
label define Treatment 0 "0.5 USD/token" 1 "100 TZS/token" 2 "1000 TZS/token"
label values Treatment Treatment
compress
saveold ../publishing/decisions, replace


