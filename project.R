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
