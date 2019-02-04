title 'Import movie data';
proc import datafile='S:\Homeworks\movies_project_data.xls' out = movies dbms = xls replace;
getnames = yes;
run;
proc print;

title 'Add dummy variables';
data movies;
set movies; 

numStatus1 = (Status = 'Released');
numStatus2 = (Status = 'Rumored');

*Production company other is the base ;
numProd1 = (Production_Companies = 'Universal Studios');
numProd2 = (Production_Companies = 'New Line Cinema');
numProd3 = (Production_Companies = 'Walt Disney Pictures');
numProd4 = (Production_Companies = 'Warner Bros.');
numProd5 = (Production_Companies = 'Metro-Goldwyn-Mayer (MGM)');
numProd6 = (Production_Companies = 'United Artists');
numProd7 = (Production_Companies = 'Columbia Pictures Corporation');
numProd8 = (Production_Companies = 'Miramax Films');
numProd9 = (Production_Companies = 'Paramount Pictures');
numProd10 = (Production_Companies = 'Twentieth Century Fox Film Corporation');
numProd11 = (Production_Companies = 'Columbia Pictures');

*Genre Action is the base genre;
numGenre1 = (Genre = 'Adventure');
numGenre2 = (Genre = 'Animation');
numGenre3 = (Genre = 'Comedy');
numGenre4 = (Genre = 'Crime');
numGenre5 = (Genre = 'Documentary');
numGenre6 = (Genre = 'Drama');
numGenre7 = (Genre = 'Family');
numGenre8 = (Genre = 'Fantasy');
numGenre9 = (Genre = 'Foreign');
numGenre10 = (Genre = 'History');
numGenre11 = (Genre = 'Horror');
numGenre12 = (Genre = 'Music');
numGenre13 = (Genre = 'Other');
numGenre14 = (Genre = 'Romance');
numGenre15 = (Genre = 'Science Fiction');
numGenre16 = (Genre = 'Thriller');
numGenre17 = (Genre = 'TV Movie');
numGenre18 = (Genre = 'War');
numGenre19 = (Genre = 'Western');

*Base year is 1900-1950;
numYear1 = (Release_Year = '1951-2000');
numYear2 = (Release_Year = '2001-2010');
numYear3 = (Release_Year = '2011-2018');

original_lang_vote_average = original_lang*vote_Average;

proc print;
run;


title "Scatterplot Matrix";
proc sgscatter data=movies;
matrix budget popularity original_lang production_Countries revenue runtime vote_Average vote_count;
run;

title "Histogram for (popularity)";
proc univariate;
var popularity;
histogram/normal;
run;

title "Regression first model fit";
proc reg data=movies;
model popularity = collection budget original_lang production_Countries revenue runtime vote_Average vote_count numStatus1 numStatus2 numProd1 numProd2 numProd3 numProd4 numProd5 numProd6 numProd7 numProd8 numProd9 numProd10 numProd11 numGenre1 numGenre2 numGenre3 numGenre4 numGenre5 numGenre6 numGenre7 numGenre8 numGenre9 numGenre10 numGenre11 numGenre12 numGenre13 numGenre14 numGenre15 numGenre16 numGenre17 numGenre18 numGenre19 numYear1 numYear2 numYear3;
plot student.*predicted.;
plot npp.*student.;
plot student.*(popularity collection budget original_lang production_Countries revenue runtime vote_Average vote_count);
run; 

title "Regression model with interaction variable”;
proc reg data=movies;
model popularity = collection budget original_lang production_Countries revenue runtime vote_Average vote_count numStatus1 numStatus2 numProd1 numProd2 numProd3 numProd4 numProd5 numProd6 numProd7 numProd8 numProd9 numProd10 numProd11 numGenre1 numGenre2 numGenre3 numGenre4 numGenre5 numGenre6 numGenre7 numGenre8 numGenre9 numGenre10 numGenre11 numGenre12 numGenre13 numGenre14 numGenre15 numGenre16 numGenre17 numGenre18 numGenre19 numYear1 numYear2 numYear3 budget_vote_average;
plot student.*predicted.;
plot npp.*student.;
run; 


title 'Correlation';
proc corr data = movies;
var popularity collection budget original_lang production_Countries revenue runtime vote_Average vote_count;
run;

title 'Log transformation';
data movies;
set movies;
Lnpopularity = log(popularity);
proc print;

title "Histogram for ln(popularity)";
proc univariate;
var popularity;
histogram/normal;
run;

title 'Sqrt Transformation';
data movies;
set movies;
sqrtpopularity = sqrt(popularity);
proc print;

