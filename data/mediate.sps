* Encoding: UTF-8.
* Set working directory.
cd 'C:\Box\myBox\Documents\teaching\SE738\spss'.

* Import. 
GET DATA
  /TYPE=XLSX
  /FILE=    'df.xlsx'
  /SHEET=name 'jump'
  /CELLRANGE=FULL
  /READNAMES=ON
  /DATATYPEMIN PERCENTAGE=95.0
  /HIDDEN IGNORE=YES.

* Name dataset.
DATASET NAME data1 WINDOW=FRONT.


* Define Variable Properties.
*aextwork.
FORMATS  aextwork(F5.4).
*aextpow.
FORMATS  aextpow(F5.4).
*kexttorq.
FORMATS  kexttorq(F5.4).
*kextwork.
FORMATS  kextwork(F5.4).
*kextpow.
FORMATS  kextpow(F5.4).
*height.
FORMATS  height(F5.4).
EXECUTE.

* Scale all mediators by mass & jump height by ht.
VECTOR VectorVar = aexttorq TO kextpow.
LOOP #cnt = 1 to 6 by 1.
    COMPUTE VectorVar(#cnt) = VectorVar(#cnt)/wt.
END LOOP.
EXECUTE.

COMPUTE height = height/ (ht/100).
EXECUTE.

DATASET DECLARE data2.
AGGREGATE
  /OUTFILE='data2'
  /BREAK=subj group time task
  /wt_mean=MEAN(wt) 
  /ht_mean=MEAN(ht) 
  /aexttorq_mean=MEAN(aexttorq) 
  /aextwork_mean=MEAN(aextwork) 
  /aextpow_mean=MEAN(aextpow) 
  /kexttorq_mean=MEAN(kexttorq) 
  /kextwork_mean=MEAN(kextwork) 
  /kextpow_mean=MEAN(kextpow)
  /height_mean=MEAN(height).

DATASET CLOSE data1.
DATASET ACTIVATE data2.
* Define Variable Properties.
*group.
RECODE group time ('G'='0') ('T'='1') ('PRE'='0') ('POST'='1').
EXECUTE.

* Define Variable Properties.
*group.
ALTER TYPE  group(F1.0).
*time.
ALTER TYPE  time(F4.0).
*group.
VARIABLE LEVEL  group(ORDINAL).
FORMATS  group(F1.0).
VALUE LABELS group
  null 'G'
  null 'T'.
*time.
VARIABLE LEVEL  time(ORDINAL).
FORMATS  time(F4.0).
VALUE LABELS time
  null 'pre'
  null 'post'.
EXECUTE.



*Filter data.
DATASET COPY  data3.
DATASET ACTIVATE  data3.
FILTER OFF.
USE ALL.
SELECT IF (task = "cmjbw").
EXECUTE.

DATASET CLOSE data2.
*Gather all mediators and outcomes.
VARSTOCASES
  /MAKE val FROM aexttorq_mean aextwork_mean aextpow_mean kexttorq_mean kextwork_mean kextpow_mean 
    height_mean
  /INDEX=mediator(val) 
  /KEEP=subj group time
  /NULL=KEEP.


* Spread data.
SORT CASES BY subj group mediator time.
CASESTOVARS
  /ID=subj group mediator
  /INDEX=time
  /GROUPBY=VARIABLE.


* Get difference.
COMPUTE d = val.1 - val.0.
EXECUTE.


* Spread data.
SORT CASES BY subj group.
CASESTOVARS
  /ID=subj 
  /INDEX=mediator
  /GROUPBY=VARIABLE
  /DROP = val.0 val.1 .

RENAME VARIABLES (height_mean aextpow_mean aexttorq_mean aextwork_mean kextpow_mean kexttorq_mean kextwork_mean = jht apow ator awor kpow ktor kwor ).

DATASET ACTIVATE data3.

* Define Variable Properties.
*apow.
FORMATS  apow(F8.4).
*ator.
FORMATS  ator(F8.4).
*awor.
FORMATS  awor(F8.4).
*jht.
FORMATS  jht(F8.4).
*kpow.
FORMATS  kpow(F8.4).
*ktor.
FORMATS  ktor(F8.4).
*kwor.
FORMATS  kwor(F8.4).
EXECUTE.


*Do regressions, change the dependent and independent variables to what do need.
*Check for normality of residuals.

REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS CI(95) R ANOVA CHANGE
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT jht
  /METHOD=ENTER group
  /SCATTERPLOT=(*ZRESID ,*ZPRED)
  /RESIDUALS HISTOGRAM(ZRESID) NORMPROB(ZRESID).


  REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS CI(95) R ANOVA CHANGE
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT jht
  /METHOD=ENTER group ator
  /SCATTERPLOT=(*ZRESID ,*ZPRED)
  /RESIDUALS HISTOGRAM(ZRESID) NORMPROB(ZRESID).


*Mediation analysis, remember to run PROCESS35 syntax first.
process y=  jht
/x=group
/m=apow 
/total=1
/boot=5000 
/conf=95
/effsize=1 
/contrast=1
/model=4 
/plot=1
/save=1
/seed=31216.


process y=  jht
/x=group
/m=ktor 
/total=1
/boot=5000 
/conf=95
/effsize=1 
/contrast=1
/model=4 
/plot=1
/save=1
/seed=31216.


SAVE TRANSLATE OUTFILE='clean_dat.xlsx'
  /TYPE=XLS
  /VERSION=12
  /MAP
  /FIELDNAMES VALUE=NAMES
  /CELLS=VALUES
  /REPLACE.


DATASET ACTIVATE data3.
* Define Variable Properties.
*apow.
FORMATS  apow(F8.4).
*ator.
FORMATS  ator(F8.4).
*awor.
FORMATS  awor(F8.4).
*jht.
FORMATS  jht(F8.4).
*kpow.
FORMATS  kpow(F8.4).
*ktor.
FORMATS  ktor(F8.4).
*kwor.
FORMATS  kwor(F8.4).
EXECUTE.
