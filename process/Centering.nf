process Centering{
    input: 
    path inputdata
    path original
    output:
    path 'data_training_centered.csv'
    script:
    """
    #!/usr/bin/env Rscript
    
    regionMean <- NULL
    data_original <- read.csv("${original}")
    data_training <- read.csv("${inputdata}")
    data_training_centered <- data_training
    
    for (region in 3:ncol(data_training_centered)) {
        data_training_centered[,region] <- data_training_centered[,region] - mean(data_training_centered[,region])
        }
    write.csv(data_training_centered, 'data_training_centered.csv',row.names = FALSE)
    
    """
}