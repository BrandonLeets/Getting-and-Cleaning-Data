#Project for Getting and Cleaning Data
--------------------------------------

##Parameters for the Project
Instructions

The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set.
The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.

One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Here are the data for the project:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

You should create one R script called run_analysis.R that does the following.

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

Good luck!

##To reproduce the project
1. Open the 'run_analysis.R' in rstudio
3. Run the script

##Outputs
Tidy dataset file 'tidyData.txt' Which is saved in the UCI HAR Dataset

##Library
---------
Load these specific Libraries

```{r}
library(dplyr)
```

##Get the data
--------------
Download the file usind 'download.file' and save it to the 'Data' folder

```{r}
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
fileName <- "Dataset.zip"
download.file(url, fileName)
```

Unzip the file

```{r}
  unzip(fileName)
```

The unzipping put all the data into a file called 'UCI HAR Dataset'. Change the input path to reflect this and list the file names.

```{r}
  setwd("./UCI HAR Dataset")
```

The files in the 'Inertial signals' will not be used for this project.

##Read the Files
----------------
Read the Features and Activity Labels file

```{r}
feat <- read.table("features.txt", colClasses = "character")
actlabels <- read.table("activity_labels.txt", colClasses = "character")
```
Read in all the training data

```{r}
dttraindata <- read.table("./train/X_train.txt")
dttrainsubject <- read.table("./train/subject_train.txt")
dttrainactivity <- read.table("./train/y_train.txt")
```

Combine all the Training Data together

```{r}
dttrain <- cbind(dttrainsubject, dttrainactivity, dttraindata)
```

Change the column names and create "train" variable to group by later

```{r}
colnames(dttrain) <- c("subject", "activity", feat[,2])
dttrain$condition <- "train"
```

Repeat the same process for the test data

```{r}
dttestdata <- read.table("./test/X_test.txt")
dttestsubject <- read.table("./test/subject_test.txt")
dttestactivity <- read.table("./test/y_test.txt")
dttest <- cbind(dttestsubject, dttestactivity, dttestdata)
colnames(dttest) <- c("subject", "activity", feat[,2])
dttest$condition <- "test"
```


##Merge the training and test sets
----------------------------------

Merge the datasets together

```{r}
dt <- rbind(dttrain, dttest)
dt <- dt[,c(ncol(dt), 2:ncol(dt)-1)]
```

##Renmae the Activities with Descriptive Names
----------------------------------------------
Rename the Activities

```{r}
dt$activity <- as.factor(dt$activity)
levels(dt$activity) <- actlabels$V2
```

##Create a Summary of the Tidy Data
-----------------------------------
Create a summary for the data with the mean

```{r}
actsummary <- group_by(dt,condition, subject, activity)
actsummary <- summarise_each(actsummary, funs(mean))
```

##Save to File with write.table()
---------------------------------
Save with write.table

```{r}
write.table(dt, "tidyData.txt", row.names = FALSE)
write.table(actsummary, "tidydatasummary.txt", row.names = FALSE)
```
