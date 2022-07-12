package com.custom.tracelog ;

import com.inzent.igate.repository.log.TraceLog ;
import com.inzent.igate.tracelog.TraceLogDbFile ;

public class CustomTraceLogDbFile extends TraceLogDbFile<TraceLog>
{
  public CustomTraceLogDbFile()
  {
    super(TraceLog.class) ;
  }

  @Override
  protected void formalizeTraceLog(TraceLog traceLog)
  {
    super.formalizeTraceLog(traceLog) ;

    // 로깅 일자를 partition key로 지정
    traceLog.setPartitionId(traceLog.getPk().getLogDateTime().substring(8, 10)) ;
  }
}
