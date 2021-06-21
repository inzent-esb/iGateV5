package com.custom.activity.adapter ;

import com.inzent.igate.activity.adapter.AbstractLoggingTrace ;
import com.inzent.igate.repository.log.TraceLog ;
import com.inzent.igate.repository.meta.Activity ;

public class LoggingTrace extends AbstractLoggingTrace<TraceLog>
{
  public LoggingTrace(Activity meta)
  {
    super(meta, TraceLog.class) ;
  }
}
