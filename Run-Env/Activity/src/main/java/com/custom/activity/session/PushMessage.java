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
	protected final String PUSH_TYPE_All = "A" ;
	protected final String PUSH_TYPE_GROUP = "G" ;
	protected final String PUSH_TYPE_TERLLER = "T" ;

	protected final String PUSH_CNT = "PUSH_CNT" ;
	protected final String PUSH_LIST = "PUSH_LIST" ;  
	protected final String PUSH_TARGET = "PUSH_TARGET" ;
	protected final String PUSH_TARGET_PATH = Record.NAME_SEPARATOR_STRING + "%s" + Record.NAME_SEPARATOR_STRING + DATA_BODY_ID + Record.NAME_SEPARATOR_STRING + PUSH_LIST + "[%d]" + Record.NAME_SEPARATOR_STRING + PUSH_TARGET ;  

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
		ArrayList<String> pushTargetList = new ArrayList<String>();
		String pushType = null ;
		int pushCnt = 0;

		//=========================================================================================================
		String path = String.format(PUSH_PATH, adapterParameter.getService().getServiceId()+"_0", PUSH_TYPE);
		if(bizRes.hasField(path))
			pushType = (String)bizRes.getFieldValue(path);
		//===============
		path = String.format(PUSH_PATH, adapterParameter.getService().getServiceId()+"_0", PUSH_CNT);
		if(bizRes.hasField(path))		
		{
			Numeric Cnt =(Numeric)bizRes.getFieldValue(path);
			pushCnt = Cnt.intValue();
		}
		//===============
		path = String.format(PUSH_PATH, adapterParameter.getService().getServiceId()+"_0", PUSH_LIST);
		if(bizRes.hasField(path))
		{
			bizRes.getField(path).getFieldType();

			if(pushCnt > 0)
			{
				int index = 0; 
				while(index < pushCnt )
				{
					path = String.format(PUSH_TARGET_PATH, adapterParameter.getService().getServiceId()+"_0", index);
					pushTargetList.add(((String)bizRes.getFieldValue(path)).trim());
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
			
			//if (isValid(adapterParameter, response, mciSession))
			if (isValid(adapterParameter, response, pushType, pushTargetList, mciSession))
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

	protected boolean isValid(AdapterParameter adapterParameter, Record response, String pushType, ArrayList<String> pushTargetList,  MciSession mciSession)
	{
		//로그인 상태가 아니면 보내지 않음 
		if (!(Objects.equals("N", mciSession.getSessionDelYn()) || null == mciSession.getLogoffYms()))
			return false ;
			
		//인스턴스 다른 경우 
		if (!Objects.equals(iGateInstance.getInstanceId(), mciSession.getMciInstanceId()))
			return false ;

		//전체 push
		if(pushType.trim().equals(PUSH_TYPE_All))
		{
			return true ;
		}
		//그룹 push 지점번호 동일
		else if(pushType.trim().equals(PUSH_TYPE_GROUP))
	    {
	    	if(!mciSession.getBrnCd().trim().isEmpty())
	    		return pushTargetList.contains(mciSession.getBrnCd().trim());
	    }
		//개별 push 직원번호 동일
	    else if(pushType.trim().equals(PUSH_TYPE_TERLLER))
	    {
	    	if(!mciSession.getEmpId().trim().isEmpty())
	    		return pushTargetList.contains(mciSession.getEmpId().trim());	
	    }
		
		return false ;
	}
}
