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

DATASET DECLARE aggregate_data.
AGGREGATE
  /OUTFILE='aggregate_data'
  /BREAK=id grp time 
  /aexttorq_mean=MEAN(aexttorq) 
  /aextwork_min=MIN(aextwork) 
  /aextpow_max=MAX(aextpow) 
  /aexttorq_sd=SD(aexttorq) 
  /aextwork_median=MEDIAN(aextwork).

SORT CASES  BY grp side.
SPLIT FILE SEPARATE BY grp side.

VARSTOCASES
  /MAKE val FROM aexttorq_pre aexttorq_post 
  /INDEX=mediator(val) 
  /KEEP=id grp time
  /NULL=KEEP.

CASESTOVARS
  /ID=id grp time
  /INDEX=mediator
  /GROUPBY=VARIABLE.
