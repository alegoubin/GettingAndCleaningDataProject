runAnalysis <- function(folderpath)
  
{

  library(dplyr)
  library(data.table)
  
  #declare variables
  dtXTest <- data.frame()
  dtYTest <- data.frame()
  dtXTrain <- data.frame()
  dtYTrain <- data.frame()
  dtSubjectTest <- data.frame()
  dtSubjectTrain <- data.frame()
  dtFeatures <- data.frame()
  dtActLabels <- data.frame()
  
  # Extract list of files
  fileList <- list.files(folderpath,recursive = TRUE)
  
  for(file in fileList)
  {
    
    #Load X test file into table object
    if(length(grep(x = file,pattern = "X_test.txt")) == 1 && grep(x = file,pattern = "X_test.txt") > 0)
    {
      dtXTest <- read.table(file,header=FALSE)
    }
    
    #Load Y test file into table object
    if(length(grep(x = file,pattern = "y_test.txt")) == 1 && grep(x = file,pattern = "y_test.txt") > 0)
    {
      dtYTest <- read.table(file,header=FALSE)
    }
    
    #Load X train file into table object
    if(length(grep(x = file,pattern = "X_train.txt")) == 1 && grep(x = file,pattern = "X_train.txt") > 0)
    {
      dtXTrain <- read.table(file,header=FALSE)
    }
    
    #Load Y train file into table object
    if(length(grep(x = file,pattern = "y_train.txt")) == 1 && grep(x = file,pattern = "y_train.txt") > 0)
    {
      dtYTrain <- read.table(file,header=FALSE)
    }
    
    #Load subject train file into table object
    if(length(grep(x = file,pattern = "subject_train.txt")) == 1 && grep(x = file,pattern = "subject_train.txt") > 0)
    {
      dtSubjectTrain <- read.table(file,header=FALSE)
    }
    
    #Load subject test file into table object
    if(length(grep(x = file,pattern = "subject_test.txt")) == 1 && grep(x = file,pattern = "subject_test.txt") > 0)
    {
      dtSubjectTest <- read.table(file,header=FALSE)
    }
    
    #Load features file into table object
    if(length(grep(x = file,pattern = "features.txt")) == 1 && grep(x = file,pattern = "features.txt") > 0)
    {
      dtFeatures <- read.table(file,header=FALSE)
    }
    
    #Load activity lables file into table object
    if(length(grep(x = file,pattern = "activity_labels.txt")) == 1 && grep(x = file,pattern = "activity_labels.txt") > 0)
    {
      dtActLabels <- read.table(file,header=FALSE)
    }
    
  }
  
  
  #Build a unified test set
  dtTest <- cbind(dtSubjectTest ,dtYTest,dtXTest)
  
  #Build a unified test set
  dtTrain <- cbind(dtSubjectTrain ,dtYTrain,dtXTrain) 
    
  #Merge both sets
  dtAll <- rbind(dtTest,dtTrain)  
  
  #Use features files to define column names, first and two columns are the subject and activity codes
  colnames(dtAll)[1:2]<-c("subject","activity")
  cFeatures <- as.vector(dtFeatures[,2])
  
  colnames(dtAll)[-(1:2)]<-cFeatures
  
  #Keep only std and mean measures
  colKeep <- which(grepl("std\\(\\)",colnames(dtAll)) | grepl("mean\\(\\)",colnames(dtAll)) | grepl("subject",colnames(dtAll)) | grepl("activity",colnames(dtAll)))
  dtAll <- dtAll[colKeep]
  
  #Add Activity labels
  colnames(dtActLabels)<-c("activity","activity_label")
  dtAll <- merge(x= dtActLabels,y = dtAll, by ="activity")
  dtAll <- dtAll[-1]
  
  #Build mean table by subject and activity label
  meanTable <- data.table(dtAll)
  meanTable <- arrange(meanTable, activity_label,subject)
  meanTable <- meanTable[,lapply(.SD,mean),by=list(activity_label,subject)]
  
  #Change variable names to make them more meaningful
  names(meanTable) <- names(meanTable) %>%
    sub("^t", "time", .) %>%            
    sub("^f", "frequency", .) %>%
    gsub("([^\\-])([A-Z])", "\\1\\_\\L\\2\\E", ., perl=TRUE) %>%
    gsub("body_body", "body", .) %>%
    gsub("acc", "accelerometer", .) %>%  
    gsub("gyro", "gyroscope", .) %>%
    gsub("mag", "magnitude", .) %>%
    gsub("std\\(\\)", "standard_deviation", .) %>%
    gsub("mean\\(\\)", "mean", .)
  
  #Write to output
  write.table(meanTable, file="run_data_summary.txt", row.name=FALSE)
  
  return(meanTable)
  
}


