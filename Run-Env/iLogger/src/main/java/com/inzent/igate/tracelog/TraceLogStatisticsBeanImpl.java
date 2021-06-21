/*******************************************************************************
 * This program and the accompanying materials are made
 * available under the terms of the Inzent MCA License v1.0
 * which accompanies this distribution.
 * 
 * Contributors:
 *     Inzent Corporation - initial API and implementation
 *******************************************************************************/
package com.inzent.igate.tracelog ;

import org.springframework.stereotype.Component ;

import com.inzent.igate.repository.log.TraceLog ;

/**
 * <code>TraceLogStatisticsBeanImpl</code>
 *
 * @since 2020. 7. 2.
 * @version 5.0
 * @author Jaesuk Byon
 */
@Component
public class TraceLogStatisticsBeanImpl extends TraceLogStatisticsBean
{
  public TraceLogStatisticsBeanImpl()
  {
    super(TraceLog.class) ;
  }
}