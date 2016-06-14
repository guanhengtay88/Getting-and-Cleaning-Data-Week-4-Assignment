fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
filename <- "getdata.zip"
download.file(fileURL, filename, mode = 'wb')
unzip(filename)
library(reshape2)
features <- read.table("UCI HAR Dataset/features.txt")
columnwanted <- grep("mean|std",features$V2)
columnnames <- features[columnwanted,2]

xtest <- read.table("UCI HAR Dataset/test/X_test.txt")
ytest <- read.table("UCI HAR Dataset/test/Y_test.txt",col.names="activity")
subjecttest <- read.table("UCI HAR Dataset/test/subject_test.txt",col.names="subject")
xtrain <- read.table("UCI HAR Dataset/train/X_train.txt")
ytrain <- read.table("UCI HAR Dataset/train/Y_train.txt",col.names="activity")
subjecttrain <- read.table("UCI HAR Dataset/train/subject_train.txt",col.names="subject")

xtest <- xtest[columnwanted]
xtrain <- xtrain[columnwanted]

colnames(xtest) <- columnnames
colnames(xtest) <- tolower(gsub("[()]","",colnames(xtest)))
colnames(xtrain) <- columnnames
colnames(xtrain) <- tolower(gsub("[()]","",colnames(xtrain)))

activitylabel <- read.table("UCI HAR Dataset/activity_labels.txt")

test <- cbind(xtest,ytest,subjecttest)
train <- cbind(xtrain,ytrain,subjecttrain)
data <- rbind(test,train)
data$activity <- factor(data$activity,levels = activitylabel[,1],labels = activitylabel[,2])
data$subject <- as.factor(data$subject)

melted <- melt(data,id = c("subject","activity"))
casted <- dcast(melted, subject+activity~variable, mean)

write.table(casted,"tidy.txt", row.names = FALSE)