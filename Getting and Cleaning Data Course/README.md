# Getting and Cleaning Data Project
Author: Jane Wang <br />

## Goal of the Project
The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. 
The goal is to prepare tidy data that can be used for later analysis. 
The files included in the submit include: 
1. A tidy data set: the final output data set after running the R script file
2. A link to a Github repository with the script for performing the analysis 
3. A code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. 
4. A README.md in the repo explaining how all of the scripts work and how they are connected.
5. Analysis R Script

## Analysis
### 1. Merge the training and the test sets to create one data set
The combined data is constructed by first combining files from training set tables (including subject_traing, X_train and y_train) and testing set tables (including subject_test, X_test and y_test) together, separatedly. And then combine the training table and testing table tables together.

In this step, we also read the feature names from the features file from the downloaded data set and assign them to the merged data set.

### 2. Extracts only the measurements on the mean and standard deviation for each measurement
In the merged data set, we search for columns with name containing "mean" or "std" and filter the merged data set by keeping the columns meeting the criteria.

### 3. Uses descriptive activity names to name the activities in the data set
We replaced the activity by descriptions read from the activity_labels file in the downloaded data set.

### 4. Appropriately labels the data set with descriptive variable names
We remove special characters in the variable names, expand the columns names (i.e. "^f" changed to be "frequency domain", "^t" changed to be "time domain", "Acc" to be "accelerometer", "Gyro" to be "Gyroscope", "Mag" to be "Magnitude", "Freq" to be "Frequency", "mean" to be "Mean", and "std" to be "StandardDeviation").

### 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject
From the cleaned and fully labled dataset, we calculate mean of each variable for each activity and each subject and save the results into the a new file called tidy_data 
