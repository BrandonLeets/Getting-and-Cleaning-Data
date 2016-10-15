#run_analysis
-------------

##Instructions for Project
--------------------------
The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.

One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Here are the data for the project:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

You should create one R script called run_analysis.R that does the following.

1. Merges the training and the test sets to create one data set. Completed
2. Extracts only the measurements on the mean and standard deviation for each measurement. Completed
3. Uses descriptive activity names to name the activities in the data set Completed
4. Appropriately labels the data set with descriptive variable names. Completed
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject. Completed

Good luck!

##Library
---------
Load these specific Libraries

```{r}
library(data.table)
library(knitr)
```
Set the path for downloading the files

```{r}
path <- getwd()
```

##Get the data
--------------
Download the file usind 'download.file' and save it to the 'Data' folder

```{r}
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
fileName <- "Dataset.zip"
if(!file.exists(path)){dir.create(path)}
download.file(url, file.path(path, fileName))
```

Unzip the file

```{r}
unzip(file.path(path, fileName))
```

The unzipping put all the data into a file called 'UCI HAR Dataset'. Change the input path to reflect this and list the file names.

```{r}
pathIn <- file.path(path, "UCI HAR Dataset")
list.files(pathIn, recursive = TRUE)
```
The files in the 'Inertial signals' will not be used for this project.

##Read the Files
----------------
Read in the subject and sctivity files using fread

```{r}
dtsubtrain <- fread(file.path(pathIn, "train","subject_train.txt"))
dtsubtest <- fread(file.path(pathIn, "test","subject_test.txt"))
dtacttrain <- fread(file.path(pathIn, "train", "Y_train.txt"))
dtacttest <- fread(file.path(pathIn, "test", "Y_test.txt"))
```

Use the 'read.table' to create a data table. Helpful function for this is the 'fileToMakeTable'

```{r}
fileToMakeTable <- function(path){
    df <- read.table(path)
    dt <- data.table(df)
  }
dttrain <- fileToMakeTable(file.path(pathIn, "train", "X_train.txt"))
dttest <- fileToMakeTable(file.path(pathIn, "test", "X_test.txt"))
```

##Merge the training and test sets
----------------------------------
Concatenate the data tables

```{r}
dtsub <- rbind(dtsubtrain, dtsubtest)
setnames(dtsub, "V1", "subject")
dtact <- rbind(dtacttrain, dtacttest)
setnames(dtact, "V1", "activityNumber")
dt <- rbind(dttrain, dttest)
```

Merge the columns.

```{r}
dtsub <- cbind(dtsub, dtact)
dt <- cbind(dtsub, dt)
```
Set the key

```{r}
setkey(dt, subject, activityNumber)
```

##Extract only the mean and standard deviation
----------------------------------------------
Read in the 'feature.txt' to tell us what variables in 'dt' are measurements for the mean and standard deviation

```{r}
dtfeat <- fread(file.path(pathIn, "features.txt"))
setnames(dtfeat, names(dtfeat), c("featureNum", "featureName"))
```

Subset only the mean and standard deviation

```{r}
dtfeat <- dtfeat[grepl("mean\\(\\)|std\\(\\)", featureName)]
```

Convert the column numbers to names from the 'feature.txt'

```{r}
dtfeat$featureCode <- dtfeat[,paste0("V", featureNum)]
head(dtfeat)
dtFeat$featureCode
```

Subset using the variables names

```{r}
select <- c(key(dt), dtfeat$featureCode)
dt <- dt[,select, with=FALSE]
```

##Using descriptive activity names
----------------------------------

The 'activity_labels.txt' file will add descriptive activity names

```{r}
dtActnames <- fread(file.path(pathIn, "activity_labels.txt"))
setnames(dtActnames, names(dtActnames), c("activityNumber", "activityName"))
```

##Label with the descriptive names
----------------------------------

Merge the activity labels with the data table

```{r}
dt <- merge(dt, dtActnames, by = "activityNumber", all.x = TRUE)
```

Add the 'activityName' as a key

```{r}
setkey(dt, subject, activityNumber, activityName)
```

We need to reshape the dataset using the melt function. This will changhe it from a short and wide dataset to a tall and skinny dataset

```{r}
dt <- data.table(melt(dt, key(dt), variable.name = "featureCode"))
```

The we can merge the activity names with the melted dataset

```{r}
dt <- merge(dt, dtfeat[,list(featureNum, featureCode, featureName)], by = "featureCode", all.x = TRUE)
```

We have to create a couple of variables for the 'activityName'  and 'featureName'

```{r}
dt$activity <- factor(dt$activityName)
dt$feature <- factor(dt$featureName)
```

A helpful function for the next chunk of code with the grepthis function (helps save on typing)

```{r}
grepthis <- function(name){
    grepl(name, dt$feature)
}
```

Now we seperate the features from 'featureName'

```{r}
n <- 2
y <- matrix(seq(1,n), nrow = n)
x <- matrix(c(grepthis("^t"), grepthis("^f")), ncol = nrow(y))
dt$featDomain <- factor( x %*% y, labels = c("Time", "Feq"))
x <- matrix(c(grepthis("Acc"), grepthis("Gyro")), ncol = nrow(y))
dt$featInstrument <- factor(x %*% y, labels = c("Accelerometer","Gyroscope"))
x <- matrix(c(grepthis("BodyAcc"), grepthis("GravityAcc")), ncol = nrow(y))
dt$featAcceleration <- factor(x %*% y, labels = c(NA, "Body", "Gravity"))
x <- matrix(c(grepthis("mean()"), grepthis("std()")), ncol = nrow(y))
dt$featVariable <- factor( x %*% y, labels = c("Mean","STDEV"))
dt$featJerk <- factor(grepthis("Jerk"), labels = c(NA, "Jerk"))
dt$featMagnitude <- factor(grepthis("Mag"), labels = c(NA, "Magnitude"))
n <- 3
y <- matrix(seq(1,n), nrow=n)
x <- matrix(c(grepthis("-X"), grepthis("-Y"), grepthis("-Z")), ncol=nrow(y))
dt$featAxis <- factor(x %*% y, labels = c(NA,"X","Y","Z"))
```

##Create a tidy dataset
-----------------------

Create a tidy dataset with the average of each variable for activity and subject

```{r}
setkey(dt, subject, activity, featDomain, featAcceleration, featInstrument, featJerk, featMagnitude, featVariable, featAxis)
dtTidy <- dt[, list(count = .N, average = mean(value)), by = key(dt)]
```

##Write to a file
-----------------

Write the dataset to a file using the write.table function

```{r}
f <- file.path(path, "DatasetHumanActivityRecoginitionUsingSmartphones.txt")
write.table(dtTidy, f, quote = FALSE, sep = "\t", row.names = FALSE)
```
