package com.inzent.igate.imanager.exceptionlog;

import org.springframework.stereotype.Repository ;

import com.inzent.igate.repository.log.ExceptionLog ;

@Repository
public class ExceptionLogRepository extends AbstractExceptionLogRepository<ExceptionLog>
{
  protected ExceptionLogRepository()
  {
    super(ExceptionLog.class) ;
  }
}
