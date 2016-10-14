run_analysis <- function(){
  library(data.table)
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
  setnames(dtfeat, names(dtfeat), c("featureNumber", "featureName"))
  dtfeat <- dtfeat[grepl("mean\\(\\)|std\\(\\)", featureName)]
  dtfeat$featureCode <- dtfeat[,paste0("V", featureNumber)]
  head(dtfeat)
  select <- c(key(dt), dtfeat$featureCode)
  dt <- dt[,select, with=FALSE]
}