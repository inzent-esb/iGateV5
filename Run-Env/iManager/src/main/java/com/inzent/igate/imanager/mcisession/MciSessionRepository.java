/*******************************************************************************
 * This program and the accompanying materials are made
 * available under the terms of the Inzent MCA License v1.0
 * which accompanies this distribution.
 *
 * Contributors:
 *     Inzent Corporation - initial API and implementation
 *******************************************************************************/
package com.inzent.igate.imanager.mcisession ;

import org.springframework.stereotype.Repository ;

import com.inzent.igate.repository.log.LogPK ;
import com.inzent.igate.repository.log.MciSession ;
import com.inzent.imanager.repository.LogRepository ;

@Repository
public class MciSessionRepository extends LogRepository<LogPK, MciSession>
{
  protected MciSessionRepository()
  {
    super(MciSession.class) ;
  }
}
