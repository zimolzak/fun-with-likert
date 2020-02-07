Fun with Likert
========

Make some fake unpaired Likert data, plot it, and analyze it with some
tests. This pretends that you have two groups (A and B), with 60
people in each group, and your survey has 6 questions, each scored on
a 0 to 4 Likert scale.

Results
========

Below is a table of *p* values, comparing group A to group B, for each
of the 6 questions. The following statistical tests (columns in the
table) are tried:

1. Wilcoxon rank sum, a.k.a. Mann-Whitney
2. T-test (unpaired)
3. Chi-squared test for trend in proportions (Cochran–Armitage test for trend)
4. Pearson's chi-squared test ("plain old" chi-squared that doesn't
know ordinal from categorical)

Some authors say that the t-test might be more appropriate than it
seems. See [Norman] and [Sullivan].

[Norman]: https://www.ncbi.nlm.nih.gov/pubmed/20146096 "Norman G. Adv
Health Sci Educ Theory Pract. 2010 Dec;15(5):625-32."

[Sullivan]: https://www.ncbi.nlm.nih.gov/pubmed/24454995 "Sullivan &
Artino. J Grad Med Educ. 2013 Dec; 5(4): 541–542."



```
  question wilcoxon_p    ttest_p     catt_p      chi_p
         1 0.00008602 0.00001416 0.00002332 0.00001884
         2 0.00000000 0.00000000 0.00000000 0.00000003
         3 0.00000000 0.00000000 0.00000001 0.00000028
         4 0.00090077 0.00037737 0.00045219 0.00241743
         5 0.00327405 0.00119031 0.00131765 0.01453107
         6 0.61915745 0.66912503 0.66595722 0.95185781
         7 0.07541019 0.09881224 0.09722275 0.10866653
```

Plot of fake survey data (one question per row):

![plot of likert data](facet_grid.png "Plot of Likert data")

