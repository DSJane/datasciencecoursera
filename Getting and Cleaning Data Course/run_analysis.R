# INTRODUCTION
#   Using data collected from the accelerometer and gyroscope from the Samsung Galaxy S 
#   smartphone for six activites to make a clean data set combining both training and 
#   testing data set
#

library(dplyr)


# STEP 1 - Get data

# define the link to data file and zip file name
# download zip file 
FileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
RawFile <- "UCI HAR Dataset.zip"

if (!file.exists(RawFile)) {
        download.file(FileURL, RawFile, mode = "wb")
}

# unzip the download file 
dataPath <- "UCI HAR Dataset"
if (!file.exists(dataPath)) {
        unzip(RawFile)
}


# STEP 2 - Read data

# read training data
trainingSubjects <- read.table(file.path(dataPath, "train", "subject_train.txt"), header = FALSE)
trainingValues <- read.table(file.path(dataPath, "train","X_train.txt"), header = FALSE)
trainingActivity <- read.table(file.path(dataPath, "train","y_train.txt"), header = FALSE)

# read test data
testSubjects <- read.table(file.path(dataPath, "test", "subject_test.txt"),header = FALSE)
testValues <- read.table(file.path(dataPath, "test", "X_test.txt"),header = FALSE)
testActivity <- read.table(file.path(dataPath, "test", "y_test.txt"),header = FALSE)

# read features
features <- read.table(file.path(dataPath, "features.txt"), as.is = TRUE, header = FALSE)

# read activity labels and assign names to each column
activities <- read.table(file.path(dataPath, "activity_labels.txt"), header = FALSE)
colnames(activities) <- c("ActivityId", "ActivityLabel")


# Step 3 - Merge the training and the test sets 

# The combined data is constructed by first combining files from
# training set tables and testing set tables together separatedly
# and then combine both tables together
ExamActivity <- rbind(
        cbind(trainingSubjects, trainingValues, trainingActivity),
        cbind(testSubjects, testValues, testActivity)
)

# assign column names
colnames(ExamActivity) <- c("subject", features[, 2], "activity")


# Step 4 - Extracts only the measurements on the mean and standard deviation for each measurement

# look for column names containing phrase "mean" or "std"
columnsToKeep <- grepl("subject|activity|mean|std", colnames(ExamActivity))

# filter and keep the columns meeting our need
ExamActivity <- ExamActivity[, columnsToKeep]


# Step 5 - Assign descriptive activity names to name the activities in the data
#          set

# convert activity values with named factor levels
ExamActivity$activity <- factor(ExamActivity$activity, 
                                 levels = activities[, 1], labels = activities[, 2])


# Step 6 - Label the data set with descriptive variable names

# get column names
ExamActivityCols <- colnames(ExamActivity)

# remove special characters
ExamActivityCols <- gsub("[\\(\\)-]", "", ExamActivityCols)

# expand abbreviations and clean up names
ExamActivityCols <- gsub("^f", "frequencyDomain", ExamActivityCols)
ExamActivityCols <- gsub("^t", "timeDomain", ExamActivityCols)
ExamActivityCols <- gsub("Acc", "Accelerometer", ExamActivityCols)
ExamActivityCols <- gsub("Gyro", "Gyroscope", ExamActivityCols)
ExamActivityCols <- gsub("Mag", "Magnitude", ExamActivityCols)
ExamActivityCols <- gsub("Freq", "Frequency", ExamActivityCols)
ExamActivityCols <- gsub("mean", "Mean", ExamActivityCols)
ExamActivityCols <- gsub("std", "StandardDeviation", ExamActivityCols)

# correct typo
ExamActivityCols <- gsub("BodyBody", "Body", ExamActivityCols)

# use new labels as column names
colnames(ExamActivity) <- ExamActivityCols


# Step 7 - Create a second, independent tidy set with the average of each
#          variable for each activity and each subject

# group by subject and activity and summarise using mean
ExamActivityMeans <- ExamActivity %>% 
        group_by(subject, activity) %>%
        summarise_each(list(mean))

# save the dataset to file "tidy_data.txt"
write.table(ExamActivityMeans, "tidy_data.txt", row.names = FALSE, 
            quote = FALSE)
