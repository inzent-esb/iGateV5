package com.custom.exception ;

import com.inzent.igate.exception.AbstractExceptionManager ;
import com.inzent.igate.repository.log.ExceptionLog ;

public class ExceptionManagerBean extends AbstractExceptionManager<ExceptionLog>
{
  public ExceptionManagerBean()
  {
    super(ExceptionLog.class) ;
  }

  @Override
  protected void handledException(ExceptionLog exceptionLog, Throwable th) throws Exception
  {
    // 예외 처리 로직 추가
  }
}
