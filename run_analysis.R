filename <- "getdata_dataset.zip"

## Download and unzip the dataset:
if (!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
  download.file(fileURL, filename, method="curl")
}  
if (!file.exists("UCI HAR Dataset")) { 
  unzip(filename) 
}

# Load activity labels
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt")
# Convert factors to character values for later use in the factor function
# as 'labels' argument which must be a character vector
activityLabels[,2] <- as.character(activityLabels[,2])

# Load features
features <- read.table("UCI HAR Dataset/features.txt")


# Extract only the data of the mean and standard deviation in to 'featuresMeanStdV' vector
featuresMeanStdV <- grep(".*mean.*|.*std.*", as.character(features[,2]))

# Extract names in to vector
featuresMeanStdNamesV <- features[featuresMeanStdV,2]

# match '-mean' and replace with 'Mean'
featuresMeanStdNamesV <- gsub('-mean', 'Mean', featuresMeanStdNamesV)

# match '-std' and replace with 'Std'
featuresMeanStdNamesV <- gsub('-std', 'Std', featuresMeanStdNamesV)

# match '[-()]' and replace with empty character
featuresMeanStdNamesV <- gsub('[-()]', '', featuresMeanStdNamesV)


# Load the train data set and subset it by 'featuresMeanStdV'
train <- read.table("UCI HAR Dataset/train/X_train.txt")
train <- train [featuresMeanStdV]

# Load the trainActivities and  trainSubjects data sets
# and attach them as columns to the train data set via cbind
trainActivities <- read.table("UCI HAR Dataset/train/Y_train.txt")
trainSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
train <- cbind(trainSubjects, trainActivities, train)

# Load the test data set and subset it by 'featuresMeanStdV'
test <- read.table("UCI HAR Dataset/test/X_test.txt")
test <- test[featuresMeanStdV]

# Load the testActivities and  testSubjects data sets
# and attach them as columns to the test data set via cbind
testActivities <- read.table("UCI HAR Dataset/test/Y_test.txt")
testSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(testSubjects, testActivities, test)

# Bind train and test datasets rows and add column names
resultData <- rbind(train, test)
colnames(resultData) <- c("subject", "activity", featuresMeanStdNamesV)

# Convert activities and subjects columns to factors for later usage with reshape2 library
resultData$activity <- factor(resultData$activity, levels = activityLabels[,1], labels = activityLabels[,2])
resultData$subject <- as.factor(resultData$subject)

# Load reshape2 library and melt data, convert with dcast to data frame
library(reshape2)
resultDataMelted <- melt(resultData, id = c("subject", "activity"))
resultDataMean <- dcast(resultDataMelted, subject + activity ~ variable, mean)

write.table(resultDataMean, "tidy.txt", row.names = FALSE, quote = FALSE)
