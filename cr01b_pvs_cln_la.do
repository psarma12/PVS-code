* PVS cleaning for appending datasets
* December 2022
* TEMP file for Laos 
* N. Kapoor 

************************************* Laos ************************************

* Import data 
use "$data/Laos/02 recoded data/pvs_clean_weighted.dta", clear


* Note: For other data, .a means NA, .r means refused, .d is don't know, . is missing 


*------------------------------------------------------------------------------*
* Rename all variables, and some recoding if variable will be dropped 
* NOTE: Could be more efficiently renamed, just doing this now as it's probably easier to review

ren study_id respondent_serial
* NOTE: No way to really know if this is unique or not once merged (could be overlap)
* NOTE: Consider creating new serial per country data 
encode cal_int, gen(interviewerid)
ren lang language

ren bd1101A q1
ren bd1102A q2
ren bd1103 q3 
ren bd1104A q4 
ren bd1105 q5
lab val q5 province 
* NOTE: bd1105 is province, ignore b1105a
ren bd1106 q7
ren bd1108 q8
ren hs1209 q9
ren hs1210 q10
ren hs1211 q11
ren hs1212 q12
ren hs1213 q13 
ren hs1214 q14
ren hs1215b q15 
ren pa1316 q16 
ren pa1317 q17

ren usc2118 q18a_la
ren usc2119 q19_q20a_la
ren usc2119a q19_q20a_other
ren usc2120a q18b_la
ren usc2120b q19_q20b_la
ren usc2120a1 q19_q20b_other
ren usc2121 q21
ren usc2121_oth q21_other
ren usc2122 q22
ren up22231 q23
recode q23 (. = 0) if up2223 == 1
recode q23 (. = .r) if up2223 == 3
ren up2224 q24
ren up2225a q25_a
ren up2225b1 q25_b
recode q25_b (. = .r) if up2225b == 99
ren up2226 q26
ren up22271 q27
ren up2228A q28_a
ren up22281 q28_b
recode q28_b (. = 0) if up2228 == 1
ren up2229 q29
ren sc2330 q30
ren sc2331 q31
ren sc2332 q32
ren sc2333 q33
ren sc2334 q34
ren sc2335 q35
ren sc2336 q36
ren sc2338 q38
ren sc2339 q39
ren sc2340 q40
ren sc2441 q41
ren sc2442 q42
ren sc2442_1 q42_other 

ren ue2443 q43_la
ren ue2444 q44_la 
ren OTH_factype3 q44_other 
ren ue2445 q45
ren ue24451 q45_other
ren ue24462 q46_min
ren ue24471 q47_min
ren ue2448 q48_a
ren ue2449 q48_b
ren ue2450 q48_c
ren ue2451 q48_d
ren ue2452 q48_e
ren ue2453 q48_f
ren ue2454 q48_g
ren ue2455 q48_h
ren ue2456 q48_i
ren ue2457 q48_j
ren ue3258 q49

ren hsa4159 q50_a
ren hsa4160 q50_b
ren hsa4161 q50_c
ren hsa4162 q50_d
ren ohsa4263 q51
ren ohsa4264 q52
ren ohsa4265 q53
ren ohsa4266 q54
ren ohsa4267 q55
ren ohsa4271 q59
ren ohsa4269 q57 
ren ohsa4270 q58

gen q60 = ohsa4372_f 
recode q60 (. = 1) if ohsa4372_m == 1
recode q60 (. = 2) if ohsa4372_m == 2
recode q60 (. = 3) if ohsa4372_m == 3
recode q60 (. = 4) if ohsa4372_m == 4
recode q60 (. = 5) if ohsa4372_m == 5
lab val q60 qlty_rate 

gen q61 = ohsa4373_f 
recode q61 (. = 1) if ohsa4373_m == 1
recode q61 (. = 2) if ohsa4373_m == 2
recode q61 (. = 3) if ohsa4373_m == 3
recode q61 (. = 4) if ohsa4373_m == 4
recode q61 (. = 5) if ohsa4373_m == 5
lab val q61 qlty_rate 

ren ig4474 q62
ren ig4474_oth q62_other
ren ig4475 q63
ren wgt weight_educ

* Q. Why is education and rural asked twice and in the data twice? Which is correct?
/*Amit: We asked education, urban/rural and language twice once at the beginning
and once at the very end. We wanted to measure if people were alert at the
end of the survey and we found that they were. We used the bd1104 (urban/rural),
bd1108 (education), bd1102 (ethnicity/language).<*/

