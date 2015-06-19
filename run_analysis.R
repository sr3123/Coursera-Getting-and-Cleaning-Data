### The script comprises several blocks of code each delineated by 3 hash marks on top and at the bottom
### There are several "housekeeping" blocks removing data frames that are no longer necessary
### To access/save the data, the complete path name has been given:
### Example: read.table("F:/Cleaning Data/Project/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/X_test.txt")

run_analysis <- function() 
{

### BLOCK 1: GENERATES THE OUTPUT FOR STEP 1 
# The final output will have the test data on top followed by the training set
# Initially 3 tables are created keeping the order mentioned above
# xdata: Has 10299 rows and 563 columns.  Each row is the set of observations on 561 variables and pertains to a particular subject 
# subjects: Has 10299 rows and 1 column.  Each row identifies the subject whose measurements correspond to the same row in xdata
# ydata:   Has 10299 rows and 1 column.  Each row corresponds to the same row in "subjects" and "xdata"
# The columns in subjects and y data are renamed o/w during the cbind() there will be columns with the same name "V1"


# Collecting the X data into a data frame "xdata"
	xtest <- read.table("F:/Cleaning Data/Project/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/X_test.txt")
	xtrain <- read.table("F:/Cleaning Data/Project/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/x_train.txt")
	if (ncol(xtest) == ncol(xtrain)) xdata <- rbind(xtest, xtrain) else stop("mismatch in xtest and xtrain") #Test compatibility

# Collecting all subject IDs into a data frame "subjects"
	subject_test <- read.table("F:/Cleaning Data/Project/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt")
	subject_train <- read.table("F:/Cleaning Data/Project/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt")
	if (ncol(subject_test) == ncol(subject_train)) subjects <- rbind(subject_test, subject_train) else stop("mismatch in subject_test and subject_train") #Test compatibility
	colnames(subjects) <- "subjectID"

# Collecting the y data into a table "ydata"
	ytest <- read.table("F:/Cleaning Data/Project/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/y_test.txt")
	ytrain <- read.table("F:/Cleaning Data/Project/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/y_train.txt")
	if (ncol(ytest) == ncol(ytrain)) ydata <- rbind(ytest, ytrain) else stop("mismatch in ytest and ytrain") #Test compatibility
	colnames(ydata) <- "activityID"

# har_data: The merging of the training and test data sets
# The variables in har_data are currently labelled subjectID, activityID, V1, V1 ... V561 
	har_data<- cbind(subjects, ydata, xdata)
### BLOCK 1: har_data IS THE OUTPUT REQUIRED IN STEP 1


### BLOCK 2: HOUSEKEEPING
	rm(subject_test, subject_train, subjects, xtest,xtrain, xdata, ytest,ytrain,ydata) 
### ONLY R OBJECT LEFT IS har_data


### BLOCK 3: RENAMING THE VARIABLES IN har_data

# First column: subjectID, 2nd column: activityID, 3rd - 561rd columns: the measurements 
# The measurements are obtained from features.txt
	features<- read.table("F:/Cleaning Data/Project/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/features.txt")
	colnames(har_data) <- c("subjectID", "activityID", as.character(features[, 2]))
### BLOCK 3: har_data VARIABLES HAVE THE SAME NAME AS IN features.txt

### BLOCK 4: GENERATES THE OUTPUT FOR STEP 2

# meanstdcols contains the column numbers of the columns in har_data that contain "mean()" and "std()" measurements
# meanstdcols gets sorted so that the order corresponds to the order in har_data for better visualization
	meanstdcols <- sort(c(grep("mean()", names(har_data), fixed = TRUE), grep("std()", names(har_data), fixed = TRUE)))

# Subsetting har_data restricted to variables measuring mean() and std()
	har_MeanStdVars <- har_data[ , c(1, 2, meanstdcols)]
### BLOCK 4: har_MeanStdVars IS THE OUTPUT REQUIRED IN STEP 2 with the additional property that the variables have descriptive names

### BLOCK 5: HOUSEKEEPING
	rm(meanstdcols) 
### ONLY R OBJECTS LEFT ARE har_data and features and har_MeanStdVars


### BLOCK 6: GENERATES THE OUTPUT FOR STEP 3
# The second column of har_MeanStdVars "activityID" to be replaced by "activityName"
# Done by merging har_data with the activity table on a common variable "activityID"
# Later deleting this common variable and transposing the first two columns for better visualization

# activity_dict contains the info in activity_labels.txt; the variable are renamed appropriately
activity_dict  <- read.table("F:/Cleaning Data/Project/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/activity_labels.txt")
colnames(activity_dict) = c("activityID", "activityName")

# The two tables activity_dict and har_MeanStdVars are merged
# First activity_dict so that the first column is activityID
# The 2nd and 3rd columns are "activityName" and "subjectID" in the merged data
# The 1st column is then dropped and the 2nd and 3rd are interchanged
# The output columns will be "subjectID" followed by "activityName" followed by the mean / std measurement data

	merged.data2 <- merge(activity_dict, har_MeanStdVars, by="activityID")
	merged.data1 <- merged.data2[, c(2:ncol(merged.data2))]
	merged.data <- merged.data1[, c(2, 1, (3:ncol(merged.data1)))]
### BLOCK 6: merged.data IS THE OUTPUT FOR STEP 3


### BLOCK 7: HOUSEKEEPING
	rm(merged.data1, merged.data2) 
### ONLY R OBJECTS LEFT ARE har_data and features and activity.dict and merged.data and har_MeanStdVars


### BLOCK 8: OUTPUT FOR STEP 4
# Already computed in BLOCK 6 "merged.data" since descriptive names were assigned to "har_data" in BLOCK 3
### BLOCK 8:


### BLOCK 9: OUTPUT FOR STEP 5

# Creating the required output: har_average
# This is saved as a csv file
# Since it is known that there are 30 subjects and activity_labels.txt has 6 activities, har_average will have 180 rows
# Number of columns will equal the number of columns in merged.data: subjectID, activityName, and measurements
	no.col <- ncol(merged.data)
	har_average <- as.data.frame(matrix(0, ncol = no.col, nrow = 180))
	colnames(har_average) <- colnames(merged.data)

# Computing the averages of merged.data for each pair subjectID x activityName 
	for (k in 1:30) 
	  {
  	  for (j in 1:6)
	    {
		r <- 6*(k-1) + j
		har_average[r,1] <- k
 	      activity <- as.character(activity_dict[j,2])
	      har_average[r,2] <- activity
 	      sub.act <- subset(merged.data,subjectID ==k & activityName == activity)
 	      meanvector <- colMeans(sub.act[, c(3:ncol(sub.act))])
	      for (i in 3:68) 
		   har_average[r, i] <- as.numeric(meanvector[i-2])
 	    }
	  }
	write.table(file="F:/Cleaning Data/Project/har_average.txt", har_average, row.names=FALSE)
### BLOCK 9: OUTPUT FOR STEP 5 har_average   
}
