process Applying{
    input: 
    path mfpmodel
    path unseendata
    script:
    """
    #!/usr/bin/env Rscript
    
    data_unseen_original<-read.csv("${unseendata}")
    mfpModel_list <- readRDS("${mfpmodel}")
  
    prediction_list <- NULL
    z_score_list <- NULL
    regions  <-  data_unseen_original[,c(4:ncol(data_unseen_original))]
    agedata <- list(data_unseen_original[,2])
    for (region in 1:ncol(regions)){
        predicted <- predict(mfpModel_list[[region]],age = agedata[region])
        prediction_list[region] <- data.frame(predicted)
    }
    names(prediction_list) <- names(regions)
        write.csv(prediction_list,"${params.output}/predictions.csv",row.names=FALSE)
    """
}