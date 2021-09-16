/*******************************************************************************
 * This program and the accompanying materials are made
 * available under the terms of the Inzent MCA License v1.0
 * which accompanies this distribution.
 * 
 * Contributors:
 *     Inzent Corporation - initial API and implementation
 *******************************************************************************/
package com.custom.tracelog ;

import com.inzent.igate.repository.log.TraceLog ;
import com.inzent.igate.tracelog.TraceLogStatisticsBean ;

/**
 * <code>TraceLogStatisticsBeanImpl</code>
 *
 * @since 2020. 7. 2.
 * @version 5.0
 * @author Jaesuk Byon
 */
public class CustomTraceLogStatisticsBean extends TraceLogStatisticsBean
{
  public CustomTraceLogStatisticsBean()
  {
    super(TraceLog.class) ;
  }
}