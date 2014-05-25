# install reshape2 package is it does not exist
if(!require("reshape2")) {
  install.packages("reshape2")
}


datadir <- "UCI HAR Dataset/"

# reading activities and features data
activities <- read.table(paste0(datadir, "activity_labels.txt"), header=FALSE, 
                         stringsAsFactors=FALSE)

features <- read.table(paste0(datadir, "features.txt"), header=FALSE, 
                       stringsAsFactors=FALSE)

# reading test data
subjecttestdata <- read.table(paste0(datadir,"test/","subject_test.txt"),header=FALSE)
Xtest <- read.table(paste0(datadir,"test/","X_test.txt"),header=FALSE)
Ytest <- read.table(paste0(datadir,"test/","Y_test.txt"),header=FALSE)
tmpdata <- data.frame(Activity = factor(Ytest$V1,labels =activities$V2))
resulttestdata <- cbind(tmpdata, subjecttestdata,Xtest)

# reading training data
subjecttraindata <- read.table(paste0(datadir,"train/","subject_train.txt"),header=FALSE)
Xtrain <- read.table(paste0(datadir,"train/","X_train.txt"),header=FALSE)
Ytrain <- read.table(paste0(datadir,"train/","Y_train.txt"),header=FALSE)
tmpdata <- data.frame(Activity = factor(Ytrain$V1,labels =activities$V2))
resulttraindata <- cbind(tmpdata, subjecttraindata,Xtrain)

# tidy data
tmptidydata <- rbind(resulttestdata,resulttraindata)
names(tmptidydata) <- c("Activity","Subject",features[,2])
filter <- features$V2[grep("mean\\(\\)|std\\(\\)", features$V2)]
tidydata <- tmptidydata[c("Activity", "Subject", filter)]

# wite to file
write.table(tidydata, file="tidydata.txt", row.names=FALSE)

# Average data
tidydatamelt <- melt(tidydata, id=c("Activity", "Subject"), measure.vars=filter)
tidydatamean <- dcast(tidydatamelt, Activity + Subject ~ variable, mean)

write.table(tidydatamean,file="tidyaverage.txt",row.names=FALSE)