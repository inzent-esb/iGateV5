package com.custom.activity.session ;

import java.util.Objects ;

import javax.jms.Message ;

import com.custom.activity.telegram.CustomHandlerConstants;
import com.inzent.igate.adapter.AdapterManagerBean ;
import com.inzent.igate.adapter.AdapterParameter ;
import com.inzent.igate.cache.ICache;
import com.inzent.igate.context.Context ;
import com.inzent.igate.context.IGateInstance ;
import com.inzent.igate.message.MessageBeans ;
import com.inzent.igate.message.MessageConverter ;
import com.inzent.igate.message.Record ;
import com.inzent.igate.message.RecordImpl ;
import com.inzent.igate.repository.log.MciSession ;
import com.inzent.igate.repository.meta.Activity ;
import com.inzent.igate.repository.meta.Adapter ;
import com.inzent.igate.rule.activity.AbstractActivity ;

public class PushMessage extends AbstractActivity  implements CustomHandlerConstants
{
  protected final IGateInstance iGateInstance ;
  protected final ICache<String, MciSession> sessionMap ;
  
  protected final String PUSH_TYPE = "PUSH_TYPE" ;
  protected final String PUSH_TYPE_PATH = Record.NAME_SEPARATOR_STRING + DATA_BODY_ID + Record.NAME_SEPARATOR_STRING + PUSH_TYPE ; 
		  
		  
  protected final String PUSH_CNT = "PUSH_CNT" ;
  protected final String PUSH_CNT_PATH = Record.NAME_SEPARATOR_STRING + DATA_BODY_ID + Record.NAME_SEPARATOR_STRING + PUSH_CNT ;
  
  protected final String PUSH_LIST = "PUSH_LIST" ;  
  protected final String PUSH_LIST_PATH = Record.NAME_SEPARATOR_STRING + DATA_BODY_ID + Record.NAME_SEPARATOR_STRING + PUSH_LIST ;
  
  protected final String PUSH_TARGET = "PUSH_TARGET" ;
  
  protected final String PUSH_MESSAGE = "PUSH_MESSAGE" ;
  protected final String PUSH_MESSAGE_PATH = Record.NAME_SEPARATOR_STRING + DATA_BODY_ID + Record.NAME_SEPARATOR_STRING + PUSH_MESSAGE ;
  
  
  @SuppressWarnings("unchecked")
  public PushMessage(Activity activity)
  {
    super(activity) ;

    iGateInstance = IGateInstance.getInstance() ;
    sessionMap = (ICache<String, MciSession>) Context.getApplicationContext().getBean("sessionMap") ;
  }

  @Override
  public boolean isSingleton()
  {
    return true ;
  }

  @Override
  public int execute(Object... args) throws Exception
  {
    AdapterParameter adapterParameter = (AdapterParameter) args[0] ;
    RecordImpl response = (RecordImpl) args[1] ;
    RecordImpl bizRes = (RecordImpl) args[2] ;
    logger.info(" bizRes : " + bizRes);
    String pushType = null ;
    int pushCnt = 0; 
    
    String path = Record.NAME_SEPARATOR_STRING + String.format("%s_0%s", adapterParameter.getService().getServiceId(),PUSH_TYPE_PATH);
    logger.info(" path : " + path);
    if(bizRes.hasField(path))
    	pushType = (String)bizRes.getFieldValue(path);
    logger.info("0 pushType : " + pushType);

    if(bizRes.hasField(PUSH_CNT_PATH))
    	pushType = (String)bizRes.getFieldValue(PUSH_CNT_PATH);
    logger.info("1 pushType : " + pushType);
    
    
    if(bizRes.hasField(PUSH_TYPE))
    	pushType = (String)bizRes.getFieldValue(PUSH_TYPE);
    logger.info("2 pushType : " + pushType);
    

    
    
    path = String.format("%s_0%s", adapterParameter.getService().getServiceId(),PUSH_CNT_PATH);
    logger.info(" path : " + path);
	if(bizRes.hasField(path))
		pushCnt = Integer.parseInt((String)bizRes.getFieldValue(path));
	    
	
	logger.info(" pushType : " + pushType);
	logger.info(" pushCnt : " + pushCnt);
	

	path = String.format("%s_0%s", adapterParameter.getService().getServiceId(),PUSH_LIST_PATH);
	logger.info(" path : " + path);
	if(bizRes.hasField(path))
	{
		bizRes.getField(path).getFieldType();
		logger.info(" PUSH_LIST type : " + pushType);
	}
    

    MessageConverter messageConverter = MessageBeans.SINGLETON.createMessageConverter(MessageBeans.SINGLETON.adapterManager.get(response.getAdapterId()), null) ;
    messageConverter.compose(response, logger) ;

    for (String mciSessionId : sessionMap.keys())
    {
      MciSession mciSession = sessionMap.get(mciSessionId) ;
      if (isValid(adapterParameter, response, mciSession))
      {
        AdapterParameter adapterParameterPush = new AdapterParameter() ;
        adapterParameterPush.setAdapterId(response.getAdapterId()) ;
        adapterParameterPush.setAdapterEvent(Adapter.RESPONSE_WRITE) ;
        adapterParameterPush.setRemoteAddr(mciSession.getChannelIp()) ;
        adapterParameterPush.setResponseData(messageConverter.getComposeValue()) ;
        adapterParameterPush.setResponseSync(false) ;

        AdapterManagerBean.push(adapterParameterPush, Message.DEFAULT_PRIORITY) ;
      }
    }

    return 0 ;
  }

  protected boolean isValid(AdapterParameter adapterParameter, Record response, MciSession mciSession)
  {
    if (!Objects.equals(iGateInstance.getInstanceId(), mciSession.getMciInstanceId()))
      return false ;

    // TODO 메시지 발송 조건 검사

    return true ;
  }
}
