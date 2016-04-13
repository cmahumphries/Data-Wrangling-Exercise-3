#load dplyr
library(dplyr)

#create column names
subject_id <- "SubjectID"
activity_number <- "ActivityLabel"
features <- read.table("features.txt")
features_names <- features$V2

#load subject files as data frames

subject_test <- read.table("subject_test.txt", col.names = subject_id)
y_test <- read.table("y_test.txt", col.names = activity_number)
x_test <- read.table("X_test.txt", col.names = features_names)

#combine into 1 data frame

test <- bind_cols(subject_test, y_test, x_test)

#repeat for train files

subject_train <- read.table("subject_train.txt", col.names = subject_id)
y_train <- read.table("y_train.txt", col.names = activity_number)
x_train <- read.table("X_train.txt", col.names = features_names)
train <- bind_cols(subject_train, y_train, x_train)

#combine test and training data frames
results <- bind_rows(test, train)

#extract columns with means and standard deviations
mean_std <- select(results, contains("SubjectID"), contains("ActivityLabel"), 
       contains("mean"), contains("std"))

#add activity name column
#load activity labels file, give col names to merge data frames
activity_labels <- read.table("activity_labels.txt", 
                              col.names = c("ActivityLabel", "ActivityName"))
#merge data frames
mean_std <- merge(mean_std, activity_labels, by = "ActivityLabel") 

#create new data frame with avg of each variable for each activity and subject
#create empty data frame
activity <- data.frame()
#create a loop to select values for each activity and subject
#then find mean for each value (note Activity label had to be dropped for mean fx to work)
#then add a row to the empty data frame for each activity/subject mean value
for(m in 1:6) {
for(n in 1:30) {
   activity <- rbind(activity, summarise_each(filter(mean_std, ActivityLabel == m, SubjectID == n), 
                                    funs(mean), ActivityLabel:fBodyBodyGyroJerkMag.std..))
}
}
#add activity label back in
activity <- merge(activity, activity_labels, by = "ActivityLabel")
#write to csv file
write.csv(activity, file = "wrangling3.csv")


