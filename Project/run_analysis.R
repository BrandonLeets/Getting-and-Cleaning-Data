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
  fileToMakeTable <- function(path){
    df <- read.table(path)
    dt <- data.table(df)
  }
  dttrain <- fileToMakeTable(file.path(pathIn, "train", "X_train.txt"))
  dttest <- fileToMakeTable(file.path(pathIn, "test", "X_test.txt")) 
}