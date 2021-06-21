package com.custom.activity.operation ;

import com.inzent.igate.repository.log.MciSession ;
import com.inzent.igate.repository.meta.Activity ;
import com.inzent.igate.rule.activity.AbstractActivity ;

import java.text.SimpleDateFormat ;
import java.util.Date ;
import java.util.UUID ;

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
import com.inzent.igate.message.Record ;

public class LogoutSessionActivity extends AbstractActivity
{
  
  public static final String DEFAULT_LOGOFF_DT = "99991231235959999";
  
  private final HibernateTemplate logTemplate;
  private final TransactionTemplate logTransactionTemplate;
  
  protected static ClusteredMap<String, MciSession> sessionMap ;

  @SuppressWarnings("unchecked")
  public LogoutSessionActivity(Activity activity)
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
    
 // MCISESSIONID �߱�
    String mciSessionId = TransactionContext.getValue(CustomHandlerConstants.SESSIONID, (java.lang.String)null);
    // MCISESSION ��ȸ
    MciSession mciSession = logTemplate.get(MciSession.class, mciSessionId);
    
    // ���Ǿ��̵� ��ȸ�Ǵ� ���
    if(mciSession == null) {
      throw new IGateException("ELOG0001", "�ش� ������ �α��� �Ǿ����� �ʽ��ϴ�.");
    } else if (!mciSession.getLogoffYms().equals(DEFAULT_LOGOFF_DT)) {
      throw new IGateException("ELOG0001", "�ش� ������ �̹� �α׿��� �Ǿ����ϴ�.");
    }
    
    mciSession.setLogoffYms(new SimpleDateFormat("yyyyMMddHHmmssSSS").format(new Date()));
    mciSession.setSessionDelYn("Y");
    
    logTransactionTemplate.execute(new TransactionCallback<Object>() {

      @Override
      public Object doInTransaction(TransactionStatus status) {
        logTemplate.update(mciSession);
        
        return null ;
        
      }
    });
    
    sessionMap.remove2(mciSessionId);
    
    return 0;
  }

  @Override
  public boolean isSingleton()
  {
    // TODO Auto-generated method stub
    return true ;
  }

}
