package com.custom.activity.session ;

import org.apache.commons.codec.binary.Hex;

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
  public int execute(Object... args) throws Exception
  {
	  logger.fatal("==========================PrintLogLevel==========================");
	  logger.fatal("PrintLogLevel : fatal");
	  logger.error("PrintLogLevel : error");
	  logger.warn("PrintLogLevel : warn");
	  logger.info("PrintLogLevel : info");
	  logger.debug("PrintLogLevel : debug");
	  logger.trace("PrintLogLevel : trace");
	  
	  byte[] packetDelimiter = Hex.decodeHex("0d0a") ;
	  
	  logger.error("packetDelimiter"+ packetDelimiter);
	  
    return 0 ;
  }
}
