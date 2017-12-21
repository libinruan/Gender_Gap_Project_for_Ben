clear
set more off
set maxvar 32000
cd "C:\Users\I1LXJ02\Desktop\gender"
/*
// data cleaning alternative 1
insheet using "GenderStat_Data.csv", comma //The header needs to be removed beforehand.
save genderstat_data, replace
*/

// data cleaning alternative 2
use genderstat_data.dta, clear
rename v1 cname
rename v2 ccode
rename v3 iname
rename v4 icode
gen gid=_n
sort ccode gid
by ccode: gen task=_n 
order ccode icode task iname cname
forvalue i = 5/61{
	local j = `i'+1955
	rename v`i' v`j'
}
drop gid cname iname
save temp, replace

// main program

// step X. 
// task id list
#delimit ;
local tasknum 
107
108
220
221
430
399
404
476
162
164
413
104
105
134
135
223
224
252
253
255
256
278
279
283
284
352
353
393
395
396
397
398
424
425
276
280;
#delimit cr

// label list
#delimit ;
local labels
`" "Educational attainment, competed at least Bachelor's or equivalent, population 25+, female (%) (cumulative)"
"Educational attainment, competed at least Bachelor's or equivalent, population 25+, male (%) (cumulative)"
"Labor force participation rate, female (% of female population ages 15-64) (modeled ILO estimate)"
"Labor force participation rate, male (% of male population ages 15-64) (modeled ILO estimate)"
"Unemployment, female (% of female labor force) (modeled ILO estimate)"
"School enrollment, secondary (gross), gender parity index (GPI)"
"School enrollment, tertiary (gross), gender parity index (GPI)"
"Wage equality between women and men for similar work (ratio)"
"Employment to population ratio, 15+, female (%) (modeled ILO estimate)"
"Employment to population ratio, 15+, male (%) (modeled ILO estimate)"
"Sex ratio at birth (male births per female births)"
"Educational attainment, at least completed primary, population 25+ years, female (%) (cumulative)"
"Educational attainment, at least completed primary, population 25+ years, male (%) (cumulative)"
"Educational attainment, completed primary, population 25+ years, female (%)"
"Educational attainment, completed primary, population 25+ years, male (%)"
"Labor force with primary education, female (% of female labor force)"
"Labor force with primary education, male (% of male labor force)"
"Literacy rate, adult female (% of females ages 15 and above)"
"Literacy rate, adult male (% of males ages 15 and above)"
"Literacy rate, youth female (% of females ages 15-24)"
"Literacy rate, youth male (% of males ages 15-24)"
"Mortality rate, infant, female (per 1,000 live births)"
"Mortality rate, infant, male (per 1,000 live births)"
"Mortality rate, under-5, female (per 1,000)"
"Mortality rate, under-5, male (per 1,000)"
"Primary completion rate, female (% of relevant age group)"
"Primary completion rate, male (% of relevant age group)"
"School enrollment, primary (gross), gender parity index (GPI)"
"School enrollment, primary, female (% gross)"
"School enrollment, primary, female (% net)"
"School enrollment, primary, male (% gross)"
"School enrollment, primary, male (% net)"
"Unemployment with primary education, female (% of female unemployment)"
"Unemployment with primary education, male (% of male unemployment)"
"Mortality rate, female child (per 1,000 female children age one)"
"Mortality rate, male child (per 1,000 male children age one)" "';
#delimit cr

// variable list
#delimit ;
local vars
SETERCUATBAFEZS
SETERCUATBAMAZS
SLTLFACTIFEZS
SLTLFACTIMAZS
SLUEMTOTLFEZS
SEENRSECOFMZS
SEENRTERTFMZS
SGWAGEQLTFM
SLEMPTOTLSPFEZS
SLEMPTOTLSPMAZS
SPPOPBRTHMF
SEPRMCUATFEZS
SEPRMCUATMAZS
SEPRMHIATFEZS
SEPRMHIATMAZS
SLTLFPRIMFEZS
SLTLFPRIMMAZS
SEADTLITRFEZS
SEADTLITRMAZS
SEADT1524LTFEZS
SEADT1524LTMAZS
SPDYNIMRTFEIN
SPDYNIMRTMAIN
SHDYNMORTFE
SHDYNMORTMA
SEPRMCMPTFEZS
SEPRMCMPTMAZS
SEENRPRIMFMZS
SEPRMENRRFE
SEPRMNENRFE
SEPRMENRRMA
SEPRMNENRMA
SLUEMPRIMFEZS
SLUEMPRIMMAZS
SHDYNCHLDFE
SHDYNCHLDMA;
#delimit cr

// step.X labeling, and rename
local n: word count `tasknum'
forvalues i = 1/`n'{
	local t : word `i' of `tasknum'
	local l : word `i' of `labels'
	local v : word `i' of `vars'
	display "`t' says `l' `v'"
	use temp, replace
	keep if task==`t'
	keep v2010 ccode
	sort ccode
	label variable v2010 "`l'"
	rename v2010 `v'
	save `v', replace
}

// step.X data merge 
forvalues i = 1/`n'{
	local v : word `i' of `vars'
	if `i'==1{
		use `v', replace
		save temp2, replace
	}
	else
	{
		use temp2, replace
		merge 1:1 ccode using `v'
		drop _merge
		save temp2, replace
	}
}

// step.X 

 