title "Histogram for sqrt(popularity)";
proc univariate;
var sqrtpopularity;
histogram/normal;
run;


title 'Regression with log';
proc reg data = movies;
model lnpopularity= collection budget original_lang production_Countries revenue runtime vote_Average vote_count numStatus1 numStatus2 numProd1 numProd2 numProd3 numProd4 numProd5 numProd6 numProd7 numProd8 numProd9 numProd10 numProd11 numGenre1 numGenre2 numGenre3 numGenre4 numGenre5 numGenre6 numGenre7 numGenre8 numGenre9 numGenre10 numGenre11 numGenre12 numGenre13 numGenre14 numGenre15 numGenre16 numGenre17 numGenre18 numGenre19 numYear1 numYear2 numYear3;
*plot student.*predicted.;
*plot npp.*student.;
run;

title 'Regression with sqrt';
proc reg data = movies;
model sqrtpopularity= budget original_lang production_Countries revenue runtime vote_Average vote_count Collection numStatus1 numStatus2 numProd1 numProd2 numProd3 numProd4 numProd5 numProd6 numProd7 numProd8 numProd9 numProd10 numProd11 numGenre1 numGenre2 numGenre3 numGenre4 numGenre5 numGenre6 numGenre7 numGenre8 numGenre9 numGenre10 numGenre11 numGenre12 numGenre13 numGenre14 numGenre15 numGenre16 numGenre17 numGenre18 numGenre19 numYear1 numYear2 numYear3; 	
plot student.*predicted.;
plot npp.*student.;
plot student.*(popularity collection budget original_lang production_Countries revenue runtime vote_Average vote_count);
run;

title 'Regression2 w/ sqrt using stepwise model selection and check for collinearity';
proc reg data = movies;
model sqrtpopularity= budget original_lang production_Countries revenue runtime vote_Average vote_count Collection numStatus1 numStatus2 numProd1 numProd2 numProd3 numProd4 numProd5 numProd6 numProd7 numProd8 numProd9 numProd10 numProd11 numGenre1 numGenre2 numGenre3 numGenre4 numGenre5 numGenre6 numGenre7 numGenre8 numGenre9 numGenre10 numGenre11 numGenre12 numGenre13 numGenre14 numGenre15 numGenre16 numGenre17 numGenre18 numGenre19 numYear1 numYear2 numYear3/selection = stepwise;
run;

title 'Regression3 w/ sqrt using backward model selection';
proc reg data = movies;
model sqrtpopularity= budget original_lang production_Countries revenue runtime vote_Average vote_count Collection numStatus1 numStatus2 numProd1 numProd2 numProd3 numProd4 numProd5 numProd6 numProd7 numProd8 numProd9 numProd10 numProd11 numGenre1 numGenre2 numGenre3 numGenre4 numGenre5 numGenre6 numGenre7 numGenre8 numGenre9 numGenre10 numGenre11 numGenre12 numGenre13 numGenre14 numGenre15 numGenre16 numGenre17 numGenre18 numGenre19 numYear1 numYear2 numYear3/selection = backward;
run;

title 'Regression4 w/ sqrt using backward model variables ';
proc reg data = movies;
model sqrtpopularity= budget original_lang production_Countries runtime vote_Average vote_count Collection numProd2 numProd3 numProd4 numProd5 numGenre1 numGenre2 numGenre3  numGenre5 numGenre6 numGenre7 numGenre9 numGenre10 numGenre12 numGenre13 numGenre14 numGenre15 numGenre18 numYear1 numYear2 numYear3/vif;
run;
title 'Regression5 w/ sqrt removing insignificant variables ';
proc reg data = movies;
model sqrtpopularity= budget original_lang production_Countries runtime vote_Average vote_count Collection numProd2 numProd4 numProd5 numGenre2 numGenre3  numGenre5 numGenre6 numGenre9 numGenre10 numGenre12 numGenre13 numGenre14 numGenre18 numYear1 numYear2 numYear3/r influence stb;
run;






title 'Compute prediction for movie 1';
data new1;
input budget original_lang production_Countries runtime vote_count vote_average collection numProd3 numYear1 numGenre1 revenue numStatus1 numStatus2 numProd1 numProd2 numProd4 numProd5 numProd6 numProd7 numProd8 numProd9 numProd10 numProd11 numGenre2 numGenre3 numGenre4 numGenre5 numGenre6 numGenre7 numGenre8 numGenre9 numGenre10 numGenre11 numGenre12 numGenre13 numGenre14 numGenre15 numGenre16 numGenre17 numGenre18 numGenre19 numYear2 numYear3;
;
datalines;
500000 1 0 120 100 7.5 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
;
proc print;
run;