* NOTE: Education, urban/rural, and native language were asked twice.
*		bd1104A is urban/rural, bd1108 is education, bd1102b is native language?
* NK Note: Come back to native language 

* Q. Q56 appears to be missing. Was that question asked? 
/*Amit: Yes, it was asked. Look up ue2456. */
* NK Note: Not in current data - different numbering 


*------------------------------------------------------------------------------*

* Interview length

* Q. Which variable is interview length? A lot of different time variables.
/*Amit: We measured interview lengths for each section. For the full interview,
you can measure difference between timestamp_start and timestamp_finalsec. You
will see outliers because we allowed people to save their files when
someone asked to call back later before completing the interview or when
the line was disconnected. In such cases, they were requested to continue to 
try to contact the individual until a total of 5 attempts were completed.*/

format timestamp_start %tcHH:MM:SS
gen start_min = (hh(timestamp_start)*3600 + mm(timestamp_start)*60 + ss(timestamp_start)) / 3600
gen end_min = (hh(timestamp_finalsec)*3600 + mm(timestamp_finalsec)*60 + ss(timestamp_finalsec)) / 3600
gen int_length = (end_min - start_min)*60
replace int_length = . if int_length < 0 | int_length > 90

* NK Note: Is there a better way to do this? 

*------------------------------------------------------------------------------*

* Drop unused variables 

* Q. Why one missing value for consent? Should that respondent be dropped?
/*Amit: Thanks for catching it. It looks like study ID 10089 was mislabeled 
as being completed when it was someone that was screened out. There are 
no responses filled in. We will correct this on our end as well. */

drop if consent == .

drop cal_int SubmissionDate today deviceid o_lang new_lang consent ///
hs1211a bd1102b bd1102btext bd1105A hs1211b usc2120c1 usc2120d1 usc2120e1 up2223 /// 
up2225b up2227 up2228 sc2340A sc2340A_oth ue2443a1 ue2443a3 ue2443b1 ue24431 ////
ue2448b1 ue2448b10 ue2448b11 ue2448b12 ue2448b2 ue2448b3 ue2448b4 ue2448b5 ///
ue2448b6 ue2448b7 ue2448b8 ue2448b9 ue2448b99 ue2448b_oth ue3258b ue3258b1 /// 
ue3258b10 ue3258b11 ue3258b12 ue3258b2 ue3258b3 ue3258b4 ue3258b5 ue3258b6 /// 
ue3258b7 ue3258b8 ue3258b9 ue3258b99  ue3258b_oth hsa4159A ohsa4263b ohsa4263b1 ///
ohsa4263b10 ohsa4263b11 ohsa4263b12 ohsa4263b2 ohsa4263b3 ohsa4263b4 ohsa4263b5 ///
ohsa4263b6 ohsa4263b7 ohsa4263b8 ohsa4263b9 ohsa4263b99 ohsa4263b_oth ig4476 ///
ig4477 ig4478 ig4479 ig4480 ig4481 ig4481A ig4481B rand_name ohsa4372_m ///
ohsa4373_m ohsa4373_f ohsa4372_f ig4482 ig4483 outcome1 outcome2 instanceID ///
instanceName rand_22util KEY FormVersion duplicated_id duplicated_id_2 start ///
end timestamp_start timestamp_consent timestamp_consent timestamp_Sec21 /// 
timestamp_Sec22 timestamp_Sec2324 timestamp_Sec3132 timestamp_Sec41 ///
timestamp_Sec4142 timestamp_Sec4344 timestamp_finalsec time_beforestart ///
time_consent time_Part1 time_Sec21 time_Sec22 time_Sec2324 time_Sec3132 ///
time_Sec41 time_Sec42 time_Sec4344 time_finalsec time_submission time_total ///
time_withrespondent time_unexplained visitsyr placesyr telmedyr outreachyr ///
age_cat malefemale region urbanrural edu_cat urbanrural_ed urbanrural_age ///
timestamp_Part1 start_min end_min

* NOTE to self: need to fix date variable in correct date/time format 

*------------------------------------------------------------------------------*

* Generate variables 

gen country = 11 
gen mode = 1
gen q6 = .a 
gen q56 = .a


* Q23/Q24 mid-point var 
gen q23_q24 = q23 
recode q23_q24 (.r = 2.5) if q24 == 1
recode q23_q24 (.r = 7) if q24 == 2
recode q23_q24 (.r = 10) if q24 == 3

