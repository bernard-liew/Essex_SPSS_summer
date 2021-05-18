* Encoding: UTF-8.
cd "C:\Users\liew_\Box\myBox\Documents\teaching\Statistics\SPSS\wrangling\Essex_SPSS_summer\data".

GET DATA
  /TYPE=XLSX
  /FILE= 'practice.xlsx'
  /CELLRANGE=FULL
  /READNAMES=ON
  /DATATYPEMIN PERCENTAGE=95.0
  /HIDDEN IGNORE=YES.

FILTER OFF.
USE ALL.
SELECT IF (task = "cmjbw").
EXECUTE.


RENAME VARIABLES (subj group  = id grp ).


DATASET DECLARE aggregate_data.
AGGREGATE
  /OUTFILE='aggregate_data'
  /BREAK=id grp time
  /aexttorq_mean=MEAN(aexttorq).
