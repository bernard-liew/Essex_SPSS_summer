---
output:
  html_document: default
  pdf_document: default
---

# Trick 1 - Paste to syntax {#trick1}

**If you can develop one habit, it is this!!!** The good thing about interacting with SPSS using syntax, is that you do not have to be a total convert. You can continue using the "point and click" interface, but instead of executing the command, press **paste** as you see in Figure \@ref(fig:paste-syntax). Pasting automatically copies the word version of what you clicked into your opened syntax.

<div class="figure">
<img src="images/paste_syntax.png" alt="Paste the syntax you generated implicitly by clicking" width="60%" />
<p class="caption">(\#fig:paste-syntax)Paste the syntax you generated implicitly by clicking</p>
</div>

I have not ever encountered an SPSS function that does not eventually have a paste function. Try finding it and saving what you intend to do like in Figure \@ref(fig:paste-syntax2).

<div class="figure">
<img src="images/paste_syntax2.png" alt="Always try to paste your syntax rather than executing" width="50%" />
<p class="caption">(\#fig:paste-syntax2)Always try to paste your syntax rather than executing</p>
</div>

To run each command, highlight and press the play button like in Figure \@ref(fig:play).

<div class="figure">
<img src="images/run_syntax.png" alt="Executing a command" width="80%" />
<p class="caption">(\#fig:play)Executing a command</p>
</div>

# Trick 2 - Setting your work directory {#trick2}

When importing data from deeply nested folders, it can be a pain to do so. In addition, when exporting files or figures, many often scratch their head as to where the files went to. The solution to this is to **explicitly** define the folder on your computer where every thing starts and ends. All the files will be exported to that folder. And importing becomes a breeze.

You can set the working directory by pasting the command below into your SPSS syntax, and change the folder path to your path. Just make sure to enclose it in `" "`.


```r
cd 'C:\Box\myBox\Documents\teaching\Statistics\SPSS\wrangling\Essex_SPSS_summer\data'.
```

# Trick 3 - Importing data {#trick3}

The most common starting point for data analysis is Excel, so I will demonstrate how to easily import an Excel file. Paste the command below into your syntax, and simply change the file name `df.xlsx` to whatever your file is named. Remember not to change the file extension `.xlsx`. Notice I did not to do this `"'C:\Box\myBox\Documents\teaching\Statistics\SPSS\wrangling\Essex_SPSS_summer\data\df.xlsx'"`. It was because I already defined the path the file was in trick \@ref(trick2). If your Excel file has multiple sheets, change the sheet name `jump` to whatever it is named. If you only have one sheet, you can leave it blank.


```r
GET DATA
  /TYPE=XLSX
  /FILE= 'df.xlsx'
  /SHEET=name 'jump'
  /CELLRANGE=FULL
  /READNAMES=ON
  /DATATYPEMIN PERCENTAGE=95.0
  /HIDDEN IGNORE=YES.
```

Using the sample data I provide, this is what the data looks like in Figure \@ref(fig:original).

<div class="figure">
<img src="images/original_data.png" alt="Original data" width="100%" />
<p class="caption">(\#fig:original)Original data</p>
</div>

# Trick 4 - Rename columns {#trick4}

Rename columns is a common task. Paste the command below into your syntax and run it. Put all the original column names before the `=` and all the new names after. There must be a spacing between each name, and the order preceding and proceding the `=` must be identical.


```r
RENAME VARIABLES (subj group wt  = id grp weight).
```

After renaming this is what the data looks like in Figure \@ref(fig:rename-col).

<div class="figure">
<img src="images/rename.png" alt="New column names" width="100%" />
<p class="caption">(\#fig:rename-col)New column names</p>
</div>

# Trick 5 - Filter rows {#trick5}

You might want to keep rows in your data based on some conditions. I tend to prefer to keep whatever rows I want and discard the remaining. Discarding your data does not harm your original data in Excel. If you change your mind, just highlight all the commands from the start and press the play button. In the example below, I want to keep rows where the variable `task` is equal `"cmjbw"` AND `side` is equal to "`R`". Below are some of the operators you can mix and match to powerfully filter our your data.

| Symbols |   Meaning |
|:--------|----------:|
| `=`     |Equal | 
| `~=`    |Not equal | 
| `<`     |Less than | 
| `<=`     |Less than or equal| 
| `>`      |More than | 
| `>=`     |More than or equal | 
| `&`     |AND | 
| `|`     |OR | 



Highlight this command and press the play button.


```r
FILTER OFF.
USE ALL.
SELECT IF (task = "cmjbw" &  side = "R").
EXECUTE.
```

After filtering this is what the data looks like in Figure \@ref(fig:filter-row).

<div class="figure">
<img src="images/filter.png" alt="Keeping rows based on some conditions" width="100%" />
<p class="caption">(\#fig:filter-row)Keeping rows based on some conditions</p>
</div>

# Trick 6 - Create new variables {#trick6}

You might want to create new variables, such as calculating BMI from height and mass. Add as many `COMPUTE` function below as needed. The command reads as `COMPUTE height = ht/100.`, make a new variable called `height` by dividing the original variable`ht` by 100. You can either create a new variable or replace the existing variable by using a new name or the original name, respectively.

**Math functions**

`+` Add

`-` Subtract

`/` Divide

`*` Multiply

`**` Power

Highlight this command and press the play button.


```r
COMPUTE height = ht/100. 
COMPUTE weight = weight/100.
COMPUTE BMI = weight/(height**2).
EXECUTE.
```

After computing new variables this is what the data looks like in Figure \@ref(fig:mutate).

<div class="figure">
<img src="images/mutate.png" alt="New variables created" width="100%" />
<p class="caption">(\#fig:mutate)New variables created</p>
</div>

# Trick 7 - Aggregate data {#trick7}

You may want to find some summary statistics for each level of a grouping variable. In the example below, I want to calculate for each id, in each group, at each time, find the mean (`MEAN`), minimum (`MIN`), maximum (`MAX`), standard deviation (`SD`), and median (`MEDIAN`) of the following variables (`aexttorq`, `aextwork`, `aextpow`). When you see this argument, `/aexttorq_mean=MEAN(aexttorq)`, the value before `=` represents the new variable name. However many aggregate values you desire, add as many arguments on a separate line. In this command, the aggregate data is pasted onto a separate data window called `aggregate_data` - you can give the new data window any name.


```r
DATASET DECLARE aggregate_data.
AGGREGATE
  /OUTFILE='aggregate_data'
  /BREAK=id grp time 
  /aexttorq_mean=MEAN(aexttorq) 
  /aextwork_min=MIN(aextwork) 
  /aextpow_max=MAX(aextpow) 
  /aexttorq_sd=SD(aexttorq) 
  /aextwork_median=MEDIAN(aextwork).
```

After aggregating this is what the data looks like in Figure \@ref(fig:aggregate).

<div class="figure">
<img src="images/aggregate.png" alt="Aggregated summary" width="100%" />
<p class="caption">(\#fig:aggregate)Aggregated summary</p>
</div>

# Trick 8 - Group by function {#trick8}

Many times you want to do the same thing repeatedly on certain chunks of data. For example, you want to find the mean strength on each level of sex (male, female), or even each level of the combination of sex-side (male-right, male-left, female-right, female-left). Precede whatever function you want to execute, with the command below. In the command below, I want to do the same analysis for each level of the combination of `grp` and `side`. This works for categorical variables. Replace `grp` and `side` with however many variables you want to split the data by.

*PS* This means you can run the same stats on each split of the data by running the stats only once if you use this command.

Highlight this command and press the play button.


```r
SORT CASES  BY grp side.
SPLIT FILE SEPARATE BY grp side.
```

After grouping the data, when I ran a descriptive analysis, this is what the results looks like in Figure \@ref(fig:group-by).

<div class="figure">
<img src="images/group-by.png" alt="Group-by descriptives" width="60%" />
<p class="caption">(\#fig:group-by)Group-by descriptives</p>
</div>

# Trick 9 - Wide to long {#trick9}

<div class="figure">
<img src="images/wide_data.png" alt="Wide data" width="100%" />
<p class="caption">(\#fig:ugly)Wide data</p>
</div>

Typically data is keyed into Excel in the wide format like in Figure \@ref(fig:ugly). In \> 90% of any data analysis, data should **NOT** be in this format. The only thing I know in SPSS that requires data to be in the wide format is when you want to use Repeated Measures Anova or a Paired t test. So it is useful to know how to convert a data to a long format since \> 90% of SPSS function requires data to be in a long format.

`/MAKE val FROM aexttorq_pre aexttorq_post` says collect all the variables `aexttorq_pre`, `aexttorq_post` and stack their values on top of each other. The column containing the values is called `val`. The column where the names of the values are stored is called `mediator`. Remember, you can call the new columns anything you want. `/KEEP=id grp time` simple says keep the following columns in the new data.

Highlight this command and press the play button.


```r
VARSTOCASES
  /MAKE val FROM aexttorq_pre aexttorq_post 
  /INDEX=mediator(val) 
  /KEEP=id grp time
  /NULL=KEEP.
```

After running the command, this is what the results looks like in Figure \@ref(fig:tidy).

<div class="figure">
<img src="images/long_data.png" alt="Long data" width="100%" />
<p class="caption">(\#fig:tidy)Long data</p>
</div>

# Trick 10 - Long to wide {#trick10}

Just in case you need to make the data wide again. The two key commands are `/ID=id grp time` and `/INDEX=mediator`. `/ID` represents how each data point will be uniquely identified. `/INDEX` represents the variable you want to spread by.

Notice that trick \@ref(trick10) and \@ref(trick9) are mirror images. the `/ID` command in trick 10 should be identical to the `/KEEP` in trick \@ref(trick9). The `/INDEX` in both tricks \@ref(trick10) and \@ref(trick9) should contain the variable name you want to spread by.


```r
CASESTOVARS
  /ID=id grp time
  /INDEX=mediator
  /GROUPBY=VARIABLE.
```

After running the command, the data looks like in Figure \@ref(fig:ugly) again.

# Conclusion

Notice how I did not even touch of saving any outputs. The reason for that is that one should first save all the commands ran rather than the results. Saving the process allows you to replicate your actions, saving your results will not.
