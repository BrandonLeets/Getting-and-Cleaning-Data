#CookBook
=========

Variable list and descriptions
------------------------------

Variable        | Description
----------------|------------
subject         | ID the subject who performed the activity for each window sample. It ranges from 1 to 30.
activity        | Actvivty name
featDomain      | Feature: Time domain signal or frequency domain signal (Time or Freq)
featInstrument  | Feature: Measuring instrument (Accelorometer or Gyroscope)
featAcceleration| Feature: Acceleration signal (Body or Gravity)
featVariable    | Feature: Variable (Mean or STDEV)
featJerk		| Feature: Jerk signal
featMagnitude   | Feature: Magnitude of the signals calculated using the Euclidean norm
featAxis		| Feature: 3-axial signals in the X, Y and Z directions
featCount		| Feature: Count of data points used to compute 'average'
featAverage		| Feature: Average of each variable foe each activity and each subject

Dataset structure
-----------------
```{r}
str(dtTidy)
```
```{r}
Classes ‘data.table’ and 'data.frame':	1980 obs. of  10 variables:
 $ subject         : int  1 1 1 1 1 1 1 1 1 1 ...
 $ featDomain      : Factor w/ 2 levels "Time","Feq": 1 1 1 1 1 1 1 1 1 1 ...
 $ featAcceleration: Factor w/ 3 levels NA,"Body","Gravity": 1 1 1 1 1 1 1 1 1 1 ...
 $ featInstrument  : Factor w/ 2 levels "Accelerometer",..: 2 2 2 2 2 2 2 2 2 2 ...
 $ featJerk        : Factor w/ 2 levels NA,"Jerk": 1 1 1 1 1 1 1 1 2 2 ...
 $ featMagnitude   : Factor w/ 2 levels NA,"Magnitude": 1 1 1 1 1 1 2 2 1 1 ...
 $ featVariable    : Factor w/ 2 levels "Mean","STDEV": 1 1 1 2 2 2 1 2 1 1 ...
 $ featAxis        : Factor w/ 4 levels NA,"X","Y","Z": 2 3 4 2 3 4 1 1 2 3 ...
 $ count           : int  347 347 347 347 347 347 347 347 347 347 ...
 $ average         : num  -0.0209 -0.0881 0.0863 -0.6866 -0.451 ...
 - attr(*, "sorted")= chr  "subject" "featDomain" "featAcceleration" "featInstrument" ...
 - attr(*, ".internal.selfref")=<externalptr> 
```


List the key vartiables in the data table
-----------------------------------------
```{r}
key(dtTidy)
```
```{r}
[1] "subject"          "featDomain"       "featAcceleration" "featInstrument"   "featJerk"        
[6] "featMagnitude"    "featVariable"     "featAxis" 
```

Show a few rows of the dataset
------------------------------
```{r}
head(dtTidy)
tail(dtTidy)
```
```{r}
   subject activity featDomain featAcceleration featInstrument featJerk featMagnitude featVariable featAxis count
1:       1   LAYING       Time               NA      Gyroscope       NA            NA         Mean        X    50
2:       1   LAYING       Time               NA      Gyroscope       NA            NA         Mean        Y    50
3:       1   LAYING       Time               NA      Gyroscope       NA            NA         Mean        Z    50
4:       1   LAYING       Time               NA      Gyroscope       NA            NA        STDEV        X    50
5:       1   LAYING       Time               NA      Gyroscope       NA            NA        STDEV        Y    50
6:       1   LAYING       Time               NA      Gyroscope       NA            NA        STDEV        Z    50
       average
1: -0.01655309
2: -0.06448612
3:  0.14868944
4: -0.87354387
5: -0.95109044
6: -0.90828466
```
```{r}
   subject         activity featDomain featAcceleration featInstrument featJerk featMagnitude featVariable featAxis
1:      30 WALKING_UPSTAIRS        Feq             Body  Accelerometer     Jerk            NA         Mean        Z
2:      30 WALKING_UPSTAIRS        Feq             Body  Accelerometer     Jerk            NA        STDEV        X
3:      30 WALKING_UPSTAIRS        Feq             Body  Accelerometer     Jerk            NA        STDEV        Y
4:      30 WALKING_UPSTAIRS        Feq             Body  Accelerometer     Jerk            NA        STDEV        Z
5:      30 WALKING_UPSTAIRS        Feq             Body  Accelerometer     Jerk     Magnitude         Mean       NA
6:      30 WALKING_UPSTAIRS        Feq             Body  Accelerometer     Jerk     Magnitude        STDEV       NA
   count    average
1:    65 -0.7378039
2:    65 -0.5615652
3:    65 -0.6108266
4:    65 -0.7847539
5:    65 -0.5497849
6:    65 -0.5808781
```

