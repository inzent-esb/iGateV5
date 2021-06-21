package com.custom.activity.operation ;

import com.inzent.igate.repository.log.MciSession ;
import com.inzent.igate.repository.meta.Activity ;
import com.inzent.igate.rule.activity.AbstractActivity ;

import java.util.List ;

import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.query.Query;
import org.springframework.orm.hibernate5.HibernateCallback ;
import org.springframework.orm.hibernate5.HibernateTemplate;
import org.springframework.transaction.support.TransactionTemplate;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.TransactionStatus;

import com.custom.activity.telegram.CustomHandlerConstants ;
import com.inzent.igate.adapter.AdapterParameter ;
import com.inzent.igate.cluster.ClusteredMap ;
import com.inzent.igate.context.Context;
import com.inzent.igate.context.TransactionContext ;
import com.inzent.igate.exception.IGateException ;

public class IsLoginSession extends AbstractActivity
{
  
  public static final String DEFAULT_LOGOFF_DT = "99991231235959999";
  public static final String SELECT_SESSION_CHECK_QUERY = "from MciSession\r\n" + 
      "WHERE EMPID = :TELLER_CODE \r\n" + 
      "and LOGOFF_YMS = '99991231235959999' ";
  
  private static final String LOGIN_CHECK_PROPERTY_KEY = "LoginCheck";
  
  private final HibernateTemplate logTemplate;
  private final TransactionTemplate logTransactionTemplate;
  
  protected static ClusteredMap<String, MciSession> sessionMap ;

  @SuppressWarnings("unchecked")
  public IsLoginSession(Activity activity)
  {
    super(activity) ;
    this.logTemplate = (HibernateTemplate) Context.getApplicationContext().getBean("logTemplate") ;
    this.logTransactionTemplate = (TransactionTemplate) Context.getApplicationContext().getBean("logTransactionTemplate") ;
    
    sessionMap = (ClusteredMap<String, MciSession>) Context.getApplicationContext().getBean("sessionMap");
    // TODO Auto-generated constructor stub
  }

  @Override
  public int execute(Object... args) throws Throwable
  {
    
    boolean isLogin = (Boolean) args[0];
    boolean isPass = (Boolean) args[1];
    AdapterParameter adapterParameter = (AdapterParameter) args[2];
    boolean isCheck = Boolean.parseBoolean(adapterParameter.getInterface().getProperty(LOGIN_CHECK_PROPERTY_KEY, "false"));
    
    if(isPass && !isCheck) {
      logger.debug("SessionCheck Pass");
      return 0;
    }
    logger.debug("isLogin : " + isLogin);
    
    // 로그인 거래인 경우
    if(isLogin) {
      
      String empId = TransactionContext.getValue(CustomHandlerConstants.TELLER_CODE, (java.lang.String)null);
      List<MciSession> userSessionList = logTransactionTemplate.execute(new TransactionCallback<List<MciSession>>()
      {
        @Override
        public List<MciSession> doInTransaction(TransactionStatus status)
        {

          return logTemplate.executeWithNativeSession(new HibernateCallback<List<MciSession>>()
          {
            @Override
            public List<MciSession> doInHibernate(Session session) throws HibernateException
            {
              List<MciSession> list = null;
              
              Query<MciSession> query = session.createQuery(SELECT_SESSION_CHECK_QUERY, MciSession.class) ;
              query.setParameter("TELLER_CODE", empId);
              
              list = query.list();
              
              return list ;

            }
          }) ;
        }
      }) ;
      
      logger.debug("userSessionList : " + userSessionList);
      if(userSessionList != null)
        logger.debug("userSessionList.size()" + userSessionList.size() );
      if(userSessionList != null && userSessionList.size() != 0) {
        throw new IGateException("ELOG0002", "입력하신 사번은 이미 로그인 되어있습니다.");
      }
      
      return 0;

    }
    
    else {
      // MCISESSIONID 발급
      String mciSessionId = TransactionContext.getValue(CustomHandlerConstants.SESSIONID, (java.lang.String)null);
      
      // MCISESSION 조회
      //MciSession mciSession = logTemplate.get(MciSession.class, mciSessionId);
      MciSession mciSession = sessionMap.get(mciSessionId);
      
      // 세션아이디가 조회되는 경우
      if(mciSession != null) {
        String logoffDt = mciSession.getLogoffYms();
        
        // 로그인 된 세션
        if(DEFAULT_LOGOFF_DT.equals(logoffDt)) {
          return 0;
        }
        // 로그오프 된 세션
        else {
          throw new IGateException("ELOG0003", "이미 로그오프 된 세션 입니다.");
        }
      }
      // 등록되지 않은 세션.
      throw new IGateException("ELOG0001", "로그인 되지 않은 세션 입니다.");
    }
  
  }

  @Override
  public boolean isSingleton()
  {
    // TODO Auto-generated method stub
    return true ;
  }

}
