# Step 0
# Anything not explicitly mentioned in the assignment.
# ====================================================
library(magrittr)
library(dplyr)

# File names
remote_url <- paste0("https://d396qusza40orc.cloudfront.net/",
                     "getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip")
local_zipfile <- "dataset.zip"
data_folder <- "UCI HAR Dataset/"

# Download and unzip data
if (!file.exists(data_folder)) {
    if (!file.exists(local_zipfile))
        download.file(url = remote_url, destfile = local_zipfile,
                      method = "wget")
    unzip(local_zipfile)
}

# Load all the data labels
activity_labels <- read.table(paste0(data_folder, "activity_labels.txt"),
                              header = FALSE, stringsAsFactors = TRUE,
                              col.names = c("activity_code", "activity"))
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
# Use the variable names from "features.txt" for now. These get mangled
# (e.g. "()" becomes ".."), but better than nothing.
X_train   <- read.table(paste0(data_folder, "train/X_train.txt"),
                        header = FALSE, col.names = feature_labels$label)
X_test    <- read.table(paste0(data_folder, "test/X_test.txt"),
                        header = FALSE, col.names = feature_labels$label)
y_train   <- read.table(paste0(data_folder, "train/y_train.txt"),
                        header = FALSE, col.names = c("activity_code"))
y_test    <- read.table(paste0(data_folder, "test/y_test.txt"),
                        header = FALSE, col.names = c("activity_code"))

# Keep the feature varibles in front, so the column numbers are still the
# ones from "features.txt".
step1_data <- rbind(cbind(X_train, sub_train, y_train),
                    cbind(X_test,  sub_test,  y_test))

# Step 2
# Extracts only the measurements on the mean and standard deviation
# for each measurement. 
# =================================================================

mean_column_nos <- grep("mean\\(\\)|meanFreq\\(\\)",
                        feature_labels$label, value = FALSE)
std_column_nos  <- grep("std\\(\\)",  feature_labels$label, value = FALSE)
step2_data <- step1_data %>%
    select(mean_column_nos, std_column_nos, subject, activity_code)

# Step 3
# Uses descriptive activity names to name the activities in the data set.
# =======================================================================

# Replace the "activity_code" column, by the corresponding name from
# "activity_labels.txt".
step3_data <- step2_data %>%
    merge(activity_labels) %>%
    select(-activity_code)

# Step 4
# Appropriately labels the data set with descriptive variable names.
# ==================================================================

raw_names <- feature_labels$label[c(mean_column_nos, std_column_nos)]
split_names <- strsplit(raw_names, split = "-")

# We have two different patterns of names, for vector coords,
# and for vector magnitudes. Standardize them as a data.frame.
uniformize <- function(x) {
    if (length(x) == 3)
        x[c(1, 3, 2)]
    else
        c(sub("Mag", "", x[1]), "magnitude", x[2])
}
names_frame <- split_names %>%
    lapply(uniformize) %>%
    as.data.frame(col.names = NULL, stringsAsFactors = FALSE) %>%
    t %>%
    as.data.frame(row.names = NULL, stringsAsFactors = FALSE)
colnames(names_frame) <- c("var", "coord", "fun")
rownames(names_frame) <- NULL

# Some features from "features.txt" have a typo. Fix them.
names_frame$var <- sub("BodyBody", "Body", names_frame$var)

# Strip bad characters.
names_frame$fun <- sub("\\(\\)", "", names_frame$fun)

# Combine all components.
new_names <- with(names_frame, paste(var, coord, fun, sep="_"))

step4_data <- step3_data
colnames(step4_data)[1:(ncol(step4_data) - 2)] <- new_names

# Step 5
# From the data set in step 4, creates a second, independent tidy data
# set with the average of each variable for each activity and each subject.
# =========================================================================
step5_data <- step4_data %>%
    group_by(subject, activity) %>%
    summarise_each(funs(mean))
colnames(step5_data)[3:ncol(step5_data)] <-
    sub("$", "_avg", colnames(step5_data)[3:ncol(step5_data)])

# Step 6
# Write the results to disk.
# ==========================
write.table(step4_data, file = "combined_values.txt", row.names = FALSE)
write.table(step5_data, file = "summary_values.txt", row.names = FALSE)
