run_analysis <- function(){
  library(data.table)
  library(knitr)
  path <- getwd()
  #get the data
  url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  fileName <- "Dataset.zip"
  if(!file.exists(path)){dir.create(path)}
  download.file(url, file.path(path, fileName))
  #unzip the files
  unzip(file.path(path, fileName))
  pathIn <- file.path(path, "UCI HAR Dataset")
  list.files(pathIn, recursive = TRUE)
  #Read in files
  dtsubtrain <- fread(file.path(pathIn, "train","subject_train.txt"))
  dtsubtest <- fread(file.path(pathIn, "test","subject_test.txt"))
  dtacttrain <- fread(file.path(pathIn, "train", "Y_train.txt"))
  dtacttest <- fread(file.path(pathIn, "test", "Y_test.txt"))
  fileToMakeTable <- function(path){
    df <- read.table(path)
    dt <- data.table(df)
  }
  dttrain <- fileToMakeTable(file.path(pathIn, "train", "X_train.txt"))
  dttest <- fileToMakeTable(file.path(pathIn, "test", "X_test.txt")) 
  #begin merging the datasets
  dtsub <- rbind(dtsubtrain, dtsubtest)
  setnames(dtsub, "V1", "subject")
  dtact <- rbind(dtacttrain, dtacttest)
  setnames(dtact, "V1", "activityNumber")
  dt <- rbind(dttrain, dttest)
  #merge the columns
  dtsub <- cbind(dtsub, dtact)
  dt <- cbind(dtsub, dt)
  #set the key
  setkey(dt, subject, activityNumber)
  #extract the mean and stdev
  dtfeat <- fread(file.path(pathIn, "features.txt"))
  setnames(dtfeat, names(dtfeat), c("featureNum", "featureName"))
  dtfeat <- dtfeat[grepl("mean\\(\\)|std\\(\\)", featureName)]
  dtfeat$featureCode <- dtfeat[,paste0("V", featureNum)]
  head(dtfeat)
  select <- c(key(dt), dtfeat$featureCode)
  dt <- dt[,select, with=FALSE]
  #use descriptive activity names
  dtActnames <- fread(file.path(pathIn, "activity_labels.txt"))
  setnames(dtActnames, names(dtActnames), c("activityNumber", "activityName"))
  #label with descrititve anmes
  dt <- merge(dt, dtActnames, by = "activityNumber", all.x = TRUE)
  setkey(dt, subject, activityNumber, activityName)
  dt <- data.table(melt(dt, key(dt), variable.name = "featureCode"))
  dt <- merge(dt, dtfeat[,list(featureNum, featureCode, featureName)], by = "featureCode", all.x = TRUE)
  dt$activity <- factor(dt$activityName)
  dt$feature <- factor(dt$featureName)
  grepthis <- function(name){
    grepl(name, dt$feature)
  }
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
  setkey(dt, subject, activity, featDomain, featAcceleration, featInstrument, featJerk, featMagnitude, featVariable, featAxis)
  dtTidy <- dt[, list(count = .N, average = mean(value)), by = key(dt)]
  f <- file.path(path, "DatasetHumanActivityRecoginitionUsingSmartphones.txt")
  write.table(dtTidy, f, quote = FALSE, sep = "\t", row.names = FALSE)
}