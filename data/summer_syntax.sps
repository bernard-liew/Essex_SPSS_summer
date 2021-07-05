* Encoding: UTF-8.
cd 'C:\Box\myBox\Documents\teaching\Statistics\SPSS\wrangling\Essex_SPSS_summer\data'.

GET DATA
  /TYPE=XLSX
  /FILE= 'df.xlsx'
  /SHEET=name 'jump'
  /CELLRANGE=FULL
  /READNAMES=ON
  /DATATYPEMIN PERCENTAGE=95.0
  /HIDDEN IGNORE=YES.

RENAME VARIABLES (subj group wt  = id grp weight).

FILTER OFF.
USE ALL.
SELECT IF (task = "cmjbw" &  side = "R").
EXECUTE.


COMPUTE height = ht/100. 
COMPUTE weight = weight/100.
COMPUTE BMI = weight/(height**2).
EXECUTE.

SORT CASES  BY grp time.
SPLIT FILE SEPARATE BY grp time.

DATASET DECLARE aggregate_data.
AGGREGATE
  /OUTFILE='aggregate_data'
  /BREAK=id grp time 
  /aexttorq_mean=MEAN(aexttorq) 
  /aextwork_min=MIN(aextwork) 
  /aextpow_max=MAX(aextpow) 
  /aexttorq_sd=SD(aexttorq) 
  /aextwork_median=MEDIAN(aextwork).


CASESTOVARS
  /ID=id grp
  /INDEX=time
  /GROUPBY=VARIABLE.


VARSTOCASES
  /MAKE val FROM aexttorq_pre aexttorq_post 
  /INDEX=mediator(val) 
  /KEEP=id grp time
  /NULL=KEEP.


VARSTOCASES
  /MAKE aexttorq_mean FROM aexttorq_mean.POST aexttorq_mean.PRE
  /MAKE aextwork_min FROM aextwork_min.POST aextwork_min.PRE
  /MAKE aextpow_max FROM aextpow_max.POST aextpow_max.PRE
  /MAKE aexttorq_sd FROM aexttorq_sd.POST aexttorq_sd.PRE
  /MAKE aextwork_median FROM aextwork_median.POST aextwork_median.PRE
  /INDEX=time"POST, PRE"(trans1) 
  /KEEP=id grp
  /NULL=KEEP.

VARSTOCASES
  /MAKE trans1 FROM aexttorq_mean.PRE aexttorq_mean.PRE
  /MAKE trans2 FROM aextwork_min.POST aextwork_min.PRE
  /MAKE trans3 FROM aextpow_max.POST aextpow_max.PRE
  /MAKE trans4 FROM aexttorq_sd.POST aexttorq_sd.PRE
  /MAKE trans5 FROM aextwork_median.POST aextwork_median.PRE
  /INDEX=time "POST, PRE"(trans1) 
  /KEEP=id grp
  /NULL=KEEP.