*------------------------------------------------------------------------------*

* Refused values 

recode q7 q63 (99 = .r)

* Q. Refusal and Don't know values appear to be all missing throughout the data 
*	 Or occasionally 99 or 90 
*    Is there a standard value for refused and don't know in the raw data? Or is it a category?
* 	 I may consider starting from the raw data if so. 

/*Amit: Sorry, this is my bad. It was my first time coding in ODK and I 
thought I could only use 99 once so I used different values. But all the 
"don't know" or "refuse" values are between 99 to 83. You can disregard
all values greater than 82. */

*------------------------------------------------------------------------------*

* Recode missing values to NA for questions respondents would not have been asked 
* due to skip patterns

*q1/q2 
recode q1 (. = .r) if q2 == 2 | q2 == 3 | q2 == 4 | q2 == 5 | q2 == 6 | q2 == 7 | ///
					  q2 == 8
recode q2 (. = .a) if q1 != .r 

* q13 
recode q13 (. = .a) if q12 == 2  

* q15
recode q15 (. = .a) if q14 != 1
* NOTE: ONLY ASKED TO PEOPLE WHO SAID 0 DOSES 
* Q: Is that correct? Q15 was only asked to people who said 0 doses?
* 	 For other countries, we asked if people said 0 or 1 doses. 
/*Amit: Yes, only asked to people who said zero doses. You can also refer to the 
column labeled "relevant" in the excel form and it gives you the conditional, 
if any, for that specific question. The question is asked only when the 
condition is satisfied, else it is skipped. */

*q19-22
recode q19_q20a_la q18b_la q19_q20b_la q21 q22 (. = .a) if q18a_la == 2 
recode q18b_la q19_q20b_la (. = .a) if q19_q20a_la == 1 | q19_q20a_la == 2 | q19_q20a_la == 3 | ///
									 q19_q20a_la == 4 | q19_q20a_la == 6 | q19_q20a_la == 9
recode q21 q22 (. = .a) if q18b_la == 2

* Q. I thought those who responded pharmacy or traditional healer in q19_q20a were asked 
*	 about q18b?
*	If that is correct, I don't think this skip pattern worked for ~16 of the 76 
*   people who said pharmacy or traditional healer 
* 	There are ~16 poeple who say private pharmacy or traditional healer but were not asked q18b
* 	Or is that all refusal? 

/*Amit: People who answered pharmacy, traditional healer, or OTH to usc2119
were asked usc2120a. Those with empty usc2120a means that the person either
refused or did not answer the question.*/


* Q. It appears a lot to be missing for Q22? Did I miss something in the skip pattern? 
* Or just refusal? 

/*Amit: Only people that answered with a health facility (clinic, hospital or
health center) either in usc2119 or answered with affirmative on usc2120a were 
asked q22. It looks like 167 people refused, which is quite a lot.*/

* NA's for q23-27 
recode q24 (. = .a) if q23 != .
recode q25_a (. = .a) if q23 != 1
recode q25_b (. = .a) if q23 == 0 | q23 == 1 
* No 0 for q24  
recode q26 (. = .a) if q23 == 0 | q23 == 1 
recode q27 (. = .a) if q26 == 1 | q23 == 0 | q23 == 1 | q24 == 1 | q24 == .r 

* q31 & q32
recode q31 (. = .a) if q3 == 1 | q1 < 50 | q2 == 1 | q2 == 2 | q2 == 3 | q2 == 4 | q1 == .r | q2 == .r 
recode q32 (. = .a) if q3 == 1 | q1 == .r | q2 == .r

* q42
recode q42 (. = .a) if q41 == 2 

* q43-49 na's
recode q43_la q44_la q45 q46 q46_min q47 q47_min q48_a q48_b q48_c q48_d q48_e q48_f /// 
	   q48_g q48_h q48_i q48_j q49 (. = .a) if q23 == 0 

*Q43/Q44
recode q43_la (. = .a) if q44_la != 1


* NOTE: There appears to be a high amount of missing values (> 10%) for a few 
* questions. I know some missing may be due to refused or don't know. 
* Q. Why else might this be? 

/* Amit: I can imagine that there are a lot of reasons and may be 
specific question related. Some may have low response rates because they were 
difficult to understand for their particular situation. Our interviewers
also said that some hesitated if they had not used a particular health 
service or did not have personal experience or did not really
have an opinion about the topic. Some were skeptical about how the data 
would be used, which may have led to them refusing to answer 
specific questions that may put someone or authorities in a difficult 
situation.*/

