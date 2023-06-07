package com.custom.activity.adapter ;

import java.io.IOException;

import com.inzent.igate.activity.adapter.AbstractLoggingTrace ;
import com.inzent.igate.repository.log.TraceLog ;
import com.inzent.igate.repository.meta.Activity ;

public class LoggingTrace extends AbstractLoggingTrace<TraceLog>
{
  public LoggingTrace(Activity meta) throws IOException
  {
    super(meta, TraceLog.class) ;
  }
}
