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
import com.inzent.igate.message.Record ;

public class LoginSessionActivity extends AbstractActivity
{
  
  public static final String DEFAULT_LOGOFF_DT = "99991231235959999";
  
  private final HibernateTemplate logTemplate;
  private final TransactionTemplate logTransactionTemplate;
  
  protected static ClusteredMap<String, MciSession> sessionMap ;

  @SuppressWarnings("unchecked")
  public LoginSessionActivity(Activity activity)
  {
    super(activity) ;
    this.logTemplate = (HibernateTemplate) Context.getApplicationContext().getBean("logTemplate") ;
    this.logTransactionTemplate = (TransactionTemplate) Context.getApplicationContext().getBean("logTransactionTemplate") ;
    sessionMap = (ClusteredMap<String, MciSession>) Context.getApplicationContext().getBean("sessionMap") ;

    // TODO Auto-generated constructor stub
  }

  @Override
  public int execute(Object... args) throws Throwable
  {
    
    AdapterParameter adapterParameter = (AdapterParameter) args[0];
    Record chlRes = (Record) args[1];
    // TODO Auto-generated method stub
    
    String logonYMS = new SimpleDateFormat("yyyyMMddHHmmssSSS").format(new Date());
    // MCISESSIONID 발급
    String mciSessionId = UUID.randomUUID().toString();
    
 
    // MCISESSION 엔티티 값 설정
    MciSession mciSession = new MciSession(mciSessionId);
    
    mciSession.setBrnCd(adapterParameter.getBranch());
    mciSession.setCmgrCd(TransactionContext.getValue(CustomHandlerConstants.CMGRCD, (java.lang.String)null));
    mciSession.setEmpId(TransactionContext.getValue(CustomHandlerConstants.TELLER_CODE, (java.lang.String)null));
    mciSession.setChannelCode(TransactionContext.getValue(CustomHandlerConstants.CHANNELID, (java.lang.String)null));
    mciSession.setChannelIp(TransactionContext.getValue(CustomHandlerConstants.IP_ADDRESS, (java.lang.String)null));
    mciSession.setMacAddress(TransactionContext.getValue(CustomHandlerConstants.MAC_ADDRESS, (java.lang.String)null));
    mciSession.setLogonYms(logonYMS);
    mciSession.setLogoffYms(DEFAULT_LOGOFF_DT);
    mciSession.setSessionDelYn("N");
    
    logTransactionTemplate.execute(new TransactionCallback<Object>() {

      @Override
      public Object doInTransaction(TransactionStatus status) {
        logTemplate.save(mciSession);
        
        return null ;
        
      }
    });
    
    // 클러스터 세션맵에 데이터 적재
    sessionMap.put2(mciSessionId, mciSession);
    
    // MCI 세션값 field 설정
    chlRes.getField("\\Header\\StandardHeader\\MCIsessionId").setValue(mciSessionId);
    
    return 0 ;
  }

  @Override
  public boolean isSingleton()
  {
    // TODO Auto-generated method stub
    return true ;
  }

}
