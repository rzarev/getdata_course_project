## Codebook ##

This file contains a description of the data contained in `suumary_values.txt`
produced by running `run_analysis.R`.

---

The original source for the data is:

>Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, Luca Oneto.  
>Smartlab - Non Linear Complex Systems Laboratory  
>DITEN - UniversitÃ  degli Studi di Genova, Genoa I-16145, Italy.  
>activityrecognition '@' smartlab.ws  
>www.smartlab.ws  

via

>UCI Machine Learning Repository  
><http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones>  

For more information on the original research producing the data, see:

>**Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and
>Jorge L. Reyes-Ortiz.**  
>*Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly
>Support Vector Machine.*  
>International Workshop of Ambient Assisted Living (IWAAL 2012).  
>Vitoria-Gasteiz, Spain. Dec 2012  

---

### Raw data collection and initial processing ###
The following is a citation from the `README.txt` file in the original data
set:

>The experiments have been carried out with a group of 30 volunteers within
>an age bracket of 19-48 years. Each person performed six activities (WALKING,
>WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a
>smartphone (Samsung Galaxy S II) on the waist. Using its embedded
>accelerometer and gyroscope, we captured 3-axial linear acceleration and
>3-axial angular velocity at a constant rate of 50Hz. The experiments have
>been video-recorded to label the data manually. The obtained dataset has been
>randomly partitioned into two sets, where 70% of the volunteers was selected
>for generating the training data and 30% the test data. 

>The sensor signals (accelerometer and gyroscope) were pre-processed by
>applying noise filters and then sampled in fixed-width sliding windows of
>2.56 sec and 50% overlap (128 readings/window). The sensor acceleration
>signal, which has gravitational and body motion components, was separated
>using a Butterworth low-pass filter into body acceleration and gravity. The
>gravitational force is assumed to have only low frequency components,
>therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a
>vector of features was obtained by calculating variables from the time and
>frequency domain. See 'features_info.txt' for more details.

---

### Further processing ###

For each time-window sample there are the following vector variables, each
with 128 consecutive values:

*   `tGravityLinAccel` Gravity (linear) acceleration.
*   `tBodyLinAccel` Body linear acceleration.
*   `tBodyLinJerk` Body linear jerk (time derivative of acceleraction).
*   `tAngVelo` Angular velocity.
*   `tAngAccel` Angular acceleration (time dervative of velocity).

In addition, Fourier transforms are taken of some these:

*   `fBodyLinAccel` FT of body linear accelaration.
*   `fBodyLinJerk` FT of body linear jerk.
*   `fAngVelo` FT of angular velocity.
*   `fAngAccel` FT of angular acceleration.

For each of these vectors quantities, the samples have been summarized as
follows:

*   Mean and standard deviation of each coordinate component (X, Y, and Z), as
    well as magnitude (vector length).
*   For the Fourier transforms, the mean frequency (amplitude-weighted average
    of frequency) was taken for each coordinate component (X, Y, and Z), as
    well as magnitude (vector length).
*   The single exception is that for `fAngAccel` (FT of angular velocity)
    the summaries of only the magnitude were taken.

Each of this was then rescaled by an affine linear transformation, so that
the range over the training subset is exactly [-1, +1].

**All steps described so far (except for renaming the variables) were done in
the original processing of the data, not by `run_analysis.R`.**

Finally, the data was reduced to one entry (one row) for each subject-activity
combination. The entry consists of the means of each variable, taken over
all samples with the given subject-activity combination. Note: both training
and test subjects were included.

---

### File description ###

The file `summary_values.txt` is a space-delimited text file, with a single
header line, containing the column names (enclosed in double quotes).

Each row contains a summary (mean) of the variables described above for one
subject-activity combination.

Columns (in order):

*   `subject` The values are integers, from 1 through 30, corresponding to
    different subjects.
*   `activity` A string (enclosed in double quotes) describing an activity.
    Possible values:
    *   `LAYING`, `SITTING`, `STANDING`, `WALKING`, `WALKING_DOWNSTAIRS`,
        `WALKING_UPSTAIRS`.
*   Columns 3 through 81, contain the averages. Each column label consists
    of four parts describing the contents, in the following format:
    1.  Vector variable as described in further processing above. One of
        9 possibilites. Time domain samples start with `t`, frequency domain
        samples start with `f`.
    2.  Vector component. One of `X`, `Y`, `Z`, or `magnitude`.
    3.  Summary function. One of `mean`, `std`, or `meanFreq`.
    4.  `avg` (To remind us that the table represents averages over multiple
        samples).
    *   The four parts are divided by an underscore: `_`.
