/*******************************************************************************
 * This program and the accompanying materials are made
 * available under the terms of the Inzent MCA License v1.0
 * which accompanies this distribution.
 * 
 * Contributors:
 *     Inzent Corporation - initial API and implementation
 *******************************************************************************/
package com.inzent.igate.openapi.entity.exceptionlog ;

import org.springframework.beans.factory.annotation.Autowired ;
import org.springframework.stereotype.Service ;

import com.inzent.igate.repository.log.ExceptionLog ;
import com.inzent.igate.repository.log.ExceptionLogPK ;
import com.inzent.imanager.service.LogEntityService ;

@Service
public class ExceptionLogService extends LogEntityService<ExceptionLogPK, ExceptionLog>
{
  @Autowired
  public void setExceptionLogRepository(ExceptionLogRepository exceptionLogRepository)
  {
    setEntityRepository(exceptionLogRepository) ;
  }
}
