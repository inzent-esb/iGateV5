package com.inzent.igate.activity.interfaces;

import com.custom.activity.telegram.CustomHandlerConstants ;
import com.inzent.igate.adapter.AdapterParameter ;
import com.inzent.igate.context.TransactionContext ;
import com.inzent.igate.exception.IGateException ;
import com.inzent.igate.repository.meta.Activity ;

/**
 * R&DÆÀ È¸±Í Å×½ºÆ®¸¦ À§ÇÑ  Activity
 */
public class SendResponseInt extends SendResponse
{
  public SendResponseInt(Activity meta)
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
  }
}