Summary of variables
--------------------
```{r}
summary(dtTidy)
```
```{r}
 subject                   activity    featDomain  featAcceleration       featInstrument featJerk   
 Min.   : 1.0   LAYING            :1980   Time:7200   NA     :4680     Accelerometer:7200   NA  :7200  
 1st Qu.: 8.0   SITTING           :1980   Feq :4680   Body   :5760     Gyroscope    :4680   Jerk:4680  
 Median :15.5   STANDING          :1980               Gravity:1440                                     
 Mean   :15.5   WALKING           :1980                                                                
 3rd Qu.:23.0   WALKING_DOWNSTAIRS:1980                                                                
 Max.   :30.0   WALKING_UPSTAIRS  :1980                                                                
   featMagnitude  featVariable featAxis      count          average        
 NA       :8640   Mean :5940   NA:3240   Min.   :36.00   Min.   :-0.99767  
 Magnitude:3240   STDEV:5940   X :2880   1st Qu.:49.00   1st Qu.:-0.96205  
                               Y :2880   Median :54.50   Median :-0.46989  
                               Z :2880   Mean   :57.22   Mean   :-0.48436  
                                         3rd Qu.:63.25   3rd Qu.:-0.07836  
                                         Max.   :95.00   Max.   : 0.97451 
```

