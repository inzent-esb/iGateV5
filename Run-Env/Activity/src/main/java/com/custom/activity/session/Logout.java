package com.custom.activity.session ;

import java.util.Objects ;

import org.springframework.dao.DataAccessException ;
import org.springframework.transaction.TransactionException ;
import org.springframework.transaction.TransactionStatus ;
import org.springframework.transaction.support.TransactionCallback ;
import org.springframework.transaction.support.TransactionTemplate ;

import com.custom.activity.telegram.CustomHandlerConstants ;
import com.inzent.igate.adapter.AdapterParameter ;
import com.inzent.igate.cluster.ClusteredMap ;
import com.inzent.igate.context.Context ;
import com.inzent.igate.exception.ExceptionManager ;
import com.inzent.igate.exception.IGateException ;
import com.inzent.igate.message.Record ;
import com.inzent.igate.repository.log.MciSession ;
import com.inzent.igate.repository.meta.Activity ;
import com.inzent.igate.rule.activity.AbstractActivity ;
import com.inzent.igate.util.PatternUtils ;
import com.inzent.imanager.dao.ExtendedHibernateTemplate ;

public class Logout extends AbstractActivity
{
  protected final ExtendedHibernateTemplate logTemplate ;
  protected final TransactionTemplate logTransactionTemplate ;
  protected final ClusteredMap<String, MciSession> sessionMap ;

  @SuppressWarnings("unchecked")
  public Logout(Activity activity)
  {
    super(activity) ;

    logTemplate = (ExtendedHibernateTemplate) Context.getApplicationContext().getBean("logTemplate") ;
    logTransactionTemplate = (TransactionTemplate) Context.getApplicationContext().getBean("logTransactionTemplate") ;
    sessionMap = (ClusteredMap<String, MciSession>) Context.getApplicationContext().getBean("sessionMap") ;
  }

  @Override
  public boolean isSingleton()
  {
    return true ;
  }

  @Override
  public int execute(Object... args) throws Throwable
  {
    AdapterParameter adapterParameter = (AdapterParameter) args[0] ;
    Record request = (Record) args[1] ;

    String mciSessionId = getMciSessionId(request) ;
    if (isValid(adapterParameter, request, mciSessionId))
      try
      {
        MciSession mciSession = logTemplate.get(MciSession.class, mciSessionId) ;
        if (isLogined(mciSession))
        {
          logTransactionTemplate.execute(new TransactionCallback<Object>()
          {
            @Override
            public Object doInTransaction(TransactionStatus status)
            {
              logTemplate.updateByNamedQueryAndNamedParam(MciSession.UPDATE_LOGOUT_NORMAL,
                  new String[] { "logoffYms", "mciSessionId" },
                  new Object[] { PatternUtils.dateFormatConverter.format(System.currentTimeMillis()), mciSession.getMciSessionId() }) ;

              return null ;
            }
          }) ;
        }
      }
      catch (DataAccessException | TransactionException e)
      {
        if (logger.isWarnEnabled())
          logger.warn(e.getMessage(), e) ;

        ExceptionManager.handleException(e) ;
      }
      finally
      {
        sessionMap.remove2(mciSessionId) ;
      }

    return 0 ;
  }

  protected String getMciSessionId(Record request) throws IGateException
  {
    return request.getFieldValue(CustomHandlerConstants.SESSIONID_PATH).toString() ;
  }

  protected boolean isValid(AdapterParameter adapterParameter, Record request, String mciSessionId) throws IGateException
  {
    MciSession mciSession = sessionMap.get(mciSessionId) ;
    if (null == mciSession)
      return true ;

    return Objects.equals(request.getFieldValue(CustomHandlerConstants.TELLER_CODE_PATH), mciSession.getEmpId()) ;
  }

  protected boolean isLogined(MciSession mciSession) throws IGateException
  {
    return Objects.equals("N", mciSession.getSessionDelYn()) || null == mciSession.getLogoffYms() ;
  }
}
