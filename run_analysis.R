library(dplyr)
setwd("E://R/")

# setting up data source url link, and working directory
# to store the downloaded datasets
url<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
folder<-paste0(getwd(),"/","Human_Activity_Recognition.zip")
download.file(url, folder, method = "libcurl")
unzip(files = "Human_Activity_Recognition.zip")
setwd(paste0(getwd(), "/", "UCI HAR Dataset"))

# load each dataset into R
features <- read.table(file = "./features.txt")

x_test <- read.table("./test/X_test.txt")
y_test <- read.table("./test/y_test.txt")
subject_test <- read.table("./test/subject_test.txt")

x_train <- read.table("./train/X_train.txt")
y_train <- read.table("./train/y_train.txt")
subject_train <- read.table("./train/subject_train.txt")

activity_labels <- read.table("./activity_labels.txt")

# merge each x, y and subject data from train 
# and test dataset into one data

x_data <- rbind(x_test, x_train)
y_data <- rbind(y_test, y_train)
subject_data <- rbind(subject_test, subject_train)

# retrieve columns with mean and standard deviation in their names
# grouping them together into one dataset then set their column's names
# according to the features name list

mean_std_features <- grep("(-mean|std)", features$V2)
x_data <- x_data[ , mean_std_features]

# Uses descriptive activity names to name the activities in the dataset
y_data[ ,1] <- activity_labels[y_data[ , ] , 2]

# Labels the dataset with descriptive names
names(y_data) <- "activity"
names(x_data) <- features[mean_std_features, 2]
names(subject_data) <- "subject"

# combine all the dataset
HARdata <- cbind(x_data, y_data, subject_data)

# tidying up dataset with average of each variable
# for each activity and each subject.

average_HARdata <- HARdata %>%
        group_by(activity, subject) %>%
        summarise_all(funs(mean))
