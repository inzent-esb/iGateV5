package com.inzent.igate.openapi.entity.exceptionlog;

import org.springframework.stereotype.Repository ;

import com.inzent.igate.openapi.entity.exceptionlog.AbstractExceptionLogRepository ;
import com.inzent.igate.repository.log.ExceptionLog ;

@Repository
public class ExceptionLogRepository extends AbstractExceptionLogRepository<ExceptionLog>
{
  public ExceptionLogRepository() throws Exception
  {
    super(ExceptionLog.class) ;
  }
}
