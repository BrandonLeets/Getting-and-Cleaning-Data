run_analysis <- function(){
  library(dplyr)

  #get the data
  url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  fileName <- "Dataset.zip"
  download.file(url, fileName)
  #unzip the files
  unzip(fileName)
  setwd("./UCI HAR Dataset")
  #read in the features file
  feat <- read.table("features.txt", colClasses = "character")
  #read in the activity labels
  actlabels <- read.table("activity_labels.txt", colClasses = "character")
  #Read training files
  dttraindata <- read.table("./train/X_train.txt")
  dttrainsubject <- read.table("./train/subject_train.txt")
  dttrainactivity <- read.table("./train/y_train.txt")
  #combine all together
  dttrain <- cbind(dttrainsubject, dttrainactivity, dttraindata)
  #change the column nmaes train
  colnames(dttrain) <- c("subject", "activity", feat[,2])
  dttrain$condition <- "train"
  #Read in testing files
  dttestdata <- read.table("./test/X_test.txt")
  dttestsubject <- read.table("./test/subject_test.txt")
  dttestactivity <- read.table("./test/y_test.txt")
  #combine all together
  dttest <- cbind(dttestsubject, dttestactivity, dttestdata)
  #Change the column names test 
  colnames(dttest) <- c("subject", "activity", feat[,2])
  dttest$condition <- "test"

  
  #merge both data sets
  dt <- rbind(dttrain, dttest)
  dt <- dt[,c(ncol(dt), 2:ncol(dt)-1)]
  
  #rename the activities
  dt$activity <- as.factor(dt$activity)
  levels(dt$activity) <- actlabels$V2
  
  #create summary
  actsummary <- group_by(dt,condition, subject, activity)
  actsummary <- summarise_each(actsummary, funs(mean))
  
  #save the files
  write.table(dt, "tidyData.txt", row.names = FALSE)
  write.table(actsummary, "tidydatasummary.txt", row.names = FALSE)
  
}