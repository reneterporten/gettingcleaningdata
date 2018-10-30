# Coursera - Getting and Cleaning Data Course Project

# Description of original data can be obtained here:
# http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

# The data for the project can be downlaoded from:
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

# You should create one R script called run_analysis.R that does the following.

# 1 - Merges the training and the test sets to create one data set.
# 2 - Extracts only the measurements on the mean and standard deviation for each measurement.
# 3 - Uses descriptive activity names to name the activities in the data set
# 4 - Appropriately labels the data set with descriptive variable names.
# 5 - From the data set in step 4, creates a second, independent tidy data set with the average 
#     of each variable for each activity and each subject.

# ____________________________________________________________________
# Read in data and prepare for subsequent steps
# ____________________________________________________________________


# Load the relevant packages
library(dplyr)
library(tidyr)

# Set the working directory
setwd("K:/PhD v2/Coursera - Data Science/Getting and Cleaning Data")

# Specify the folder that are of interest for the analysis, list all files
folder_general <- "./UCI HAR Dataset/"
file_list_general <- list.files(path = folder_general, pattern = "*.txt", full.names = TRUE)

folder_test <- "./UCI HAR Dataset/test/"
file_list_test <- list.files(path = folder_test, pattern = "*.txt", full.names = TRUE)

folder_train <- "./UCI HAR Dataset/train/"
file_list_train <- list.files(path = folder_train, pattern = "*.txt", full.names = TRUE)

# Read the relevant data to the variables to work on
data_list_general <- lapply(file_list_general[1:2], read.table, header = FALSE)
data_list_test <- lapply(file_list_test, read.table, header = FALSE)
data_list_train <- lapply(file_list_train, read.table, header = FALSE)

# Change the variables into a data_frame structure on which the dplyr/tidyr packages can work
# General information
activity_label <- tbl_df(data_list_general[[1]]) # A short list with activity labels (walking etc.)
feature_label <- tbl_df(data_list_general[[2]]) # A list referring to the features (body acc mean etc.)

# Test datasets
subject_num_test <- tbl_df(data_list_test[[1]]) # A one column data frame with subj number
measure_test <- tbl_df(data_list_test[[2]]) # A huge frame consisting out of 2947 x 561(feature) entries
activity_num_test <- tbl_df(data_list_test[[3]]) # A long column with 2947 rows of activity code

# Training datasets
subject_num_train <- tbl_df(data_list_train[[1]])
measure_train <- tbl_df(data_list_train[[2]]) 
activity_num_train <- tbl_df(data_list_train[[3]])

# Remove all variables that are not needed anymore, saves memory
rm(folder_general, 
   file_list_general, 
   folder_test, 
   file_list_test, 
   folder_train, 
   file_list_train,
   data_list_general,
   data_list_test,
   data_list_train)


# ____________________________________________________________________
# Change structure of the data into something readable 
# ____________________________________________________________________

# The types of measurement taken
col.names <- unite(feature_label, cNames, V1, V2, sep = "/")

# Apply column names to test dataset
measure_test <- rename_at(measure_test, 
                          vars(colnames(measure_test)), 
                          function(x) col.names$cNames)

# Select only the type of measurements that involve the mean or std
measure_test <- select(measure_test, matches("mean\\(\\)|std\\(\\)"))

# Apply column names to training dataset
measure_train <- rename_at(measure_train, 
                           vars(colnames(measure_train)), 
                           function(x) col.names$cNames)

# Select only the type of measurements that involve the mean or std
measure_train <- select(measure_train, matches("mean\\(\\)|std\\(\\)"))

# Add the subject and activity number to the test data
measure_test <- mutate(measure_test, SubjNr = subject_num_test$V1) %>%
        mutate(Set = "test") %>%
        mutate(Activity = activity_num_test$V1)

# Add the subject and activity number to the training data
measure_train <- mutate(measure_train, SubjNr = subject_num_train$V1) %>%
        mutate(Set = "train") %>%
        mutate(Activity = activity_num_train$V1)

# Reorganize the datasets from a wide into a long format
measure_long_test <- gather(measure_test, key = "Measurement_Type", value = "Measurement", -Set, -SubjNr, -Activity)
measure_long_train <- gather(measure_train, key = "Measurement_Type", value = "Measurement", -Set, -SubjNr, -Activity)


# ____________________________________________________________________
# Change structure of the data into something readable 
# ____________________________________________________________________

# Combine the training and the test data into one data frame
combined_data <- bind_rows(measure_long_test, measure_long_train)

# The measurement type variable includes an identifyer Nr which is not needed anymore
# Apply more descriptive activity names
combined_data <- separate(combined_data, Measurement_Type, c("Identifyer", "Measurement_Type"), sep = "/") %>%
        select(SubjNr, Set, Activity, Measurement_Type, Measurement) %>%
        mutate( Activity = recode(Activity, 
                                  "1" = "WALKING", 
                                  "2" = "WALKING_UPSTAIRS", 
                                  "3" = "WALKING_DOWNSTAIRS",
                                  "4" = "SITTING", 
                                  "5" = "STANDING", 
                                  "6" = "LAYING"))

# Apply more descripte names for the measurement types
combined_data <- mutate(combined_data, Measurement_Type = gsub("^t", "Time", combined_data$Measurement_Type))
combined_data <- mutate(combined_data, Measurement_Type = gsub("Acc", "Accelerometer", combined_data$Measurement_Type))
combined_data <- mutate(combined_data, Measurement_Type = gsub("^f", "Frequency", combined_data$Measurement_Type))
combined_data <- mutate(combined_data, Measurement_Type = gsub("BodyBody", "Body", combined_data$Measurement_Type))
combined_data <- mutate(combined_data, Measurement_Type = gsub("Gyro", "Gyroscope", combined_data$Measurement_Type))
combined_data <- mutate(combined_data, Measurement_Type = gsub("Mag", "Magnitude", combined_data$Measurement_Type))

# Group the data and get average of each variable for each activity and each subject
# This results in a tidy data structure
tidy_combData <- group_by(combined_data, SubjNr, Set, Activity, Measurement_Type) %>%
        summarise(Measurement_Mean = mean(Measurement)) %>%
        print


# ____________________________________________________________________
# Save the tidy data and write codebook
# ____________________________________________________________________

write.table(tidy_combData, file = "tidydata.txt", row.name = FALSE)

library(knitr)
knit2html("codebook.Rmd")
