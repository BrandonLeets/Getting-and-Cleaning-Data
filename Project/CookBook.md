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

Show a few rows of the dataset
------------------------------
```{r}
head(dtTidy)
```

Summary of variables
--------------------
```{r}
summary(dtTidy)
````

List all possible combinations of features
------------------------------------------
```{r}
dtTidy[,.N, by = c(names(dtTidy)[grep("^feat", names(dtTidy))])]
```

Save to file with write.table()
-------------------------------
```{r}
pathSave <- file.path(path, "DatasetHumanActivityRecoginitionUsingSmartphones.txt")
write.table(dtTidy, pathSave, quote = FALSE, sep"\t", row.names = FALSE)
```
