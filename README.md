---
title: "README"
output: html_document
---

The purpose of the Coursera course on Getting and Cleaning Data was to go through the following steps:

Description of original data can be obtained here:
[Link to original README](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)

The data for the project can be downloaded from:
[Link to data](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)
<br/>
You should create one R script called run_analysis.R that does the following.

1. Merges the training and the test sets to create one data set.
1. Extracts only the measurements on the mean and standard deviation for each measurement.
1. Uses descriptive activity names to name the activities in the data set
1. Appropriately labels the data set with descriptive variable names.
1. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

---
## Explanation of RScript

The whole analysis was achieved with the R script `run_analysis.R`. The organization of the script is described below. Be aware that not all the code from the `run_analysis.R` script is shown. 

The packages `dplyr` and `tidyr` are required to run this script.

``` {r, reading_data, eval = FALSE, echo = TRUE}

# Load the relevant packages
library(dplyr)
library(tidyr)

# Set the working directory
setwd("K:/Folder/.../...")

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

```

The code above reads in the data from the current working directory. The data are read into table dataframes with `dplyr`. Whenever you are working with the script, make sure that you set the correct path to the appropriate folders with:

``` {r, path, eval = FALSE, echo = TRUE}
setwd("K:/Folder/.../...")
```

Under this header, the structure of the dataframes is changed to a long format.
``` {r, header, eval = FALSE, echo = TRUE}
# ____________________________________________________________________
# Change structure of the data into something readable 
# ____________________________________________________________________
```

Because initially the column names were identified by simple numbering, descriptive column names have to be applied.
``` {r, names, eval = FALSE, echo = TRUE}
# The types of measurement taken
col.names <- unite(feature_label, cNames, V1, V2, sep = "/")
```

Yet, because the `dplyr` package was used, problems can arise whenever column names are not unique. This is why the feature labels were combined with a common numbering, separated by a `/`. The new column names were applied and only the fields containing the mean or std were selected subsequently.
``` {r, newnames, eval = FALSE, echo = TRUE}
# Apply column names to test dataset
measure_test <- rename_at(measure_test, 
                          vars(colnames(measure_test)), 
                          function(x) col.names$cNames)

# Select only the type of measurements that involve the mean or std
measure_test <- select(measure_test, matches("mean\\(\\)|std\\(\\)"))
```

The long data format was achieved with the `dplyr::gather` function.
``` {r, gather, eval = FALSE, echo = TRUE}
# Reorganize the datasets from a wide into a long format
measure_long_test <- gather(measure_test, key = "Measurement_Type", value = "Measurement", -Set, -SubjNr, -Activity)
```

The training and test set were subsequently combined into one dataframe. The activity levels were labeled as well.
``` {r, combine, eval = FALSE, echo = TRUE}
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
```

Descriptive names for the different measurement types were achieved like this:
``` {r, descriptive, eval = FALSE, echo = TRUE}
# Apply more descripte names for the measurement types
combined_data <- mutate(combined_data, Measurement_Type = gsub("^t", "Time", combined_data$Measurement_Type))
```

The final tidy data structure is expressed by the code below:
``` {r, tidy, eval = FALSE, echo = TRUE}
# Group the data and get average of each variable for each activity and each subject
# This results in a tidy data structure
tidy_combData <- group_by(combined_data, SubjNr, Set, Activity, Measurement_Type) %>%
        summarise(Measurement_Mean = mean(Measurement)) %>%
        print
```