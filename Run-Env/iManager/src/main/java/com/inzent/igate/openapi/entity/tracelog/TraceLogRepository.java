package com.inzent.igate.openapi.entity.tracelog;

import org.springframework.stereotype.Repository ;

import com.inzent.igate.repository.log.TraceLog ;

@Repository
public class TraceLogRepository extends AbstractTraceLogRepositoryRDB<TraceLog>
{
  protected TraceLogRepository() throws Exception
  {
    super(TraceLog.class) ;
  }
}
