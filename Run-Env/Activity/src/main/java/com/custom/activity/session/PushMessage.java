package com.custom.activity.session ;

import java.util.Objects ;

import javax.jms.Message ;

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

public class PushMessage extends AbstractActivity
{
  protected final IGateInstance iGateInstance ;
  protected final ICache<String, MciSession> sessionMap ;
  
  protected final String PUSH_TYPE = "PUSH_TYPE" ;
  protected final String PUSH_CNT = "PUSH_CNT" ;
  protected final String PUSH_LIST = "PUSH_LIST" ;
  protected final String PUSH_TARGET = "PUSH_TARGET" ;
  protected final String PUSH_MESSAGE = "PUSH_MESSAGE" ;
  
  
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
    
    String pushType = null ;
    int pushCnt = 0; 
    
    if(bizRes.hasField(PUSH_TYPE))
    	pushType = (String)bizRes.getFieldValue(PUSH_TYPE);
    
	if(bizRes.hasField(PUSH_CNT))
		pushCnt = Integer.parseInt((String)bizRes.getFieldValue(PUSH_CNT));
	    
	
	logger.info(" pushType : " + pushType);
	logger.info(" pushCnt : " + pushCnt);
	
	if(bizRes.hasField(PUSH_LIST))
	{
		bizRes.getField(PUSH_LIST).getFieldType();
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
