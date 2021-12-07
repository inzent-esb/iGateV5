package com.custom.activity.session ;

import java.util.Collections ;
import java.util.List ;
import java.util.Objects ;
import java.util.UUID ;

import org.springframework.dao.DataAccessException ;
import org.springframework.transaction.TransactionException ;
import org.springframework.transaction.TransactionStatus ;
import org.springframework.transaction.support.TransactionCallback ;
import org.springframework.transaction.support.TransactionTemplate ;

import com.custom.activity.telegram.CustomHandlerConstants ;
import com.inzent.igate.adapter.AdapterParameter ;
import com.inzent.igate.cluster.ClusteredMap ;
import com.inzent.igate.context.Context ;
import com.inzent.igate.context.IGateInstance ;
import com.inzent.igate.exception.ExceptionManager ;
import com.inzent.igate.exception.IGateException ;
import com.inzent.igate.message.Record ;
import com.inzent.igate.repository.log.MciSession ;
import com.inzent.igate.repository.meta.Activity ;
import com.inzent.igate.rule.activity.AbstractActivity ;
import com.inzent.igate.util.PatternUtils ;
import com.inzent.imanager.dao.ExtendedHibernateTemplate ;

public class Login extends AbstractActivity
{
  protected final ExtendedHibernateTemplate logTemplate ;
  protected final TransactionTemplate logTransactionTemplate ;
  protected final ClusteredMap<String, MciSession> sessionMap ;

  @SuppressWarnings("unchecked")
  public Login(Activity activity)
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
  public int execute(Object... args) throws Exception
  {
    AdapterParameter adapterParameter = (AdapterParameter) args[0] ;
    Record request = (Record) args[1] ;
    Record response = (Record) args[2] ;

    if (isLoginSucceed(response))
    {
      MciSession mciSession = createMciSession(adapterParameter, request, response) ;
      List<MciSession> previous = Collections.emptyList() ;

      try
      {
        List<MciSession> previousLocal = findMciSession(mciSession) ;
        previous = previousLocal ;

        logTransactionTemplate.execute(new TransactionCallback<Object>()
        {
          @Override
          public Object doInTransaction(TransactionStatus status)
          {
            logTemplate.save(mciSession) ;

            for (MciSession pre : previousLocal)
              logTemplate.updateByNamedQueryAndNamedParam(MciSession.UPDATE_LOGOUT_FORCE, "mciSessionId", pre.getMciSessionId()) ;

            return null ;
          }
        }) ;
      }
      catch (DataAccessException | TransactionException e) 
      {
        if (logger.isWarnEnabled())
          logger.warn(e.getMessage(), e) ;

        ExceptionManager.handleException(e) ;
      }
      finally
      {
        sessionMap.put2(mciSession.getMciSessionId(), mciSession) ;

        for (MciSession pre : previous)
          sessionMap.remove2(pre.getMciSessionId()) ;

        applyMciSession(response, mciSession) ;
      }
    }

    return 0 ;
  }

  protected boolean isLoginSucceed(Record response) throws IGateException
  {
    return Objects.equals("0", response.getFieldValue(CustomHandlerConstants.RESPONSE_CODE_PATH)) ;
  }

  protected MciSession createMciSession(AdapterParameter adapterParameter, Record request, Record response) throws IGateException
  {
    MciSession mciSession = new MciSession(UUID.randomUUID().toString()) ;
    mciSession.setMciInstanceId(IGateInstance.getInstance().getInstanceId()) ;
    mciSession.setCmgrCd(response.getFieldValue(CustomHandlerConstants.CMGRCD_PATH).toString()) ;
    mciSession.setChannelCode(response.getFieldValue(CustomHandlerConstants.CHANNELID_PATH).toString()) ;
    mciSession.setChannelIp(adapterParameter.getRemoteAddr()) ;
    mciSession.setMacAddress(request.getFieldValue(CustomHandlerConstants.MAC_ADDRESS_PATH).toString()) ;
    mciSession.setBrnCd(request.getFieldValue(CustomHandlerConstants.BRANCH_PATH).toString()) ;
    mciSession.setEmpId(request.getFieldValue(CustomHandlerConstants.TELLER_CODE_PATH).toString()) ;
    mciSession.setLogonYms(PatternUtils.dateFormatConverter.format(System.currentTimeMillis())) ;
    mciSession.setLogoffYms(null) ;
    mciSession.setSessionDelYn("N") ;

    return mciSession ;
  }

  @SuppressWarnings("unchecked")
  protected List<MciSession> findMciSession(MciSession mciSession)
  {
    return (List<MciSession>) logTemplate.findByNamedQueryAndNamedParam(MciSession.SELECT_LOGINED, "empId", mciSession.getEmpId()) ;
  }

  protected void applyMciSession(Record response, MciSession mciSession) throws IGateException
  {
    response.setFieldValue(CustomHandlerConstants.SESSIONID_PATH, mciSession.getMciSessionId()) ;
  }
}
