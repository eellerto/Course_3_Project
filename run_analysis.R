#Course 3 project
library(tidyr)
library(stringr)
library(dplyr)

filename <- "Course3_final.zip"
if (!file.exists(filename)){
        fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        download.file(fileURL, filename, method="curl")
}  
if (!file.exists("UCI_Dataset")) { 
        unzip(filename) 
}
#load all datasets to build DF
features <- read.table("/Users/elaine/Desktop/Data sets/UCI HAR Dataset/features.txt", col.names = c("n", "patterns"))
#activities <- read.table("/Users/elaine/Desktop/Data sets/UCI HAR Dataset/activity_labels.txt", col.names = c("num", "activity"))
X_test<-read.table("/Users/elaine/Desktop/Data sets/UCI HAR Dataset/test/X_test.txt", col.names =  features$patterns)
Y_test <- read.table("/Users/elaine/Desktop/Data sets/UCI HAR Dataset/test/y_test.txt", col.names = "num")
subject_test <- read.table("/Users/elaine/Desktop/Data sets/UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
X_train <- read.table("/Users/elaine/Desktop/Data sets/UCI HAR Dataset/train/X_train.txt", col.names = features$patterns)
Y_train <- read.table("/Users/elaine/Desktop/Data sets/UCI HAR Dataset/train/y_train.txt", col.names = "num")
subject_train <- read.table("/Users/elaine/Desktop/Data sets/UCI HAR Dataset/train/subject_train.txt", col.names = "subject")

#bind data
x <- rbind(X_train, X_test)
y <- rbind(Y_train, Y_test)
subjects <- rbind(subject_train, subject_test)
#merge all datasets
merge <- cbind(subjects, x, y)
#remove only means and standard deviations from data
#mean_std_data <- grep("mean|std", merge[,2])
#or alternate way
HAR_data_u_std <- merge %>% select( subject, num, contains("mean"), contains("std"))

#use descriptive activity names
activity <-read.table("/Users/elaine/Desktop/Data sets/UCI HAR Dataset/activity_labels.txt", col.names = c("num", "activity"))
activity <- tolower(activity$activity)
HAR_data_u_std $num <- activities[HAR_data_u_std$num, 2]

#add descriptive names to variables
HAR_data_u_std <- rename(HAR_data_u_std , activity=num)
names(HAR_data_u_std ) <- gsub("AccJerk","acceleration jerk ", names(HAR_data_u_std ))
names(HAR_data_u_std )<-gsub("Acc", "accelerometer ", names(HAR_data_u_std ))
names(HAR_data_u_std ) <- gsub("Mag", "magnitude ", names(HAR_data_u_std ))
names(HAR_data_u_std ) <- gsub("^t", "Time domain: ", names(HAR_data_u_std ))
names(HAR_data_u_std ) <- gsub("^f", "Frequency domain: ", names(HAR_data_u_std ))
names(HAR_data_u_std ) <- gsub("BodyBody", "Body ", names(HAR_data_u_std ))
names(HAR_data_u_std ) <- gsub("GyroJerk", "angular velocity jerk ", names(HAR_data_u_std ))
names(HAR_data_u_std ) <- gsub("Gyro", "gyroscope ", names(HAR_data_u_std ))
names(HAR_data_u_std ) <- gsub("\\.mean", "mean ", names(HAR_data_u_std ))
names(HAR_data_u_std ) <- gsub("()", "", names(HAR_data_u_std ))
names(HAR_data_u_std ) <- gsub("\\.std", "Standard Deviation ", names(HAR_data_u_std ))
names(HAR_data_u_std ) <- gsub("\\.Z.", "Z", names(HAR_data_u_std ))
names(HAR_data_u_std ) <- gsub("\\.X.", "X", names(HAR_data_u_std ))
names(HAR_data_u_std ) <- gsub("\\.Y.", "Y", names(HAR_data_u_std ))
names(HAR_data_u_std ) <- gsub("X", " X-axis ", names(HAR_data_u_std ))
names(HAR_data_u_std ) <- gsub("Y", " Y-axis ", names(HAR_data_u_std ))
names(HAR_data_u_std ) <- gsub("Z", " Z-axis ", names(HAR_data_u_std ))
names(HAR_data_u_std ) <- gsub("\\...", " ", names(HAR_data_u_std ))
names(HAR_data_u_std ) <- gsub("\\..", "", names(HAR_data_u_std ))
names(HAR_data_u_std ) <- gsub("Mean", " mean", names(HAR_data_u_std ))
names(HAR_data_u_std ) <- gsub("\\.", "", names(HAR_data_u_std ))
names(HAR_data_u_std ) <- gsub("_mean", " mean ", names(HAR_data_u_std ))
names(HAR_data_u_std ) <- gsub("ody", "body ", names(HAR_data_u_std ))
names(HAR_data_u_std ) <- gsub("Bbody", "Body ", names(HAR_data_u_std ))
names(HAR_data_u_std ) <- gsub("avity", "gravity ", names(HAR_data_u_std ))
names(HAR_data_u_std ) <- gsub("Gravity", "gravity ", names(HAR_data_u_std ))
names(HAR_data_u_std ) <- gsub("Grgravity", "Gravity ", names(HAR_data_u_std ))


# Create a second, independent tidy data set with the average of each variable for each activity and each subject.
HAR_data_means<- HAR_data_u_std %>% group_by(subject, activity) %>% summarize_all(funs(mean))
write.table(HAR_data_means, "HAR_data_means.txt")















