## README ##

This is a submission for the Course Project for the "Getting and Cleaning Data"
class on Coursera: http:///class.coursera.org/getdata-007.

---

The repository contains the following files:

*   `run_analysis.R` R script which processes the raw data.
*   `CodeBook.md` Description of output data format.
*   `README.md` This file.

In addition, running the script `run_analysis.R` will produce two output files:

*   `combined_values.txt`: Results from step 4 of the assignment---combined
    training and testing subject data, restricted to mean and standard
    deviation measurements, with appropriately labeled variables and values.
*   `summary_values.txt`: Results from step 5 of the assignment---summary of
    the means of each feature variable from step 5, broked down by subject and
    activity.
    
Both output files are space-delimited, with a header line. They can be read
into an R data frame using the following command:
```
read.table(filename = "...", header = TRUE)
```

---
## Functioning of the R script ##

### Data folder ###

The script will first look for data in the subfolder
`./UCI HAR Dataset/`. If not found, it will download the data from the web
and populate the folder. In particular, the script is self-contained.
    
### Step 1 ###
*Merges the training and the test sets to create one data set.*

The data is combined as follows. The top rows correspond to the training
subset of the data, while the bottom rows correspond to the testing subset.
The first block of columns corresponds to all feature variables. This is
followed by a subject column, and an outcome column (the activity using
a numerical code).

These come from the following six files in data folder:

*   Feature variables: `train/X_train.txt`, `test/X_test.txt`.
*   Subject column: `train/subject_train.txt`, `test/subject_test.txt`.
*   Outcome (activity code) column: `train/y_train.txt`, `test/y_test.txt`.

### Step 2 ###
*Extracts only the measurements on the mean and standard deviation for each
measurement.*
    
One of the intermediate steps of the prepocessing in the original data is
the following: the data is broken into samples, containing 128 consecutive
(in time) measurements of several variables. This are the //time-domain
samples//. In addition, some of the time-domain samples are transformed
into //frequency-domain// samples by Fourier transform.

The feature variables, are summary statistics of each sample. The subset that
we take are of the following types:

*   Sample means, denoted by `mean()` in the data. These include both
    time domain means (which are time averages), and frequency domain means
    (which are average amplitudes over the frequency spectrum).
*   Sample standard deviations, denoted by `std()` in the data. Again,
    these include standard deviations of direct measurements over time, as
    well as standard deviations of amplitudes over a frequency spectrum.
*   Mean frequencies, denoted by `meanFreq()` in the data. These are
    amplitude-weighted averages of the frequency spectrum giving the
    "average frequency" of each signal.

All of these are either means or standard deviations of some measurement, and
so are included.

Excluded are features named `angle(...,...)`, even thought they contain
`Mean` in the name. These are in fact angles between various time-averaged
vectors, and not means themselves.

### Step 3 ###
*Uses descriptive activity names to name the activities in the data set.*

This is just a simple substitution of the numerical activity codes with their
labels, using `activity.txt` from the data folder.

### Step 4 ###
*Appropriately labels the data set with descriptive variable names.*

We start with the feature names as found in `features.txt` from the data
folder. The features we kept in step 2 are all summary statistics of of
several samples, each of which corresponds to some 3-dimensional vector
(e.g. `tBodyAcc` corresponds to the time-domain measurement of body
acceleration). Each such vector is represented by its X, Y, and Z coordinate
components, and by its length (magnitude). In the original feature names, these
two cases are treated differently:

*   `<vector measurement>-<summary function>-<axis>` for coordinate components.
*   `<vecor measurement>Mag-<summary function>` for magnitude.

We have used the following unified naming convention for the features:

1.  `<vector measurement>` (i.e. strip the `Mag` substring where present)
2.  `<axis>` (one of X, Y, or Z), or `magnitude`, to denoted which part
    of the vector we are measuring.
3.  `<summary function>` with the parentheses removed (as they get mangled when
    used as column names).

These are joined together with underscores (as opposed to dashes, which also
get mangled when used as column names).

We have also changed the `<vector measurement>` part of the name to be more
reflective of the physical variable measured, rather than the sensor
measurement it came from. See `CodeBook.md` for a complete description of
the new names.

### Step 5 ###
*From the data set in step 4, creates a second, independent tidy data
set with the average of each variable for each activity and each subject.*

We summarize the average (mean) value of each feature for each subject/activity
combination. As a tidy data set, this is in the "wide" format, with one row
for each summary category (each subject/activity combination), which is now
a "sample". There are separate columns for each "measurement" of the "sample",
i.e. the averages of the original features.

Finally, to emphasize that these are averages of the features, we have appended
"_avg" to the column names.
