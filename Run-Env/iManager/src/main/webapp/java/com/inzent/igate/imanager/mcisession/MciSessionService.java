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
import org.springframework.stereotype.Service ;

import com.inzent.igate.repository.log.LogPK ;
import com.inzent.igate.repository.log.MciSession ;
import com.inzent.imanager.service.LogService ;

@Service
public class MciSessionService extends LogService<LogPK, MciSession>
{
  @Autowired
  public void setMciSessionRepository(MciSessionRepository mciSessionRepository)
  {
    setRepository(mciSessionRepository) ;
  }
}
