## run_analysis.R

## Samsung Data Analysis Script
## for Coursera data cleaning course

## NOTE: This script assumes the Samsung data ## is already downloaded and unzipped in the ## working directory "./Data". The code to
## download and unzip code is commented out.

## Part 1 -- Setup

## optional check for data directory
## if (!file.exists("Data")) {
##  dir.create("Data")
##  }
## setwd("../Data")

## load libraries
library(data.table)
library(stringr)

## Part 2 -- Get Data (commented out for this demo)

## get data
## fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

## download.file(fileUrl, "active.zip", method="curl")

## check for success
## list.files(,"zip")

## unzip file
## unzip("active.zip")

## Part 3 -- Extract tables

## get test data
X_test <- read.table("UCI HAR Dataset/test/X_test.txt", sep="") 

y_test <- read.table("UCI HAR Dataset/test/y_test.txt", sep="") 

subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", sep="") 

## get training data
X_train <- read.table("UCI HAR Dataset/train/X_train.txt", sep="") 

y_train <- read.table("UCI HAR Dataset/train/y_train.txt", sep="") 

subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", sep="")

## get activity data, rename variables
activLabels <- read.table("UCI HAR Dataset/activity_labels.txt")
colnames(activLabels) <- c("activity number", "activity")

## Part 4 -- Combine data

## add subject and activity vars to data
test <- cbind(X_test, y_test, subject_test)
train <- cbind(X_train, y_train, subject_train)

## combine test and training sets
data <- rbind(test, train)

## Part 5 -- Get variable names

## get variable names, add activity, subject names
varNames <- read.table("UCI HAR Dataset/features.txt", sep="") 

## add activity, subject variable names
addNames <- data.frame(V1=c(562, 563), V2=c('activity number', "subject"))
newNames <- rbind(varNames, addNames)

## set temporary column names for now
colnames(data) <- newNames[,2]

## Part 6 -- Merge activity labels into data

## merge activities into combined test and training data
newdata <- merge(data, activLabels, by="activity number", all.x=T, sort=F)

## Part 7 -- Get mean, stdev variables

## find variables that containe mean or standard deviation measurements
meanidx <- grep("mean()", colnames(newdata))      
stdidx <- grep("std()", colnames(newdata))

## check indices
## head(newdata[,stdidx])
## head(newdata[,meanidx])

## combine mean, std subsets into a new table
subdat <- cbind(newdata[, stdidx], newdata[,meanidx], newdata[,563:564])

## make subject a factor
subdat$subject <- as.factor(subdat$subject)

## make subdat a data.table
subdat <- data.table(subdat)

## Part 8 -- Clean up variable names

## clean up column names
fixnames <- names(subdat)

## separate time(t) and Fourier(f) indicators from first character of variable name
fixnames <- ifelse(substring(fixnames, 1,1)=="t", str_replace(fixnames, "t", "t-"), str_replace(fixnames, "f", "f-"))

## delete the unnecessary parentheses
fixnames <- str_replace_all(fixnames, "\\()", "")

## change all to lower case per style
fixnames <- tolower(fixnames)

## replace the old names wiht fixed names
setnames(subdat, fixnames)

## Part 9 -- Crunch means by subject, activity

## calculate means for each subject and activity, copy to new data table
means <- subdat[,lapply(.SD,mean),by=.(subject, activity)]

## Part 10 -- Sort, final clean up, write data

## set key to sort on subject
setkey(means, subject)

## clean up activity names
means$activity <- sub("_", " ", means$activity)
means$activity <- tolower(means$activity)

## write data to a text file
write.table(means, "samsungmeans.txt", row.name=F, quote=F)

## endit