package com.custom.tracelog ;

import com.inzent.igate.repository.log.TraceLog ;
import com.inzent.igate.tracelog.TraceLogStatisticsBean ;

public class CustomTraceLogStatistics extends TraceLogStatisticsBean
{
  public CustomTraceLogStatistics()
  {
    super(TraceLog.class) ;
  }
}