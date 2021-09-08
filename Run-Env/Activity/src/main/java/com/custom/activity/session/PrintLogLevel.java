package com.custom.activity.session ;

import com.inzent.igate.repository.meta.Activity ;
import com.inzent.igate.rule.activity.AbstractActivity ;

public class PrintLogLevel extends AbstractActivity
{

  public PrintLogLevel(Activity activity)
  {
    super(activity) ;
  }

  @Override
  public boolean isSingleton()
  {
    return true ;
  }

  @Override
  public int execute(Object... args) throws Throwable
  {
	  logger.fatal("==========================PrintLogLevel==========================");
	  logger.fatal("PrintLogLevel : fatal");
	  logger.error("PrintLogLevel : error");
	  logger.warn("PrintLogLevel : warn");
	  logger.info("PrintLogLevel : info");
	  logger.debug("PrintLogLevel : debug");
	  logger.trace("PrintLogLevel : trace");
    return 0 ;
  }
}
