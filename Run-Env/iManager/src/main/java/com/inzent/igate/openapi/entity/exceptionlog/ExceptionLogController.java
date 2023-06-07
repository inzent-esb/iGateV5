/*******************************************************************************
 * This program and the accompanying materials are made
 * available under the terms of the Inzent MCA License v1.0
 * which accompanies this distribution.
 *
 * Contributors:
 *     Inzent Corporation - initial API and implementation
 *******************************************************************************/
package com.inzent.igate.openapi.entity.exceptionlog ;

import org.springframework.stereotype.Controller ;
import org.springframework.web.bind.annotation.RequestMapping ;

import com.inzent.igate.openapi.entity.exceptionlog.AbstractExceptionLogController ;
import com.inzent.igate.repository.log.ExceptionLog ;

@Controller
@RequestMapping(AbstractExceptionLogController.URI)
public class ExceptionLogController extends AbstractExceptionLogController<ExceptionLog>
{
  public ExceptionLogController()
  {
    super(ExceptionLog.class) ;
  }
}