List all possible combinations of features
------------------------------------------
```{r}
dtTidy[,.N, by = c(names(dtTidy)[grep("^feat", names(dtTidy))])]
```
```{r}
featDomain featAcceleration featInstrument featJerk featMagnitude featVariable featAxis   N
 1:       Time               NA      Gyroscope       NA            NA         Mean        X 180
 2:       Time               NA      Gyroscope       NA            NA         Mean        Y 180
 3:       Time               NA      Gyroscope       NA            NA         Mean        Z 180
 4:       Time               NA      Gyroscope       NA            NA        STDEV        X 180
 5:       Time               NA      Gyroscope       NA            NA        STDEV        Y 180
 6:       Time               NA      Gyroscope       NA            NA        STDEV        Z 180
 7:       Time               NA      Gyroscope       NA     Magnitude         Mean       NA 180
 8:       Time               NA      Gyroscope       NA     Magnitude        STDEV       NA 180
 9:       Time               NA      Gyroscope     Jerk            NA         Mean        X 180
10:       Time               NA      Gyroscope     Jerk            NA         Mean        Y 180
11:       Time               NA      Gyroscope     Jerk            NA         Mean        Z 180
12:       Time               NA      Gyroscope     Jerk            NA        STDEV        X 180
13:       Time               NA      Gyroscope     Jerk            NA        STDEV        Y 180
14:       Time               NA      Gyroscope     Jerk            NA        STDEV        Z 180
15:       Time               NA      Gyroscope     Jerk     Magnitude         Mean       NA 180
16:       Time               NA      Gyroscope     Jerk     Magnitude        STDEV       NA 180
17:       Time             Body  Accelerometer       NA            NA         Mean        X 180
18:       Time             Body  Accelerometer       NA            NA         Mean        Y 180
19:       Time             Body  Accelerometer       NA            NA         Mean        Z 180
20:       Time             Body  Accelerometer       NA            NA        STDEV        X 180
21:       Time             Body  Accelerometer       NA            NA        STDEV        Y 180
22:       Time             Body  Accelerometer       NA            NA        STDEV        Z 180
23:       Time             Body  Accelerometer       NA     Magnitude         Mean       NA 180
24:       Time             Body  Accelerometer       NA     Magnitude        STDEV       NA 180
25:       Time             Body  Accelerometer     Jerk            NA         Mean        X 180
26:       Time             Body  Accelerometer     Jerk            NA         Mean        Y 180
27:       Time             Body  Accelerometer     Jerk            NA         Mean        Z 180
28:       Time             Body  Accelerometer     Jerk            NA        STDEV        X 180
29:       Time             Body  Accelerometer     Jerk            NA        STDEV        Y 180
30:       Time             Body  Accelerometer     Jerk            NA        STDEV        Z 180
31:       Time             Body  Accelerometer     Jerk     Magnitude         Mean       NA 180
32:       Time             Body  Accelerometer     Jerk     Magnitude        STDEV       NA 180
33:       Time          Gravity  Accelerometer       NA            NA         Mean        X 180
34:       Time          Gravity  Accelerometer       NA            NA         Mean        Y 180
35:       Time          Gravity  Accelerometer       NA            NA         Mean        Z 180
36:       Time          Gravity  Accelerometer       NA            NA        STDEV        X 180
37:       Time          Gravity  Accelerometer       NA            NA        STDEV        Y 180
38:       Time          Gravity  Accelerometer       NA            NA        STDEV        Z 180
39:       Time          Gravity  Accelerometer       NA     Magnitude         Mean       NA 180
40:       Time          Gravity  Accelerometer       NA     Magnitude        STDEV       NA 180
41:        Feq               NA      Gyroscope       NA            NA         Mean        X 180
42:        Feq               NA      Gyroscope       NA            NA         Mean        Y 180
43:        Feq               NA      Gyroscope       NA            NA         Mean        Z 180
44:        Feq               NA      Gyroscope       NA            NA        STDEV        X 180
45:        Feq               NA      Gyroscope       NA            NA        STDEV        Y 180
46:        Feq               NA      Gyroscope       NA            NA        STDEV        Z 180
47:        Feq               NA      Gyroscope       NA     Magnitude         Mean       NA 180
48:        Feq               NA      Gyroscope       NA     Magnitude        STDEV       NA 180
49:        Feq               NA      Gyroscope     Jerk     Magnitude         Mean       NA 180
50:        Feq               NA      Gyroscope     Jerk     Magnitude        STDEV       NA 180
51:        Feq             Body  Accelerometer       NA            NA         Mean        X 180
52:        Feq             Body  Accelerometer       NA            NA         Mean        Y 180
53:        Feq             Body  Accelerometer       NA            NA         Mean        Z 180
54:        Feq             Body  Accelerometer       NA            NA        STDEV        X 180
55:        Feq             Body  Accelerometer       NA            NA        STDEV        Y 180
56:        Feq             Body  Accelerometer       NA            NA        STDEV        Z 180
57:        Feq             Body  Accelerometer       NA     Magnitude         Mean       NA 180
58:        Feq             Body  Accelerometer       NA     Magnitude        STDEV       NA 180
59:        Feq             Body  Accelerometer     Jerk            NA         Mean        X 180
60:        Feq             Body  Accelerometer     Jerk            NA         Mean        Y 180
61:        Feq             Body  Accelerometer     Jerk            NA         Mean        Z 180
62:        Feq             Body  Accelerometer     Jerk            NA        STDEV        X 180
63:        Feq             Body  Accelerometer     Jerk            NA        STDEV        Y 180
64:        Feq             Body  Accelerometer     Jerk            NA        STDEV        Z 180
65:        Feq             Body  Accelerometer     Jerk     Magnitude         Mean       NA 180
66:        Feq             Body  Accelerometer     Jerk     Magnitude        STDEV       NA 180

Save to file with write.table()
-------------------------------
```{r}
pathSave <- file.path(path, "DatasetHumanActivityRecoginitionUsingSmartphones.txt")
write.table(dtTidy, pathSave, quote = FALSE, sep"\t", row.names = FALSE)
```
