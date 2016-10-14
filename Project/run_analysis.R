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
}