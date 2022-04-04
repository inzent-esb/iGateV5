/*******************************************************************************
 * This program and the accompanying materials are made
 * available under the terms of the Inzent MCA License v1.0
 * which accompanies this distribution.
 *
 * Contributors:
 *     Inzent Corporation - initial API and implementation
 *******************************************************************************/
package com.inzent.igate.imanager.mcisession ;

import org.springframework.beans.factory.annotation.Autowired ;
import org.springframework.stereotype.Controller ;
import org.springframework.web.bind.annotation.RequestMapping ;

import com.inzent.igate.repository.log.LogPK ;
import com.inzent.igate.repository.log.MciSession ;
import com.inzent.imanager.controller.LogController ;

@Controller
@RequestMapping(MciSessionController.URI)
public class MciSessionController extends LogController<LogPK, MciSession>
{
  public static final String URI = "/igate/mciSession" ;

  @Autowired
  public void setBatchLogService(MciSessionService batchLogService)
  {
    setService(batchLogService) ;
  }
}
