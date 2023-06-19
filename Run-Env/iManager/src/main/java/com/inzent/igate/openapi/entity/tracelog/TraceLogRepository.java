package com.inzent.igate.openapi.entity.tracelog;

import org.springframework.stereotype.Repository ;

import com.inzent.igate.openapi.entity.tracelog.AbstractTraceLogRepository ;
import com.inzent.igate.repository.log.TraceLog ;

@Repository
public class TraceLogRepository extends AbstractTraceLogRepository<TraceLog>
{
  protected TraceLogRepository() throws Exception
  {
    super(TraceLog.class) ;
  }
}
