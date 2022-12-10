#!/usr/bin/env nextflow
nextflow.enable.dsl=2

include {Cleaning} from './process/Cleaning'
include {Centering} from './process/Centering'
include {Training} from './process/Training'
include {Applying} from './process/Applying'



workflow {
  File outpath = new File(params.output)
    if (!outpath.exists())
        outpath.mkdirs()
        
  ch_initialize = Channel.fromPath(params.rawdata)
  ch_prepare = ch_initialize | Cleaning 
  ch_model = Centering(ch_prepare,ch_initialize) | Training
  Applying(ch_model, Channel.fromPath(params.unseenData))
}