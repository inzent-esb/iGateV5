package com.custom.activity.session ;

import java.util.ArrayList;
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
import com.inzent.igate.util.Numeric;

public class PushMessage extends AbstractActivity  implements CustomHandlerConstants
{
  protected final IGateInstance iGateInstance ;
  protected final ICache<String, MciSession> sessionMap ;
  
  protected final String PUSH_PATH = Record.NAME_SEPARATOR_STRING + "%s" + Record.NAME_SEPARATOR_STRING + DATA_BODY_ID + Record.NAME_SEPARATOR_STRING +"%s" ; 
		  
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
    
    
    //=========================================================================================================
    String pushType = null ;
    int pushCnt = 0;
    ArrayList<String> TargetList = new ArrayList<String>();
    
    //=========================================================================================================
    String path = String.format(PUSH_PATH, adapterParameter.getService().getServiceId()+"_0", PUSH_TYPE);
    logger.info(" pushType path : " + path);
    if(bizRes.hasField(path))
    	pushType = (String)bizRes.getFieldValue(path);
    logger.info(" pushType : " + pushType);

    //=========================================================================================================
    path = String.format(PUSH_PATH, adapterParameter.getService().getServiceId()+"_0", PUSH_CNT);
    logger.info(" pushCnt path : " + path);
    
	if(bizRes.hasField(path))		
	{
		Numeric Cnt =(Numeric)bizRes.getFieldValue(path);
		pushCnt = Cnt.intValue();
	}
	logger.info(" pushCnt : " + pushCnt );
	
    //=========================================================================================================
	path = String.format(PUSH_PATH, adapterParameter.getService().getServiceId()+"_0", PUSH_LIST);
	logger.info(" PUSH_LIST path : " + path);
	if(bizRes.hasField(path))
	{
		bizRes.getField(path).getFieldType();
		logger.info(" PUSH_LIST type : " + bizRes.getField(path).getFieldType());
		
		if(pushCnt>0)
		{
			RecordImpl list = (RecordImpl)bizRes.getField(path);
			int index = 0; 
			while(index < pushCnt )
			{
				logger.info(String.format( "[%d] %s", index,list.getField(index).getValue() ));
				TargetList.add(((String)list.getField(index).getValue()).trim());
				index ++;
			}			
		}		
	}
    //=========================================================================================================
	
	

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
