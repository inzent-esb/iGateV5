package com.custom.tracelog ;

import com.inzent.igate.repository.log.TraceLog ;
import com.inzent.igate.tracelog.TraceLogStatisticsRDB2RDB ;

public class CustomTraceLogStatistics extends TraceLogStatisticsRDB2RDB
{
  public CustomTraceLogStatistics()
  {
    super(TraceLog.class) ;
  }
}