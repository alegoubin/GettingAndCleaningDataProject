# Getting And Cleaning Data Project

## Course Project contents

The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected. 

One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Here are the data for the project:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

## Goal of the script

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive activity names.
5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## Steps to work on this course project

1. Download the data source and put into a folder on your local drive. You'll have a ```UCI HAR Dataset``` folder.
2. Put ```run_analysis.R``` in the parent folder of ```UCI HAR Dataset```, then set it as your working directory using ```setwd()``` function in RStudio.
3. Run ```source("run_analysis.R")```, then it will generate a new file ```run_data_summary.txt``` in your working directory. Inertial Signals will be ignored.

## Dependencies

```run_analysis.R``` file will help you to install the dependencies automatically. It depends on ```data.table``` and ```dplyr```. 

## Script Steps

The script perform the following steps sequentially to achieve the expected result:

1. Load dplyr and data.table libraries
2. Loop through all files of the file package and load files into data frames (without Inertial files)
3. Merge test files together using column bind (cbind) function
4. Merge train files together using column bind (cbind) function
5. Union both result files into one thanks to the row bind (rbind) function
6. Filter the feature table object that contains column names and keep only the columns with names containing the std() and mean() pattern using the grep function. 
7. Replace column names of merged table with the contents of the feature table that we previously filtered out. Column 1 and 2 are the activity and subject
8. Merge the file using the merge function with the activity labels by the activity code. This way we can display the activity label rather than the code.
9. Use the data.table package and use the following function to get the means for all columns by activity and subject:\n
```meanTable[,lapply(.SD,mean),by=list(activity_label,subject)]```
10. Write result to output file