* Q50a - Q50c refusal was common in other countries as well 

*------------------------------------------------------------------------------*

* Recode value labels:
* Recode values and value labels so that their values and direction make sense
* NOTE: Much of this code is borrowed from other data cleaning. That's why .a 
*		.r are there even if not in the data. 


* All Yes/No questions

recode q11 q12 q13 q18a_la q18b_la q25_a q26 q29 q41 ///
	   (1 = 1 Yes) (2 = 0 No) (.r = .r Refused) (.a = .a NA), ///
	   pre(rec) label(yes_no)

recode q30 q31 q32 q33 q34 q35 q36 q38 ///
	   (1 = 1 Yes) (2 = 0 No) (.r = .r Refused) (.d = .d "Don't know") /// 
	   (.a = .a NA), ///
	   pre(rec) label(yes_no_dk)

* NOTE: No don't know 

recode q39 q40 /// 
	   (1 = 1 Yes) (2 = 0 No) ///
	   (3 = .a "I did not get healthcare in past 12 months") ///
	   (.r = .r Refused), ///
	   pre(rec) label(yes_no_na)
	   
* NOTE: High missing for Q39 and Q40? 
* No "I did not get healthcare in past 12 months" in the data could be the reason
* But still, more than 10% missing  


/*Amit: This came up in our debriefing, too. Interviewers commented that
some were not sure if a medical error was made and did not feel right to say 
despite our urging the respondents to tell us what they felt.

Amit: Interestingly, there is no word for discrimination in Lao but we did 
ask if they felt unfairly treated.*/
	   
* All Excellent to Poor scales

recode q9 q10 q48_a q48_b q48_c q48_d q48_f q48_g q48_h q48_i q54 q55 q56 q59 q60 q61 ///
	   (1 = 4 Excellent) (2 = 3 "Very Good") (3 = 2 Good) (4 = 1 Fair) /// 
	   (5 = 0 Poor) (.r = .r Refused) (.a = .a NA), /// 
	   pre(rec) label(exc_poor)
	   
recode q22  ///
	   (1 = 4 Excellent) (2 = 3 "Very Good") (3 = 2 Good) (4 = 1 Fair) (5 = 0 Poor) /// 
	   (6 = .a "I did not receive healthcare form this provider in the past 12 months") /// 
	   (.r = .r Refused), /// 
	   pre(rec) label(exc_pr_hlthcare)
	   
recode q48_e ///
	   (1 = 4 Excellent) (2 = 3 "Very Good") (3 = 2 Good) (4 = 1 Fair) /// 
	   (5 = 0 Poor) (6 = .a "I have not had prior visits or tests") (.r = .r Refused), /// 
	   pre(rec) label(exc_pr_visits)
	 
recode q48_j ///
	   (1 = 4 Excellent) (2 = 3 "Very Good") (3 = 2 Good) (4 = 1 Fair) /// 
	   (5 = 0 Poor) (6 = .a "The clinic had no other staff") (.r = .r Refused), /// 
	   pre(rec) label(exc_poor_staff)
	   
recode q50_a q50_b q50_c q50_d ///
	   (1 = 4 Excellent) (2 = 3 "Very Good") (3 = 2 Good) (4 = 1 Fair) /// 
	   (5 = 0 Poor) (6 = .d "I am unable to judge") (.r = .r Refused) ///
	   (.a = .a NA), /// 
	   pre(rec) label(exc_poor_judge)

* All Very Confident to Not at all Confident scales 
	   
recode q16 q17 q51 q52 q53 ///
	   (1 = 3 "Very confident") (2 = 2 "Somewhat confident") /// 
	   (3 = 1 "Not too confident") (4 = 0 "Not at all confident") /// 
	   (.r = .r Refused) (.a = .a NA), /// 
	   pre(rec) label(vc_nc)
	   
* Miscellaneous questions with unique answer options

*recode interviewer_gender ///
*	(1 = 0 Male) (2 = 1 Female), ///
*	pre(rec) label(int_gender)

recode q2 (2 = 0 "18 to 29") (3 = 1 "30-39") (4 = 2 "40-49") (5 = 3 "50-59") ///
		  (6 = 4 "60-69") (7 = 5 "70-79") (8 = 6 "80+") (.r = .r "Refused") ///
		  (.a = .a "NA"), pre(rec) label(age_cat)

