# Step 0
# Anything not explicitly mentioned in the assignment.
# ====================================================

# File names
remote_url <- paste0("https://d396qusza40orc.cloudfront.net/",
                     "getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip")
local_zipfile <- "dataset.zip"
data_folder <- "UCI HAR Dataset/"

# Download and unzip data
if (!file.exists(local_zipfile))
    download.file(url = remote_url, destfile = local_zipfile, method = "wget")
if (!file.exists(data_folder))
    unzip(local_zipfile)

# Load all the data labels
activity_labels <- read.table(paste0(data_folder, "activity_labels.txt"),
                              header = FALSE, stringsAsFactors = FALSE,
                              col.names = c("level", "label"))
feature_labels <- read.table(paste0(data_folder, "features.txt"),
                             header = FALSE, stringsAsFactors = FALSE,
                             col.names = c("col_number", "label"))

# Step 1
# Merges the training and the test sets to create one data set.
# =============================================================

sub_train <- read.table(paste0(data_folder, "train/subject_train.txt"),
                        header = FALSE, col.names = c("subject"))
sub_test  <- read.table(paste0(data_folder, "test/subject_test.txt"),
                        header = FALSE, col.names = c("subject"))
X_train   <- read.table(paste0(data_folder, "train/X_train.txt"),
                        header = FALSE, col.names = feature_labels$label)
X_test    <- read.table(paste0(data_folder, "test/X_test.txt"),
                        header = FALSE, col.names = feature_labels$label)
y_train   <- read.table(paste0(data_folder, "train/y_train.txt"),
                        header = FALSE, col.names = c("activity"))
y_test    <- read.table(paste0(data_folder, "test/y_test.txt"),
                        header = FALSE, col.names = c("activity"))

raw_data <- rbind(cbind(sub_train, X_train, y_train),
                  cbind(sub_test,  X_test,  y_test))

# Step 2
# Extracts only the measurements on the mean and standard deviation
# for each measurement. 
# =================================================================

# Step 3
# Uses descriptive activity names to name the activities in the data set.
# =======================================================================

# Step 4
# Appropriately labels the data set with descriptive variable names.
# ==================================================================

# Step 5
# From the data set in step 4, creates a second, independent tidy data
# set with the average of each variable for each activity and each subject.
# =========================================================================
