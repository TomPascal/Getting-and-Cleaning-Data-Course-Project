## 1. Merge the training and the test sets to create one data set.

testLabels <- read.table("./test/y_test.txt", col.names="label")

testSubjects <- read.table("./test/subject_test.txt", col.names="subject")

testData <- read.table("./test/X_test.txt")

trainLabels <- read.table("./train/y_train.txt", col.names="label")

trainSubjects <- read.table("./train/subject_train.txt", col.names="subject")

trainData <- read.table("./train/X_train.txt")

data <- rbind(cbind(testSubjects, testLabels, testData),
              cbind(trainSubjects, trainLabels, trainData))

features <- read.table("./features.txt")


## 2. Extract only the measurements on the mean and standard deviation 
##    for each measurement. 

featuresMeanStd <- features[grep("mean\\(\\)|std\\(\\)", features$V2), ]

dataMeanStd <- data[, c(1, 2, featuresMeanStd$V1+2)]


## 3. Use descriptive activity names to name the activities in the data set.

labels <- read.table("./activity_labels.txt")

dataMeanStd$label <- labels[dataMeanStd$label, 2]


## 4. Appropriately label the data set with descriptive activity names.

tidyColnames <- c("subject", "label", featuresMeanStd$V2)

colnames(dataMeanStd) <- tidyColnames


## 5. From the data set in step 4, creates a second, independent tidy data
##    set with the average of each variable for each activity and each
##    subject.

tidyData <- aggregate(dataMeanStd[, 3:ncol(dataMeanStd)],
                       by=list(subject = dataMeanStd$subject, 
                               label = dataMeanStd$label), mean)


write.table(tidyData, "./tidyData.txt", row.names=FALSE, col.names = FALSE)
