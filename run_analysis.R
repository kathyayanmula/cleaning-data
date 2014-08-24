##########################################################################################################

## Coursera Getting and Cleaning Data Course Project
## Kathyayan Goud Mula
## 2014-8-24

# runAnalysis.r File Description:

# This script will perform the following steps on the UCI HAR Dataset downloaded from 
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
# 1. Merge the training and the test sets to create one data set.
# 2. Extract only the measurements on the mean and standard deviation for each measurement. 
# 3. Use descriptive activity names to name the activities in the data set
# 4. Appropriately label the data set with descriptive activity names. 
# 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

##########################################################################################################

# Clean up workspace
rm(list=ls())

#set working directory to the location where the UCI HAR Dataset was unzipped
setwd('C:/Users/goud/Desktop/coursera');

#reading the training data on x axis data

trainx<-read.table('UCI HAR Dataset/train/X_train.txt') 

#reading the training data on Y axis data
trainy<-read.table('UCI HAR Dataset/train/Y_train.txt') 

#reading the training data on subject
trainsub<-read.table('UCI HAR Dataset/train/subject_train.txt') 

#reading the test data on x axis data
testx<-read.table('UCI HAR Dataset/test/X_test.txt') 

#selecting the mean and standard deviation columns
col<-c(1:6,41:46) 

# selecting the mean and standard deviation columns from test data on x axis 
testx<-testx[,(col)] 

# selecting the mean and standard deviation columns from train data on x axis 
trainx<-trainx[,(col)] 

#reading the test data on x axis data
testy<-read.table('UCI HAR Dataset/test/Y_test.txt') 

#reading the test data on subject
testsub<-read.table('UCI HAR Dataset/test/subject_test.txt') 

#binding all the columns from test datasets 
test<-cbind(testx,testy,testsub)

#binding all the columns from train datasets 
train<-cbind(trainx,trainy,trainsub)

#binding the rows from testing and training datasets 
testandtrain<-rbind(test,train)

#renaming the subject and activity columns in the merged data set
names(testandtrain)[14]<-'subject'
names(testandtrain)[13]<-'activity'

#renaming the table having the descriptive names of the activities
labels<-read.table('UCI HAR Dataset/activity_labels.txt',col.names=c('activity','activity_name'))

#merging the activity names with the merged test and train dataset
merged<-merge(testandtrain,labels,by.x='activity',by.y='activity')

#assigning descriptive names to the variables
names(merged)[2]<-'Time Body Acceleration Mean on X Axis'
names(merged)[3]<-'Time Body Acceleration Mean on Y Axis'
names(merged)[4]<-'Time Body Acceleration Mean on Z Axis'
names(merged)[5]<-'Time Body Acceleration Std on X Axis'
names(merged)[6]<-'Time Body Acceleration Std on Y Axis'
names(merged)[7]<-'Time Body Acceleration Std on Z Axis'
names(merged)[8]<-'Time Body Gravity Mean on X Axis'
names(merged)[9]<-'Time Body Gravity Mean on Y Axis'
names(merged)[10]<-'Time Body Gravity Mean on Z Axis'
names(merged)[11]<-'Time Body Gravity Std on X Axis'
names(merged)[12]<-'Time Body Gravity Std on Y Axis'
names(merged)[13]<-'Time Body Gravity Std on Z Axis'

attach(merged)

#reshaping the data so that it shows the mean for all the variables for each activity and subject
aggdata <-aggregate(merged, by=list(activity_name,subject),FUN=mean, na.rm=TRUE)

#assigning descriptive names to the variables
names(aggdata)[1]<-'Activity_name'
names(aggdata)[2]<-'Subject'

#selecting columns to display in the final data set
col<-c(1:2,4:15)

#filtering the final data set
final<-aggdata[,(col)]

#writing the final clean data set to working directory
write.table(final,'final.txt', row.name=FALSE)