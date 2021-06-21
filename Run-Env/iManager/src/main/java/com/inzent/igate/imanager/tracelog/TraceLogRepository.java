package com.inzent.igate.imanager.tracelog;

import org.springframework.stereotype.Repository ;

import com.inzent.igate.repository.log.TraceLog ;

@Repository
public class TraceLogRepository extends AbstractTraceLogRepository<TraceLog>
{
  protected TraceLogRepository()
  {
    super(TraceLog.class) ;
  }
}
