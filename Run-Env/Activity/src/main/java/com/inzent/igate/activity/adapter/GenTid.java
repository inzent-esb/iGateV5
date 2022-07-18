package com.inzent.igate.activity.adapter ;

import com.inzent.igate.context.TransactionContextBean ;
import com.inzent.igate.exception.IGateException ;
import com.inzent.igate.repository.meta.Activity ;
import com.inzent.igate.rule.activity.AbstractActivity ;

public class GenTid extends AbstractActivity
{
  public GenTid(Activity meta)
  {
    super(meta) ;
  }

  @Override
  public boolean isSingleton()
  {
    return true ;
  }

  /**
   * 
   * ��� �¶��� �ŷ� / �񵿱�-�񵿱ⱸ�� �ΰ��, TID�� �����ؼ� ����ϵ��� ����
   * @return
   * @throws IGateException
   * @author jkh, 2021. 12. 17.
   */
  @Override
  public int execute(Object... args) throws IGateException
  {    
//    String date17 = com.inzent.igate.util.PatternUtils.dateFormatFull.format(java.lang.System.currentTimeMillis());
//    String tid = date17 + java.util.UUID.randomUUID().toString().replace("-", "");
//    tid += "_INZT_TID" ;
    String tid = java.util.UUID.randomUUID().toString();
    logger.debug("# TID : [" + tid + "]");
    
    TransactionContextBean.getInstance().setValue("TID", tid ) ;
    
    return 0 ;
  }
}
