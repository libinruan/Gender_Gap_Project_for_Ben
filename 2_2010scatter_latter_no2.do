clear
set more off
// set maxvar 32000
cd "C:\Users\I1LXJ02\Desktop\gender"
use temp2, replace

//log
rename SPPOPBRTHMF sexratio

// no1
gen cum_edu_atleast_primary = SEPRMCUATMAZS - SEPRMCUATFEZS 
gen log_cum_edu_atleast_primary = log(SEPRMCUATMAZS/SEPRMCUATFEZS)

// no2 <----
gen cum_edu_atleast_bach = SETERCUATBAMAZS - SETERCUATBAFEZS
gen log_cum_edu_atleast_bach = log(SETERCUATBAMAZS/SETERCUATBAFEZS)
 
// no3 <----
gen lab_par = SLTLFACTIMAZS - SLTLFPRIMFEZS
gen log_lab_par = log(SLTLFACTIMAZS/SLTLFPRIMFEZS)

// no4
gen lit_adult = SEADTLITRMAZS - SEADTLITRFEZS
gen log_lit_adult = log(SEADTLITRMAZS/SEADTLITRFEZS)

// no5
gen lit_youth = SEADT1524LTMAZS - SEADT1524LTFEZS
gen log_lit_youth = log(SEADT1524LTMAZS/SEADT1524LTFEZS)

// no6
gen mort_inf = SPDYNIMRTMAIN - SPDYNIMRTFEIN
gen log_mort_inf = log(SPDYNIMRTMAIN/SPDYNIMRTFEIN)

// no7
gen mort_underfive = SHDYNMORTMA - SHDYNMORTFE
gen log_mort_underfive = log(SHDYNMORTMA/SHDYNMORTFE)

// no8
gen primary_comp_rate = SEPRMCMPTMAZS - SEPRMCMPTFEZS 
gen log_primary_comp_rate = log(SEPRMCMPTMAZS/SEPRMCMPTFEZS)

// no9
gen sch_enroll_grs = SEPRMENRRMA - SEPRMENRRFE
gen log_sch_enroll_grs = log(SEPRMENRRMA/SEPRMENRRFE)

// no10
gen sch_enroll_net = SEPRMNENRMA - SEPRMNENRFE
gen log_sch_enroll_net = log(SEPRMNENRMA/SEPRMNENRFE)

// no11 <----
gen unemp_fema = SLUEMTOTLFEZS
gen log_unemp_fema = log(SLUEMTOTLFEZS)

// no12
gen gpi = SEENRPRIMFMZS

// no 13
gen gpi_sch_enroll_sec = SEENRSECOFMZS
gen log_gpi_sch_enroll_sec = log(SEENRSECOFMZS)

// no 14
gen gpi_sch_enroll_ter = SEENRTERTFMZS
gen log_gpi_sch_enroll_ter = log(SEENRTERTFMZS)

// no 15 no data available
/*
gen wage_equ_sim_work = SGWAGEQLTFM
gen log_wage_equ_sim_work = log(SGWAGEQLTFM)
*/

// no 16
gen emp_to_pop = SLEMPTOTLSPMAZS - SLEMPTOTLSPFEZS
gen log_emp_to_pop = log(SLEMPTOTLSPMAZS/SLEMPTOTLSPFEZS)

// ----------------------------------------------------
#delimit ;
local taskvar
cum_edu_atleast_primary
log_cum_edu_atleast_primary
cum_edu_atleast_bach
log_cum_edu_atleast_bach
lab_par
log_lab_par
lit_adult
log_lit_adult
lit_youth
log_lit_youth
mort_inf
log_mort_inf
mort_underfive
log_mort_underfive
primary_comp_rate
log_primary_comp_rate
sch_enroll_grs
log_sch_enroll_grs
sch_enroll_net
log_sch_enroll_net
emp_to_pop
log_emp_to_pop
unemp_fema
gpi
gpi_sch_enroll_sec
gpi_sch_enroll_ter;
#delimit cr

/*
local n: word count `taskvar'
forvalues i = 1/`n'{
	local t : word `i' of `taskvar'
	display "`t'"
}
*/

//scatter plots ---------------------------------------
local n: word count `taskvar'
forvalues i = 1/`n'{
	local v : word `i' of `taskvar'
	if `i'!=1{
		drop fitted
	}
	quiet regress sexratio `v'
	quiet predict fitted
	//ereturn list
	matrix mat1 = e(b)
	local b1=mat1[1,1]
	local b2=mat1[1,2]
	local t1 = e(r2)-(e(r2)-floor(1000000*e(r2))/1000000)
	local t2 = `b1'-(`b1'-floor(1000000*`b1')/1000000)
	local t3 = `b2'-(`b2'-floor(1000000*`b2')/1000000)
	#delimit ;
	line fitted `v' || scatter sexratio `v',
		mlabel(ccode) leg(off) //note(R-squared=`t1') 
		subtitle(y=`t2' + `t3'*x R-squared=`t1');
	#delimit cr
	graph export `i'.png, replace
}
