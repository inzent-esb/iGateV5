package com.custom.replyemulating.service;

import org.apache.commons.logging.Log ;
import org.apache.commons.logging.LogFactory ;

import com.inzent.igate.adapter.AdapterParameter ;
import com.inzent.igate.exception.IGateException ;
import com.inzent.igate.message.MessageBeans ;
import com.inzent.igate.message.MessageConverter ;
import com.inzent.igate.message.Record ;
import com.inzent.igate.replyemulating.ReplyEmulater ;
import com.inzent.igate.replyemulating.ServiceReplyEmulating ;
import com.inzent.igate.repository.log.ReplyEmulate ;
import com.inzent.igate.repository.meta.Service ;
import com.inzent.igate.util.SerializationUtils ;

public class CustomService001ReplyEmulater implements ServiceReplyEmulating
{
  protected final Log logger = LogFactory.getLog(getClass()) ;

  @Override
  public String getServiceId()
  {
    String serviceId = "Service001" ;
   //serviceId = "SV_COR_0030" ;

    if(logger.isDebugEnabled())
      logger.debug("CustomService001ReplyEmulater...getServiceId : " + serviceId );

    return serviceId;
  }


  @Override
  public boolean makeReply(ReplyEmulater replyEmulater, AdapterParameter adapterParameter, Service service, Record request) throws IGateException
  {
    if(logger.isDebugEnabled())      
    {
      logger.debug("CustomService001ReplyEmulater...makeReply");
      logger.debug(" ### replyEmulater : "+ replyEmulater );
      logger.debug(" ### adapterParameter : "+ adapterParameter);
      logger.debug(" ### service : "+ service);
      logger.debug(" ### request : "+ request);
    }
    
    ReplyEmulate replyEmulate = null;
    //ReplyEmulate replyEmulate = ReplyEmulater.getReplyEmulate(service);
    //ReplyEmulate replyEmulate = ReplyEmulater.getReplyEmulate(service.getServiceId());
    //ReplyEmulate replyEmulate = ReplyEmulater.getReplyEmulate(service.getServiceId(), service.getProperty(Service.PROPT_EMULATE_REPLY_ID, "Normal"));
    
    logger.debug(" ### replyEmulate : " + replyEmulate );

    if (null != replyEmulate)
    {
      adapterParameter.setResponseData(SerializationUtils.deserialize(replyEmulate.getReplyData())) ;
      
      MessageConverter messageConverterReq = MessageBeans.SINGLETON.createMessageConverter(adapterParameter.getAdapter(), adapterParameter.getRequestData()) ;
      MessageConverter messageConverterRes = MessageBeans.SINGLETON.createMessageConverter(adapterParameter.getAdapter(), adapterParameter.getResponseData()) ;
      if(messageConverterReq != null && messageConverterRes != null )
      {
        Record recordReq = messageConverterReq.parseServiceRequest(service, logger);
        Record recordRes = messageConverterRes.parseServiceResponse(service, logger);
        
        //GUID 동일하게 처리 
        String GuidPath = "\\Header\\StandardHeader\\Guid";
        if(recordRes.hasField(GuidPath))
          recordRes.getField(GuidPath).setValue(recordReq.getField(GuidPath).getValue());

        // 서비스 SV_COR_0030는 요청응답 구분은 R로 고정 설정
        String RequestModePath = "\\Header\\StandardHeader\\RequestMode";
        if(recordRes.hasField(RequestModePath))
          recordRes.getField(RequestModePath).setValue("R");
        
        // 서비스 SV_COR_0030는 응답코드  3으로 고정 설정
        String ResponseCodePath = "\\Header\\StandardHeader\\ResponseCode";
        if(recordRes.hasField(ResponseCodePath))
          recordRes.getField(ResponseCodePath).setValue("3");
        
        messageConverterRes.composeServiceResponse(service, recordRes, logger);
        
        adapterParameter.setResponseData(messageConverterRes.getComposeValue());
        return true;
      }
    }
    return false ;
  }

}
