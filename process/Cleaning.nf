process Cleaning{
    input: 
    path inputdata
    output:
    path 'processed_data.csv'
    script:
    """
    #!/usr/bin/env Rscript
  
    data_original <- read.csv("${inputdata}")
    NullColIndex <- NULL
    for(i in 4:ncol(data_original)){
      if (sum(data_original[,i]) == 0){
        NullColIndex <- c(NullColIndex,i)
      }
    }
    if (is.null(NullColIndex)){
      data_training <- data_original
    } else {
      data_training <- data_original[,-NullColIndex]
    }
    nonNullColIndex <- setdiff(c(4:ncol(data_original)),NullColIndex)
    outlierIndexList = NULL
    indexList = NULL
    for (region in 3:ncol(data_training)){
      Q1 = quantile(data_training[,region], .25)
      Q3 = quantile(data_training[,region], .75)
      IQR = IQR(data_training[,region])
      lower_outliers = which(data_training[,region]< (Q1 - 1.5*IQR))
      upper_outliers = which(data_training[,region]> (Q3 + 1.5*IQR))
      all_outliers = c(lower_outliers,upper_outliers)
      outlierIndexList = c(outlierIndexList,all_outliers)
    }
    outlierIndexList = unique(outlierIndexList)
    data_training = data_training[-outlierIndexList,]
    write.csv(data_training, 'processed_data.csv')
    
    """
}