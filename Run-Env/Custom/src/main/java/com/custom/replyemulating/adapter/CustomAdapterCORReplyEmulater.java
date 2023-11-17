package com.custom.replyemulating.adapter;

import org.apache.commons.logging.Log ;
import org.apache.commons.logging.LogFactory ;

import com.inzent.igate.adapter.AdapterParameter ;
import com.inzent.igate.exception.IGateException ;
import com.inzent.igate.message.MessageBeans ;
import com.inzent.igate.message.MessageConverter ;
import com.inzent.igate.message.Record ;
import com.inzent.igate.replyemulating.AdapterReplyEmulating ;
import com.inzent.igate.replyemulating.ReplyEmulater ;
import com.inzent.igate.repository.log.ReplyEmulate ;
import com.inzent.igate.repository.meta.Service ;
import com.inzent.igate.util.SerializationUtils ;

public class CustomAdapterCORReplyEmulater implements AdapterReplyEmulating
{
  protected final Log logger = LogFactory.getLog(getClass()) ;
  
  @Override
  public String getAdapterId()
  {
    String adapterId = "Adapter_COR" ;
    //adapterId = "I_COR" ;

    if(logger.isDebugEnabled())
      logger.debug("CustomAdapterCORReplyEmulater...getAdapterId : " + adapterId);

    return  adapterId ;
  }

  @Override
  public boolean makeReply(ReplyEmulater replyEmulater, AdapterParameter adapterParameter, Service service, Record request) throws IGateException
  {
    if(logger.isDebugEnabled())
    {
      logger.debug("CustomAdapterCORReplyEmulater...makeReply");
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
        
        //어댑터 I_COR은 그룹사코드 ICOR 설정
        String CmgrcdPath = "\\Header\\StandardHeader\\CmgrCd";
        if(recordRes.hasField(CmgrcdPath))
          recordRes.getField(CmgrcdPath).setValue("ICOR");

        //어댑터 I_COR은 채널유형 C0 설정
        String ChannelidPath = "\\Header\\StandardHeader\\Channelid";
        if(recordRes.hasField(ChannelidPath))
          recordRes.getField(ChannelidPath).setValue("C0");

        messageConverterRes.composeServiceResponse(service, recordRes, logger);
        
        adapterParameter.setResponseData(messageConverterRes.getComposeValue());
        return true;
      }
    }
    return false ;
  }
}
