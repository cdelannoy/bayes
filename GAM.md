GAM
========================================================
author: Constance
date: 2018-06-21
autosize: true

Why GAM?
========================================================

- Principle of linear regression: linearity of outcome vs predictor
- Sometimes, that is not the case, so need to transform a predictor
- Ex:

![plot of chunk linear kink ex](GAM-figure/linear kink ex-1.png)


Slide With Code
========================================================


```r
summary(cars)
```

```
     speed           dist       
 Min.   : 4.0   Min.   :  2.00  
 1st Qu.:12.0   1st Qu.: 26.00  
 Median :15.0   Median : 36.00  
 Mean   :15.4   Mean   : 42.98  
 3rd Qu.:19.0   3rd Qu.: 56.00  
 Max.   :25.0   Max.   :120.00  
```

Slide With Plot
========================================================

![plot of chunk unnamed-chunk-2](GAM-figure/unnamed-chunk-2-1.png)
