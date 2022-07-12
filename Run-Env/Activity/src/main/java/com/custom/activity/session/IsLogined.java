package com.custom.activity.session ;

import java.util.Objects ;

import com.custom.activity.telegram.CustomHandlerConstants ;
import com.inzent.igate.adapter.AdapterParameter ;
import com.inzent.igate.cache.ICache;
import com.inzent.igate.context.Context ;
import com.inzent.igate.exception.IGateException ;
import com.inzent.igate.message.Record ;
import com.inzent.igate.repository.log.MciSession ;
import com.inzent.igate.repository.meta.Activity ;
import com.inzent.igate.rule.activity.AbstractActivity ;

public class IsLogined extends AbstractActivity
{
  public static final String LOGIN_CHECK_PROPERTY_KEY = "LoginCheck" ;

  protected final ICache<String, MciSession> sessionMap ;

  @SuppressWarnings("unchecked")
  public IsLogined(Activity activity)
  {
    super(activity) ;

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
    Record request = (Record) args[1] ;

    if (Boolean.parseBoolean(adapterParameter.getInterface().getProperty(LOGIN_CHECK_PROPERTY_KEY, "true")) && !isValid(adapterParameter, request))
      throw new IGateException("ELOG0001", "로그인 되지 않은 세션 입니다.") ;

    return 0 ;
  }

  protected boolean isValid(AdapterParameter adapterParameter, Record request) throws IGateException
  {
    MciSession mciSession = sessionMap.get(request.getFieldValue(CustomHandlerConstants.SESSIONID_PATH).toString()) ;
    if (null == mciSession)
      return false ;

    return Objects.equals(request.getFieldValue(CustomHandlerConstants.TELLER_CODE_PATH), mciSession.getEmpId()) ;
  }
}
