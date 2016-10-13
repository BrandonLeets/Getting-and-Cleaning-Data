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

##Question 2
------------
Load the Gross Domestic Product data ffor the 190 ranked countries in this data set:

https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv 

Remove the commas from the GDP numbers in millions of dolloars and average them. What is the average?

Original data source: http://data.worldbank.org/data-catalog/GDP-ranking-table

```{r}
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv "
path <- file.path(getwd(), "GDP.csv")
download.file(url, path)
dfGDP <- data.table(read.csv(path. skip = 4, nrows = 125, stringsAsFactors = False))
dfGDP <- dfGDP[X != ""]
dfGDP <- dfGDP[, list("X","X.1","X.3","X.4")]
setnames(dfGDP, c("X","X.1","X.3","X.4"), c("CountryCode", "rankingGDP", "Long.Name", "gdp"))
gdp <- as.numeric(gsub(",","",dfGDP$gdp))
mean(gdp, na.rm = TRUE)

##Question 3
------------
In the data set from Question 2 what is the regular expression that would allow you to count the number of countries whosae name begin with "United"? Assume that the variable with the country names in it is named countryNames. How many countries begin with United?

```{r}
united <- grepl("^United", dtGDP$Long.Name)
summary(united)
```

##Question 4
------------
Load the Gross Domestic Product data ffor the 190 ranked countries in this data set:

https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv 

Load the educational data from this data set:

https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv 

Match the data based on the country shortcode. Of the countries for which the end of the fiscal year is available. how many end in June?

Original data source:
http://data.worldbank.org/data-catalog/GDP-ranking-table 
http://data.worldbank.org/data-catalog/ed-stats

We already have the first data set from question 2 so there is no reason to reload it

```{r}
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv"
path <- file.path(getwd(), "EDU.csv")
download.file(url, path)
dtEDU <- data.table(read.csv(path))
dt <- merge(dfGDP, dtEDU, all = TRUE, by = c("CountryCode"))
isFiscalOver <- grepl("fiscal year end", tolower(dt$Special.Notes))
isJune <- grepl("june", tolower(dt$Special.Notes))
table(isFiscalOver, isJune)
dt[isFiscalOver & isJune, Special.Notes]
```
##Question 5
------------
You can use the quantmod (http://www.quantmod.com/) package to get historical stock prices for publicly traded companies on the NASDAQ and NYSE. Use the following code to download data on Amazon's stock price and get the times the data was sampled.

```{r}
library(quantmod)
amzn = getSymbols("AMZN", auto.assign = FALSE)
sampleTimes = index(amzn)
```

How many valueswere collected in 2012? How many values were collected on Mondays in 2012?

```{r}
amzn = getSymbols("AMZN", auto.assign = FALSE)
sampleTimes = index(amzn)
addmargins(table(year(sampleTimes), weekdays(sampleTimes)))
```