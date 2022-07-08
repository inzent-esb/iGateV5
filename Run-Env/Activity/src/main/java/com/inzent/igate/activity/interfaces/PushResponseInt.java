/*******************************************************************************
 * This program and the accompanying materials are made
 * available under the terms of the Inzent MCA License v1.0
 * which accompanies this distribution.
 * 
 * Contributors:
 *     Inzent Corporation - initial API and implementation
 *******************************************************************************/
package com.inzent.igate.activity.interfaces ;

import com.custom.activity.telegram.CustomHandlerConstants ;
import com.inzent.igate.adapter.AdapterParameter ;
import com.inzent.igate.context.TransactionContext ;
import com.inzent.igate.exception.IGateException ;
import com.inzent.igate.repository.meta.Activity ;

/**
 * R&DÆÀ È¸±Í Å×½ºÆ®¸¦ À§ÇÑ Activity
 */
public class PushResponseInt extends PushResponse
{
  public PushResponseInt(Activity meta)
  {
    super(meta) ;
  }

  @Override
  protected void executeAdapter(AdapterParameter adapterParameter) throws IGateException
  {
    String remoteAddr = TransactionContext.getValue(CustomHandlerConstants.IP_ADDRESS, (String) null) ;
    if (null != remoteAddr)
      adapterParameter.setRemoteAddr(remoteAddr) ;

    super.executeAdapter(adapterParameter) ;
    
//    AdapterManagerBean.push(adapterParameter, Message.DEFAULT_PRIORITY) ;
  }
}
