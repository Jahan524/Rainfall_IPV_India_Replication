
rename var1 distid
label var distid "District Code"

rename var2 dist
label var dist "District's Name"

rename var3 atemp_mx20
label var atemp_mx20 "Yearly average of maximum temperature in 2020"

rename var4 atemp_mean20
label var atemp_mean20 "Yearly average of mean temperature in 2020"

rename var5 atemp_min20
label var atemp_min20 "Yearly average of minimum temperature in 2020"

rename var6 aprec_max20
label var aprec_max20 "Yearly average of maximum precipitation in 2020"

rename var7 aprec_mean20
label var aprec_mean20 "Yearly average of mean precipitation in 2020"

rename var8 aprec_min20
label var aprec_min20 "Yearly average of minimum precipitation in 2020"

rename var9 co2_mean20
label var co2_mean20 "average co2 concentration in parts per million (ppm) in 2020"

rename var10 co2_max20
label var co2_max20 "maximum co2 concentration in parts per million (ppm) in 2020"

rename var11 co2_min20
label var co2_min20 "minimum co2 concentration in parts per million (ppm) in 2020"

gen ndvi_max20=var12/10000
label var ndvi_max20 "maximum normalized difference vegetetion index in 2020"

drop var12

gen ndvi_mean20=var13/10000
label var ndvi_mean20 "average normalized difference vegetetion index in 2020"
drop var13

gen ndvi_min20=var59/10000
label var ndvi_min20 "minimum normalized difference vegetetion index in 2020"
drop var59

rename var15 pva_12
label var pva_12 "% of physical violence by any partner in last 12 months"

rename var16 sva_12
label var sva_12 "% of sexual violence by any partner in last 12 months"

rename var17 eva_12
label var eva_12 "% of emotional violence by any partner in last 12 months"

rename var18 pseva_12
label var pseva_12 "% of physical or sexual or emotional violence by any partner in last 12 months"

rename var19 cast_sc
label var cast_sc "% of schedule cast respondents per unit (district)"

rename var20 cast_st
label var cast_st "% of schedule tribe respondents per unit (district)"

rename var21 cast_obc
label var cast_obc "% of OBC respondents per unit (district)"

rename var22 cast_others
label var cast_others "% of other respondents other than SC/ST/OBC  per unit (district)"

rename var23 rel_h
label var rel_h "% of hindu respondents per unit (district)"

rename var24 rel_m
label var rel_m "% of muslim respondents per unit (district)"

rename var25 rel_c
label var rel_c "% of christian respondents per unit (district)"

rename var26 rel_oth
label var rel_oth "% from other religion respondents per unit (district)"

rename var27 age_15to19
label var age_15to19 "% of respondents aged 15-19 per unit (district)"

rename var28 age_20to24
label var age_20to24 "% of respondents aged 20-24 per unit (district)"

rename var29 age_25to29
label var age_25to29 "% of respondents aged 25-29 per unit (district)"

rename var30 age_30to39
label var age_30to39 "% of respondents aged 30-39 per unit (district)"

rename var31 age_40to49
label var age_40to49 "% of respondents aged 40-49 per unit (district)"

rename var32 agdf_wold
label var agdf_wold "% of respondents when wife is older than husband per unit (district)"

rename var33 agdf_wh
label var agdf_wh "% of respondents when both are same aged per unit (district)"

rename var34 agdf_w_1to4
label var agdf_w_1to4 "% of respondents who are 1 to 4 years younger than husband per unit (district)"

rename var35 agdf_w_5to9
label var agdf_w_5to9 "% of respondents who are 5 to 9 years younger than husband per unit (district)"

rename var36 agdf_w_10
label var agdf_w_10 "% of respondents who are 10+ years younger than husband per unit (district)"

rename var37 edu_no
label var edu_no "% of respondents who have no education per unit (district)"

rename var38 edu_pri
label var edu_pri "% of respondents who have primary level of education per unit (district)"

rename var39 edu_sec
label var edu_sec "% of respondents who have secondary level of education per unit (district)"

rename var40 edu_hi
label var edu_hi "% of respondents who have higher level of education per unit (district)"

rename var41 edudf_h
label var edudf_h "% of respondents whose husbands are more educated per unit (district)"

rename var42 edudf_w
label var edudf_w "% of respondents who are more educated than husband per unit (district)"

rename var43 edudf_wh
label var edudf_wh "% of respondents who are equally educated with husband per unit (district)"

rename var44 edudf_nei
label var edudf_nei "% of respondents or their husbands are neither educated per unit (district)"

rename var45 alco_no
label var alco_no "% of respondents whose husbands are never drunk per unit (district)"

rename var46 alco_dr
label var alco_dr "% of respondents whose husbands are drunk per unit (district)"

rename var47 mar_nvr
label var mar_nvr "% of respondents who are never married per unit (district)"

rename var48 mar_evr
label var mar_evr "% of respondents who are ever married per unit (district)"

rename var49 res_urb
label var res_urb "% of respondents who reside in urban areas per unit (district)"

rename var50 res_rur
label var res_rur "% of respondents who reside in rural areas per unit (district)"

rename var51 wq_porst
label var wq_porst "% of respondents whose wealth quintal is poorest per unit (district)"

rename var52 wq_porer
label var wq_porer "% of respondents whose wealth quintal is poorer per unit (district)"

rename var53 wq_midl
label var wq_midl "% of respondents whose wealth quintal is middle per unit (district)"

rename var54 wq_richr
label var wq_richr "% of respondents whose wealth quintal is richer per unit (district)"

rename var55 wq_richst
label var wq_richst "% of respondents whose wealth quintal is richest per unit (district)"

rename var56 work_no
label var work_no "% of respondents who are not earning per unit (district)"

rename var57 work_cash
label var work_cash "% of respondents who are earning cash per unit (district)"

rename var58 work_nocs
label var work_nocs "% of respondents who are employed but not earning cash per unit (district)"













































