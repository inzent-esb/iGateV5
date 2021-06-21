package com.custom.tracelog ;

import java.util.UUID ;

import com.custom.message.CustomMessageConstants ;
import com.fasterxml.jackson.databind.node.ObjectNode ;
import com.inzent.igate.message.MessageConverter ;
import com.inzent.igate.message.Record ;
import com.inzent.igate.tracelog.JsonConverterBean ;

public class CustomJsonConverterBean extends JsonConverterBean implements CustomMessageConstants
{
  @Override
  protected Record convertInterfaceRequest(MessageConverter messageConverter, ObjectNode objectNode) throws Exception
  {
    Record record = super.convertInterfaceRequest(messageConverter, objectNode) ;

    if (messageConverter.getAdapter().getAdapterId().startsWith(PRE_FIX_STD))
      record.setFieldValue(TID_PATH, UUID.randomUUID().toString()) ;

    return record ;
  }
}
