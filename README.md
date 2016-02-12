# Course Project: Getting and Cleaning Data

This is the course project for the 'Getting and Cleaning Data' Coursera module of the Data Science Specialization.
The R script 'run_analysis.R' executes following operations:

1. Download the dataset (if it doesn't exist in the working directory)
2. Load the activity labels and features 
3. Extract only the data of the mean and standard deviation
4. Match '-mean', '-std', '[-()]' and replace them with 'Mean', 'Std' and '' respectively.
5. Loads the training and test datasets and subsets the columns which
   contain mean or standard deviation data
6. Loads the testActivities and  testSubjects datasets
   and attach them as columns to the test dataset
7. Binds train and test datasets rows and adds column names
8. Converts activities and subjects columns to factors for later usage with reshape2 library
9. Loads reshape2 library and melts data, converts with dcast to data frame
10.Creates a tidy dataset that consists of the mean value of each
   variable for each subject and activity pair.

The end result is writen to the file 'tidy.csv'.
