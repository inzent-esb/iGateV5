package com.custom.activity.service ;

import com.custom.activity.telegram.CustomHandlerConstants ;
import com.inzent.igate.activity.service.SyncReplyServiceActivity ;
import com.inzent.igate.adapter.AdapterParameter ;
import com.inzent.igate.exception.IGateException ;
import com.inzent.igate.message.Record ;
import com.inzent.igate.repository.meta.Activity ;
import com.inzent.igate.repository.meta.Service ;

public class CustomSyncReplyServiceActivity extends SyncReplyServiceActivity implements CustomHandlerConstants
{
  public CustomSyncReplyServiceActivity(Activity meta)
  {
    super(meta) ;
  }

  @Override
  protected AdapterParameter makeAdapterParameter(Service serviceMeta, Record request) throws IGateException
  {
    request.setFieldValue(SYNC_MODE_PATH, "S") ;

    return super.makeAdapterParameter(serviceMeta, request) ;
  }
}
