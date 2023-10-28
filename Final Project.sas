/* Generated Code (IMPORT) */
/* Source File: Debernardi et al 2020 data.csv */
/* Source Path: /home/u63559379/STAT660 */
/* Code generated on: 10/2/23, 10:54 AM */

%web_drop_table(WORK.IMPORT);

FILENAME REFFILE '/home/u63559379/STAT660/Debernardi et al 2020 data.csv';

PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=WORK.IMPORT;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=WORK.IMPORT; RUN;
%web_open_table(WORK.IMPORT);

data pancreas;
set work.import;
run;

proc freq data=pancreas; 
table Diagnosis; 
run;

title "Diagnosis Based on Gender";
proc sgplot data=pancreas;
vbar sex/ group=diagnosis stat=percent missing;
run;

title "Diagnosis Based on Age";
proc sgplot data=pancreas;
   vbox age / category=diagnosis;
run;

proc sgplot data=pancreas;
   vbox age / category=diagnosis group=sex;
run;


data pancreas_bin;
set pancreas;
if diagnosis in (1,2) then cancer = 0;
else cancer = 1;
age_10 = floor(age / 10) * 10;
run;

data pancreas_bin_chart;
set pancreas;
length cancer $3;
if diagnosis in (1,2) then cancer = "No";
else cancer = "Yes";
age_10 = floor(age / 10) * 10;
run;

proc sgplot data=pancreas_bin_chart;
   vbox age / category=cancer group=sex;
   title 'Pancreatic Cancer Based on Age and Gender';
run;

proc sgplot data=pancreas_bin_chart;
   vbox creatinine / category=cancer group=sex;
   title 'Pancreatic Cancer Based on Creatinine';
run;

proc sgplot data=pancreas_bin_chart;
   vbox lyve1 / category=cancer group=sex;
   title 'Pancreatic Cancer Based on LYVE1';
run;

proc sgplot data=pancreas_bin_chart;
   vbox reg1b / category=cancer group=sex;
   title 'Pancreatic Cancer Based on REG1B';
run;

proc sgplot data=pancreas_bin_chart;
   vbox tff1 / category=cancer group=sex;
   title 'Pancreatic Cancer Based on TFF1';
run;

/* Creating Logistic regression model */
proc genmod descending data=pancreas_bin;
class sex;
model Cancer = age_10 sex creatinine lyve1 reg1b tff1/ dist=bin link=logit;
output out=out p=pred upper=ucl lower=lcl;
*run*;

*locate odds ratio;
proc logistic descending data=pancreas_bin;
class sex;
model Cancer = age_10 sex creatinine lyve1 reg1b tff1/ lackfit influence outroc=classif1;
run;

data pancreas_cancer;
set pancreas_bin;
length cr_levels $6;
if creatinine < 0.2 then cr_levels = "Low";
else if creatinine > 2.75 and sex = "F" then cr_levels = "High";
else if creatinine > 3.20 and sex = "M" then cr_levels = "High";
else cr_levels = "Normal";
run;


/*Creatinine Levels*/
proc sgplot data=pancreas_cancer;
vbar cr_levels;
title "Creatinine Levels";
run;


