package com.custom.activity.service ;

import com.custom.activity.telegram.CustomHandlerConstants ;
import com.inzent.igate.activity.service.SyncReplyServiceActivity;
import com.inzent.igate.adapter.AdapterParameter ;
import com.inzent.igate.exception.IGateException ;
import com.inzent.igate.message.HttpConstants;
import com.inzent.igate.message.Record ;
import com.inzent.igate.message.ValueObject;
import com.inzent.igate.repository.meta.Activity ;
import com.inzent.igate.repository.meta.Service ;

public class CustomDreamWizeSyncReplyServiceActivity extends SyncReplyServiceActivity implements CustomHandlerConstants
{
  public CustomDreamWizeSyncReplyServiceActivity(Activity meta)
  {
    super(meta) ;
  }

  @Override
  protected AdapterParameter makeAdapterParameter(Service serviceMeta, Record request) throws IGateException
  {
    request.setFieldValue(SYNC_MODE_PATH, "S") ;

    AdapterParameter adapterParameter = super.makeAdapterParameter(serviceMeta, request) ;

    //HTTP Header에 원하는 Header를 넣기 위한 Custom 작업

    ValueObject valueObject = new ValueObject() ; // RequestData를 header를 포함하기 위한 ValueObject로 변경 
    
    byte[] bodyValueArr = (byte[]) adapterParameter.getRequestData() ;

    valueObject.put(HttpConstants.BODY, bodyValueArr) ; // 기존 RequestData를 Body에 넣어줌

    ValueObject header = new ValueObject(false, true) ; // HTTP Header를 Setting 
    
    //Appian-API-Key Setting
    header.put("Appian-API-Key", "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiI4ZjAyOGE3MS0xOWU5LTQ5N2YtYWQzOC0zNzFhNTE2NzRhZmIifQ.CAZ5Br769oDFh2jUrI2aScplgfu1DayjL383YqjUL18") ;

    valueObject.put(HttpConstants.HEADER, header) ;
    
    adapterParameter.setRequestData(valueObject);
    
    return adapterParameter ;
  }

}
