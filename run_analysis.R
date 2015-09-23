#You should create one R script called run_analysis.R that does the following. 
#1. Merges the training and the test sets to create one data set.
#2. Extracts only the measurements on the mean and standard deviation for each measurement. 
#3. Uses descriptive activity names to name the activities in the data set
#4. Appropriately labels the data set with descriptive variable names. 
#5. From the data set in step 4, creates a second, independent tidy data set with the average 
#   of each variable for each activity and each subject.

library(reshape2)
library(dplyr)

## load data
X_test <- read.table('UCI HAR Dataset/test/X_test.txt')
y_test <- read.table('UCI HAR Dataset/test/y_test.txt')
subject_test <- read.table('UCI HAR Dataset/test/subject_test.txt')

X_train <- read.table('UCI HAR Dataset/train/X_train.txt')
y_train <- read.table('UCI HAR Dataset/train/y_train.txt')
subject_train <- read.table('UCI HAR Dataset/train/subject_train.txt')

features <- read.table('UCI HAR Dataset/features.txt')
activity_labels <- read.table('UCI HAR Dataset/activity_labels.txt')

## combine data
X_data_set <- rbind(X_test,X_train)
subjectID <- rbind(subject_test,subject_train)
activityID <- rbind(y_test, y_train)

## extract the variables related to std and mean
idx_std <- grep('std()', features$V2)
idx_mean<- grep('mean()', features$V2)
idx <- sort(c(idx_std,idx_mean))

## take the columns in interest and add descriptive variable names
subX <- X_data_set[,idx]
df <- cbind(subjectID, activityID, subX)
colnames(df) <- c('subjectID', 'ActivityID', as.character(features$V2[idx]))

## summarize data
dfMelt <- melt(df, id=colnames(df)[1:2], measure.vars = colnames(df)[3:length(colnames(df))])
grouped <- group_by(dfMelt,subjectID, ActivityID, variable)
summaryData <- summarise(grouped, mean=mean(value))
colnames(summaryData) <- c('subjectID', 'ActivityID', 'features', 'mean')

## make activity ID descriptive
summaryData$ActivityID <- unlist(lapply(summaryData$ActivityID, 
                                        function (x) {activity_labels$V2[grep(x,activity_labels$V1)]}))

## write data frame into a txt file
write.table(summaryData, file = "summaryData.txt", row.name=FALSE)