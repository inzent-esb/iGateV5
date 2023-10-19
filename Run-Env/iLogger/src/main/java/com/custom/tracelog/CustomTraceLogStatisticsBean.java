package com.custom.tracelog ;

import com.inzent.igate.repository.log.TraceLog ;
import com.inzent.igate.tracelog.TraceLogStatisticsBean ;

public class CustomTraceLogStatisticsBean extends TraceLogStatisticsBean
{
  public CustomTraceLogStatisticsBean()
  {
    super(TraceLog.class) ;
  }
}