data pred;
set new1 movies;
run;
proc print;
run;


**use cli for prediction intervals, and clm for intervals for averages CL mean is the CI;
title 'Prediction 1';
proc reg data=pred;
model sqrtpopularity= budget original_lang production_Countries runtime vote_Average vote_count Collection numProd2 numProd4 numProd5 numGenre2 numGenre3  numGenre5 numGenre6 numGenre9 numGenre10 numGenre12 numGenre13 numGenre14 numGenre18 numYear1 numYear2 numYear3/p CLI CLM;
run;

*prediction 2;
title 'Compute prediction for movie 1';
data new1;
input budget original_lang production_Countries runtime vote_count vote_average collection numProd2 numYear1 numGenre3 revenue numStatus1 numStatus2 numProd1 numProd3 numProd4 numProd5 numProd6 numProd7 numProd8 numProd9 numProd10 numProd11 numGenre2 numGenre1 numGenre4 numGenre5 numGenre6 numGenre7 numGenre8 numGenre9 numGenre10 numGenre11 numGenre12 numGenre13 numGenre14 numGenre15 numGenre16 numGenre17 numGenre18 numGenre19 numYear2 numYear3;
;
datalines;
800000 1 1 75 200 8.5 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
;
proc print;
run;

data pred;
set new1 movies;
run;

**use cli for prediction intervals, and clm for intervals for averages CL mean is the CI;
title 'Prediction 2';
proc reg data=pred;
model sqrtpopularity= budget original_lang production_Countries runtime vote_Average vote_count Collection numProd2 numProd4 numProd5 numGenre2 numGenre3  numGenre5 numGenre6 numGenre9 numGenre10 numGenre12 numGenre13 numGenre14 numGenre18 numYear1 numYear2 numYear3/p CLI CLM;
run;

*Generate the test samples: training set used to fit the model;
proc surveyselect data=movies out=train_all seed=56789 samprate=0.70 outall;
run;
*proc print data=train_all;
*run;

*create new variable train_y = sqrtpopularity for training set, and = NA for testing set;
data train_all;
set train_all;
if selected then train_y=sqrtpopularity;
run;
proc print data=train_all;
run;


/* Fit models on training data*/
* MODEL 1;
title 'Model 1';
Proc reg data=train_all;
model train_y= budget original_lang production_Countries runtime vote_Average vote_count Collection numProd2 numProd4 numProd5 numGenre2 numGenre3  numGenre5 numGenre6 numGenre9 numGenre10 numGenre12 numGenre13 numGenre14 numGenre18 numYear1 numYear2 numYear3;
output out=outm1(where=(train_y=.)) p=yhat;
run; 

* MODEL 2 – excludes year variables;
title 'Model 2';
Proc reg data=train_all;
model train_y= budget original_lang production_Countries runtime vote_Average vote_count Collection numProd2 numProd4 numProd5 numGenre2 numGenre3  numGenre5 numGenre6 numGenre9 numGenre10 numGenre12 numGenre13 numGenre14 numGenre1;
output out=outm2(where=(train_y=.)) p=yhat;
run;

* Analysis of predictions on testing set for model M1;
title 'Analysis for M1';
data outm1_test;
set outm1;
d= sqrtpopularity -yhat; *d is the difference between observed and predicted values in training set;
absd=abs(d);
pe=abs(d/ sqrtpopularity);
run;

/* Computes predictive statistics: root mean square error (rmse), 
mean absolute error (mae) and mean absolute percentage error (MAPE) for model M1*/
proc summary data=outm1_test;
var d absd;
output out=outm1_stats std(d)=rmse mean(absd)=mae mean(pe)=mape;
run;
title 'Validation  statistics for Model 1';
proc print data=outm1_stats;
run;

*computes correlation of observed and predicted values in test set for model M1;
proc corr data=outm1;
var sqrtpopularity yhat;
run;


/*  Analysis of predictions on testing set for model M2*/
data outm2_test;
set outm2;
d= sqrtpopularity -yhat; 
absd=abs(d);
pe=abs(d/ sqrtpopularity);
run;
/* computes predictive statistics: root mean square error (rmse) 
and mean absolute error (mae) and saves the output in new outm2_stats dataset*/
proc summary data=outm2_test;
var d absd;
output out=outm2_stats std(d)=rmse mean(absd)=mae mean(pe)=mape;
run;
title 'Validation  statistics for Model 2';
proc print data=outm2_stats;
run;
*computes correlation of observed and predicted values in test set;
proc corr data=outm2;
var sqrtpopularity yhat;
run;

