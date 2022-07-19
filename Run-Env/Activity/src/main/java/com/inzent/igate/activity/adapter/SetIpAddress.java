package com.inzent.igate.activity.adapter ;

import com.custom.activity.telegram.CustomHandlerConstants ;
import com.inzent.igate.adapter.AdapterParameter ;
import com.inzent.igate.context.TransactionContextBean ;
import com.inzent.igate.repository.meta.Activity ;
import com.inzent.igate.rule.activity.AbstractActivity ;

/**
 * R&D 커스텀 Activity 대외 온라인 프로토콜의 경우, 당발 / 타발 이 있음 당발 => Echo 서버의 IP로 Client가 접속
 * 하면 되나, 타발의 경우, Echo 서버가 아닌 요청을 시작한 IP를 세팅해야 함. 해당 엑티비티는 요청이 들어왔던 IPAddress를
 * 저장하고,
 * 
 * 응답을 보내는 PushResponseInt.java / SendResponseInt.java 에서 위 IPAddress를 불러와 응답을
 * 보내게 되는 로직임.
 */
public class SetIpAddress extends AbstractActivity
{
  public SetIpAddress(Activity meta)
  {
    super(meta) ;
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

    TransactionContextBean.getInstance().setValue(CustomHandlerConstants.IP_ADDRESS, adapterParameter.getRemoteAddr()) ;

    logger.debug("## adapterParameter.getRemoteAddr() [" +  adapterParameter.getRemoteAddr() + "]");
    logger.debug("## TransactionContextBean.getInstance().setValue [" +  TransactionContextBean.getInstance().getValue(CustomHandlerConstants.IP_ADDRESS, null) + "]");

    return 0 ;
  }

}
