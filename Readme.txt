##########
         This document has 3 components
		 1. Gives the R code that will import the "tidy data" 
		 2. Gives the R code that generated the CodeBook
		 3. Detailed description of run.analysis.R
##########
		
########
		The R code to import the "tidy data" 
		data <- read.table("har_average.txt", header = TRUE)
########

########
         The code to generate the CodeBook
		 "har_average" is the data frame that contains the tidy data set
		 The CodeBook has two columns: 1st column: Variable names & 2nd column: The description
         The 2nd column cleans up the variable names in the first column by the following rules
		 1. "()" were removed 
		 2. "mean" was replaced by "MEAN"
		 3. "std" was replaced by "STD"
		 4. "STD" and "MEAN" were brought to the end of the string
		 Example: "tBodyAcc-mean()-X" is in the first column and the corresponding value in the second column is "tBodyAcc-X-MEAN"
				  The description is to be read as the Mean of the X-axis of "tBodyAcc"
		 
		var.names <- names(har_average)
		description <- var.names
		description <- gsub("\\(|\\)", "", description)
		description <- gsub("mean", "MEAN", description)
		description <- gsub("MEAN-X", "X-MEAN", description)
		description <- gsub("MEAN-Y", "Y-MEAN", description)
		description <- gsub("MEAN-Z", "Z-MEAN", description)
		description <- gsub("std", "STD", description)
		description <- gsub("STD-X", "X-STD", description)
		description <- gsub("STD-Y", "Y-STD", description)
		description <- gsub("STD-Z", "Z-STD", description)
		var.names <- append("VARIABLE", var.names)
		description <- append("VARIABLE DESCRIPTION", description)
		var.names <- sprintf("%-35s",var.names)
		codestart <- paste(var.names, description)
		write.table(codestart, "F:/Cleaning Data/Project/codebook.txt", row.names=FALSE, col.names = FALSE, quote = FALSE)
########

########
		RUN_ANALYSIS.R
		 run.analysis.txt is the R script that generates the output required in the Project,. Namely
		 1. Merges the training and the test sets to create one data set: "har_data"
		 2. Extracts only the measurements on the mean and standard deviation for each measurement: "har_MeanStdVars"
		 3. Uses descriptive activity names to name the activities in the data set: "merged.data"  
		 4. Appropriately labels the data set with descriptive variable names: "merged.data"
		 5. From "merged.data", create a second, tidy data set with the average of each subject x activity pair: "har_average"

		The script comprises several blocks of code each delineated by 3 hash marks on top and at the bottom
		There are several "housekeeping" blocks removing data frames that are no longer necessary


		BLOCK 1: GENERATES THE OUTPUT FOR STEP 1: "har_data"
		har_data has the test data on top followed by the training set
		Before using an rbind(), we test whether the number of columns match
		First the 3 tables subjects, ydata (activity) and the xdata (measurements), are created
		The columns in subjects and ydata are renamed o/w there are 3 columns named V1
		The 3 tables are then merged with a cbind()

		BLOCK 2: HOUSEKEEPING: REMOVES UNNECESSARY R OBJECTS

		BLOCK 3: RENAMES THE MEASUREMENT VARIABLES IN "har_data" TO MATCH THOSE IN "features.txt"


		BLOCK 4: GENERATES THE OUTPUT FOR STEP 2: "har_MeanStdVars"
		1. Initially "meanstdcols" contains the column numbers of the columns in har_data that contain "mean()" and "std()" measurements
		2. Then "meanstdcols" gets sorted so that the order corresponds to the order in har_data for better visualization
		3. Finally, "har_MeanStdVars" is created by copying the relevant har_data columns (identified by "meanstdcols")

		BLOCK 5: HOUSEKEEPING: HOUSEKEEPING: REMOVES UNNECESSARY R OBJECTS

		BLOCK 6: GENERATES THE OUTPUT FOR STEP 3: "merged.data"
		The difference between "merged.data" and "har_MeanStdVars" is that the "activityID" is replaced by "activityName"
		Done by merging har_data with the activity table on the common variable "activityID"
		Later this common variable is dropped and the resulting first two columns ("activityName" and "subjectID") are transposed
		Incidentally this output is also the output required in STEP 4 since descriptive names are assigned in BLOCK 3 to "har_data"


		BLOCK 7: HOUSEKEEPING: HOUSEKEEPING: REMOVES UNNECESSARY R OBJECTS

		BLOCK 8: OUTPUT FOR STEP 4: Already computed in BLOCK 6 "merged.data"

		BLOCK 9: OUTPUT FOR STEP 5: "har_average"
		1. "har_average" with the required rows and columns was created
		2. For each pair of ("subjectID", "activityName") the corresponding subset of the merged.data was taken
		3. The mean of the 561 was computed and entered into the row designated by ("subjectID", "activityName")
		4. the variable names of "har_average" were made to match "merged.data"
		5. "har_average" is saved as "har_average.csv"
########
 
