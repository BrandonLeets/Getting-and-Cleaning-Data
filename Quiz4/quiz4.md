#Quiz 4
=======
The deadline for this quiz was October 16, 2016 by midnight

Load Packages needed for the quiz
```{r}
library(data.tables)
library(quantmod)
```
##Question 1
------------
The American Communtiy Survey Distributes downloadable data about United States communities. Download the 2006 microdata survey about housing for the state of Idaho using download.file() from here: 

https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv

and load the data into R. The code book, describing the variable names is here:

https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf

Apply strsplit() to split all the names of the data frame on the character "wgtp". What is the value of the 123 element of the resulting list?

```{r}
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
path <- file.path(getwd(), "ss06hid.csv")
download.file(url,path)
dt <- data.table(read.csv(path))
varNames <- names(dt)
varNamesSplit <- strsplit(varNames, "wgtp")
varNamesSplit[[123]]
```