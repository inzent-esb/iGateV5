/*******************************************************************************
 * This program and the accompanying materials are made
 * available under the terms of the Inzent MCA License v1.0
 * which accompanies this distribution.
 * 
 * Contributors:
 *     Inzent Corporation - initial API and implementation
 *******************************************************************************/
package com.inzent.igate.imanager.tracelog ;

import org.springframework.beans.factory.annotation.Autowired ;
import org.springframework.stereotype.Service ;

import com.inzent.igate.repository.log.TraceLog ;

@Service
public class TraceLogService extends AbstractTraceLogService<TraceLog>
{
  @Autowired
  public void setTraceLogRepository(TraceLogRepository traceLogRepository)
  {
    setRepository(traceLogRepository) ;
  }
}