recode q3 ///
	(1 = 0 Male) (2 = 1 Female) (3 = 2 "Another gender") (.r = .r Refused), ///
	pre(rec) label(gender)

* NOTE: This vaccine question is slightly different - looks like asked up to 5 and more
* Other countries asked 3 and more 

recode q14 ///
	(1 = 0 "0- no doses received") (2 = 1 "1 dose") (3 = 2 "2 doses") ///
	(4 = 3 "3 doses") (5 = 4 "More than 3 doses") (.r = .r Refused) , ///
	pre(rec) label(covid_vacc)
	
* NOTE: This was potentially only asked to people with 0 doses - other countries asked for 0 or 1 
recode q15 /// 
	   (1 = 1 "Yes, I plan to receive all required doses") ///
	   (2 = 0 "No, don't plan to receive all required doses") ///
	   (.r = .r Refused) (.a = .a NA), ///
	   pre(rec) label(yes_no_doses)
	   
recode q24 ///
	(0 = 0 "0") (1 = 1 "1-4") (2 = 2 "5-9") (3 = 3 "10 or more") ///
	(.r = .r Refused) (.a = .a NA), ///
	pre(rec) label(number_visits)
	
recode q45 ///
	(1 = 1 "Care for an urgent or acute health problem (accident or injury, fever, diarrhea, or a new pain or symptom)" ) ///
	(2 = 2 "Follow-up care for a longstanding illness or chronic disease (hypertension or diabetes; mental health conditions") ///
	(3 = 3 "Preventive care or a visit to check on your health (for example, antenatal care, vaccination, or eye checks)") ///
	(.a = .a "NA") (4 = 995 "Other, specify") (.r = .r "Refused"), ///
	pre(rec) label(main_reason)
	
recode q49 ///
	(0 = 0 "0") (1 = 1 "1") (2 = 2 "2") (3 = 3 "3") (4 = 4 "4") (5 = 5 "5") ///
	(6 = 6 "6") (7 = 7 "7") (8 = 8 "8") (9 = 9 "9") (10 = 10 "10") ///
	(.r = .r Refused) (.a = .a NA), ///
	pre(rec) label(prom_score)

recode q57 ///
	(3 = 0 "Getting worse") (2 = 1 "Staying the same") (1 = 2 "Getting better") ///
	(.r = .r "Refused") , pre(rec) label(system_outlook)

* COUNTRY-SPECIFIC items for append
* NOTE: We have only received data from Ipsos so far, so the value labels are programmed
* to include all of countries being fielded by Ipsos 
* For Laos, for now, I'll recode the values to start after Ipsos countries and then 
* re-label the values on append (see append code at end)
* Not sure if there is a better way to do this? but this seems to work for now 

* Interviewer ID - Other country data is anonomized interview ID from 1 through 57
* Added Laos above 100 because India and SA interviewers to be added 
gen interviewer_id = interviewerid + 100

* Language - available after 5 
recode language (1 = 6 Lao) (2 = 7 Khmou) (3 = 8 Kmong), pre(rec) label(language)

* Q4 values available - after 17
recode q4 (1 = 18 "City") (2 = 19 "Rural area") (3 = 20 "Suburb"), pre(rec) label(residence)

* Q5 values available after 187
gen recq5 = q5 + 200


* Q7 values available - after 28, other is 995 
recode q7 (1 = 30 "Additional private insurance") (2 = 29 "Only Public") (99 = .r "Refused"), pre(rec) label(insur)

* NOTE to self: confirm it is okay to merge this question with current q7 
* Adjusted response options to make sense with current q7 
* but could create additional q7_la variable 

* Q8 values after 44 are available 
gen recq8 = q8 + 44

* Q21
recode q21 (10 = 9) (90 = .r)
label define fac_choose 9 "Other", modify

* Q42 values appears to be the same as other countries 
	
* Q62 values after 89 are available
gen recq62 = q62 + 100 

* Q63 values after 61 are available 
gen recq63 = q63 + 100 

* High amount of missing: Q22, Q39, Q40, q50_c, q50_d



*------------------------------------------------------------------------------*

* Renaming variables 
* Rename variables to match question numbers in current survey 

