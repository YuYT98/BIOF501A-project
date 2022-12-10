process Training{
    input: 
    path inputdata
    output:
    path 'mfpModel_subcorticalvolume_list.rds'
    script:
    """
    #!/usr/bin/env Rscript
    
    library(mfp)
    mfpModel_list <- NULL
    data_training_centered <- read.csv("${inputdata}")
    for (region in 4:ncol(data_training_centered)) {
        names(data_training_centered)[names(data_training_centered) == names(data_training_centered)[region]] <-  "region_temp"
        mfpModel <- mfp(region_temp~fp(age,df=4),data=data_training_centered[,c(2,3,region)])

        mfpModel_list[[region-3]] <- mfpModel
    }
    saveRDS(mfpModel_list, "mfpModel_subcorticalvolume_list.rds")
    
    """
}