***Drop all the ones that were recoded, then drop the recode, and rename then according to the documents
drop q2 q3 q4 q5 q7 q8 q11 q12 q13 q18a_la q18b_la q25_a q26 q29 q41 q45 q30 q31 /// 
	 q32 q33 q34 q35 q36 q38 q39 q40 q9 q10 q22 q48_a q48_b q48_c q48_d ///
	 q48_f q48_g q48_h q48_i q54 q55 q56 q59 q60 q61 q48_e q48_j q50_a q50_b ///
	 q50_c q50_d q16 q17 q51 q52 q53 q3 q14 q15 q24 q49 q57 language q62 q63 ///
	 interviewerid

ren rec* *

*------------------------------------------------------------------------------*

* Check for implausible values
* q23 q25_b q27 q28_a q28_b q46_min q47_min


 foreach var in q23 q25_b q27 q28_a q28_b q46_min q47_min {
		extremes `var', high 
	 }
	

* All count values in Laos look plausible, time values seem plausible too 

* Check for other implausible values 

list q23 q24 q23_q24 q25_b country if q25_b > q23_q24 & q25_b < . 
* Two potentially implausible values, where visits for COVID is higher than visits 
* Was your total number of visits (q23/q24) inclusive of covid or additional?

list q23_q24 q27 country if q27 > q23_q24 & q27 < . 
* One potentially implausible value, where number of facilities is higher than number of visits
* Potentially make q27 8

list q26 q27 country if q27 == 0 | q27 == 1
* This is okay 

list q23_q24 q39 q40 country if q39 == 3 & q23_q24 > 0 & q23_q24 < . /// 
							  | q40 == 3 & q23_q24 > 0 & q23_q24 < .
* This is okay


*------------------------------------------------------------------------------*

* Label variables 

* lab var int_length "Interview length (in minutes)"
* lab var interviewer_gender "Interviewer gender"
lab var q1 "Q1. Respondent еxact age"
lab var q2 "Q2. Respondent's age group"
lab var q3 "Q3. Respondent gender"
lab var q4 "Q4. Type of area where respondent lives"
lab var q5 "Q5. County, state, region where respondent lives"
lab var q6 "Q6. Do you have health insurance?"
lab var q7 "Q7. What type of health insurance do you have?"
* lab var q7_other "Q7_other. Other type of health insurance"
lab var q8 "Q8. Highest level of education completed by the respondent"
lab var q9 "Q9. In general, would you say your health is:"
lab var q10 "Q10. In general, would you say your mental health is?"
lab var q11 "Q11. Do you have any longstanding illness or health problem?"
lab var q12 "Q12. Have you ever had COVID-19 or coronavirus?"
lab var q13 "Q13. Was it confirmed by a test?"
lab var q14 "Q14. How many doses of a COVID-19 vaccine have you received?"
lab var q15 "Q15. Do you plan to receive all recommended doses if they are available to you?"
lab var q16 "Q16. How confident are you that you are responsible for managing your health?"
lab var q17 "Q17. Can tell a healthcare provider your concerns even when not asked?"
lab var q18a_la "Q18a. LA only: Is there one healthcare facility or provider's group you usually...?"
lab var q19_q20a_la "Q19a. LA only: What type of place is this?"
lab var q19_q20a_other "Q19a. LA only: Other"
lab var q18b_la "Q18b. LA only: Is there one healthcare facility or provider's group you usually...?"
lab var q19_q20b_la "Q19b. LA only: What type of place is this?"
lab var q19_q20b_other "Q19b. LA only: Other"
lab var q21 "Q21. Why did you choose this healthcare facility?"
lab var q21_other "Q21. Other"
lab var q22 "Q22. Overall respondent's rating of the quality received in this facility"
lab var q23 "Q23. How many healthcare visits in total have you made in the past 12 months?"
lab var q23_q24 "Q23/Q24. Total mumber of visits made in past 12 months (q23, q24 mid-point)"
lab var q24 "Q24. Total number of healthcare visits in the past 12 months (range)"
lab var q25_a "Q25_A. Was this visit for COVID-19?"
lab var q25_b "Q25_B. How many of these visits were for COVID-19? "
lab var q26 "Q26. Were all of the visits you made to the same healthcare facility?"
lab var q27 "Q27. How many different healthcare facilities did you go to?"
lab var q28_a "Q28_A. How many visits did you have with a healthcare provider at your home?"
lab var q28_b "Q28_B. How many virtual or telemedicine visits did you have?"
lab var q29 "Q29. Did you stay overnight at a healthcare facility as a patient?"
lab var q30 "Q30. Blood pressure tested in the past 12 months"
lab var q31 "Q31. Received a mammogram in the past 12 months"
lab var q32 "Q32. Received cervical cancer screening, like a pap test or visual inspection"
lab var q33 "Q33. Had your eyes or vision checked in the past 12 months"
lab var q34 "Q34. Had your teeth checked in the past 12 months"
lab var q35 "Q35. Had a blood sugar test in the past 12 months"
lab var q36 "Q36. Had a blood cholesterol test in the past 12 months"
lab var q38 "Q38. Received care for depression, anxiety, or another mental health condition"
lab var q39 "Q39. A medical mistake was made in your treatment or care in the past 12 months"
lab var q40 "Q40. You were treated unfairly or discriminated against in the past 12 months"
lab var q41 "Q41. Have you needed medical attention but you did not get it in past 12 months?"
lab var q42 "Q42. The last time this happened, what was the main reason?"
lab var q42_other "Q42. Other"
lab var q43_la "Q43. LA only: Last healthcare visit in a public, private, or NGO/faith-based facility?"
*lab var q43_other "Q43. Other"
lab var q44_la "Q44. LA only: What type of healthcare facility is this?"
lab var q44_other "Q44. Other"
lab var q45 "Q45. What was the main reason you went?"
lab var q45_other "Q45. Other"
*lab var q46_refused "Q46. Refused"
*lab var q46 "Q46. Approximately how long did you wait before seeing the provider?"
lab var q46_min "Q46. In minutes: Approximately how long did you wait before seeing the provider?"
*lab var q47_refused "Q47. Refused"
*lab var q47 "Q47. Approximately how much time did the provider spend with you?"
lab var q47_min "Q47. In minutes: Approximately how much time did the provider spend with you?"
lab var q48_a "Q48_A. How would you rate the overall quality of care you received?"
lab var q48_b "Q48_B. How would you rate the knowledge and skills of your provider?"
lab var q48_c "Q48_C. How would you rate the equipment and supplies that the provider had?"
lab var q48_d "Q48_D. How would you rate the level of respect your provider showed you?"
lab var q48_e "Q48_E. How would you rate your provider knowledge about your prior visits?"
lab var q48_f "Q48_F. How would you rate whether your provider explained things clearly?"
lab var q48_g "Q48_G. How would you rate whether you were involved in your care decisions?"
lab var q48_h "Q48_H. How would you rate the amount of time your provider spent with you?"
lab var q48_i "Q48_I. How would you rate the amount of time you waited before being seen?"
lab var q48_j "Q48_J. How would you rate the courtesy and helpfulness at the facility?"
lab var q49 "Q49. How likely would recommend this facility to a friend or family member?"
lab var q50_a "Q50_A. How would you rate the quality of care provided for care for pregnancy?"
lab var q50_b "Q50_B. How would you rate the quality of care provided for children?"
lab var q50_c "Q50_C. How would you rate the quality of care provided for chronic conditions?"
lab var q50_d "Q50_D. How would you rate the quality of care provided for the mental health?"
lab var q51 "Q51. How confident are you that you'd get good healthcare if you were very sick?"
lab var q52 "Q52. How confident are you that you'd be able to afford the care you requiered?"
lab var q53 "Q53. How confident are you that the government considers the public's opinion?"
lab var q54 "Q54. How would you rate the quality of public healthcare system in your country?"
lab var q55 "Q55. How would you rate the quality of private for-profit healthcare?"
lab var q56 "Q56. How would you rate the quality of the NGO or faith-based healthcare?"
lab var q57 "Q57. Is your country's health system is getting better, same or worse?"
lab var q58 "Q58. Which of these statements do you agree with the most?"
lab var q59 "Q59. How would you rate the government's management of the COVID-19 pandemic?"
lab var q60 "Q60. How would you rate the quality of care provided? (Vignette, option 1)"
lab var q61 "Q61. How would you rate the quality of care provided? (Vignette, option 2)"
lab var q62 "Q62. Respondent's mother tongue or native language"
lab var q62_other "Q62. Other"
lab var q63 "Q63. Total monthly household income"
*lab var q64 "Q64. Do you have another mobile phone number besides this one?"
*lab var q65 "Q65. How many other mobile phone numbers do you have?"

order respondent_serial language interviewer_id weight q1 q2 q3 q4 q5 q6 q7 q8 q9 q10 q11 q12 q13 q14 q15 q16 q17 q18a_la q19_q20a_la q19_q20a_other q18b_la q19_q20b_la q19_q20b_other q21 q21_other q22 q23 q24 q25_a q25_b q26 q27 q28_a q28_b q29 q30 q31 q32 q33 q34 q35 q36 q38 q39 q40 q41 q42 q42_other q43_la q44_la q44_other q45 q45_other q46_min q47_min q48_a q48_b q48_c q48_d q48_e q48_f q48_g q48_h q48_i q48_j q49 q50_a q50_b q50_c q50_d q51 q52 q53 q54 q55 q56 q57 q58 q59 q60 q61 q62 q62_other q63 


save "$data_mc/02 recoded data/pvs_la.dta", replace

/*
* NOTE to Emma/Amit: 
* Here is my code for appending all the datasets if you want to see how I added 
* the value labels for Laos

*------------------------------------------------------------------------------*

********************************* Append data *********************************

u "$data_mc/02 recoded data/pvs_lac.dta", clear
append using "$data_mc/02 recoded data/pvs_ke.dta"
append using "$data_mc/02 recoded data/pvs_et.dta"
append using "$data_mc/02 recoded data/pvs_la.dta"

* NOTE: Fix Kenya date on append 

* Kenya/Ethiopia variables 
ren q19 q19_ke_et 
lab var q19_ke_et "Q19. Kenya/Ethiopia: Is this a public, private, or NGO/faith-based facility?"
ren q43 q43_ke_et 
lab var q43_ke_et "Q43. Kenya/Ethiopia: Is this a public, private, or NGO/faith-based facility?"
ren q56 q56_ke_et 
lab var q56_ke_et "Q56. Kenya/Ethiopia: How would you rate quality of NGO/faith-based healthcare?"

* Mode
lab val mode mode
lab var mode "Mode of interview"

* Country-specific skip patterns
recode q6 q19_ke_et q43_ke_et q56_ke_et (. = .a) if country != 5 | country != 3  
recode q3a q13b q13e (. = .a) if country == 5 | country == 3 | country == 11 
recode q19_uy q43_uy q56_uy (. = .a) if country != 10
recode q19_pe q43_pe q56_pe (. = .a) if country != 7
recode q19_co q43_co (. = .a) if country != 2
recode q18a_la q1920a_la q18b_la q1920b_la q43_la q44_la ///		
		(. = .a) if country != 11
		
* Country-specific value labels 

recode language (. = 0) if country == 10 | country == 7 | country == 2
lab def Language 0 "Spanish" 6 "Lao" 7 "Khmou" 8 "Kmong", modify

*Q4
label define labels6 18 "City" 19 "Rural area"  20 "Suburb", modify

*Q5
label define labels7 201 "Attapeu" 202 "Bokeo" 203 "Bolikhamxai" 204 "Champasak" 205 "Houaphan" 206 "Khammouan" 207 "Louangnamtha" 208 "Louangphabang" 209 "Oudoumxai" 210 "Phongsali" 211 "Salavan" 212 "Savannakhet" 213 "Vientiane_capital" 214 "Vientiane_province" 215 "Xainyabouli" 216 "Xaisoumboun" 217 "Xekong" 218 "Xiangkhouang", modify

*Q7
label define labels9 29 "Public" 30 "Private", modify

*Q8
label define labels10 45 "None" 46 "Primary (primary 1-5 years)" /// 
					  47 "Lower secondary (1-4 years)" /// 
					  48 "Upper secondary (5-7 years)" ///
					  49 "Post-secondary and non-tertiary (13-15 years)" ///
					  50 "Tertiary (Associates or higher)", modify

*Q62
label define labels51 101 "Lao" 102 "Hmong" 103 "Kmou" 104 "Other", modify

*Q63
label define labels52 101 "Range A (Less than 1,000,000) Kip" 102 "Range B (1,000,000 to 1,500,000) Kip" 103 "Range C (1,500,001 to 2,000,000) Kip" 104 "Range D (2,000,001 to 2,500,000) Kip" 105 "Range E (2,500,001 to 3,000,000) Kip" 106 "Range F (3,000,001 to 3,500,000) Kip" 107 "Range G (More than 3,500,000) Kip", replace

order q*, sequential
order respondent_serial respondent_id unique_id psu_id interviewerid_recoded /// 
interviewer_language interviewer_gender mode country language date time /// 
intlength int_length q1_codes

drop intlength unique_id q46 q47 
ren interviewerid_recoded interviewerid

save "$data_mc/02 recoded data/pvs_appended.dta", replace

