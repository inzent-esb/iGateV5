package com.inzent.igate.activity.adapter ;

import com.inzent.igate.adapter.AdapterParameter ;
import com.inzent.igate.repository.meta.Activity ;
import com.inzent.igate.rule.activity.AbstractActivity ;

/**
 * 대외 온라인 거래 당발
 * Client 커넥터의 socket.remote.address 속성은 제거 하고, 아래 엑티비티를 통해 socket.remote.address 를 설정
 * 
 * 타발시 Client 커넥터를 이용하는데, 커넥터 속성에 socket.remote.address가 있어 ip 변경이 되지 않음.
 */
public class SetRemoteAddr extends AbstractActivity
{
  public SetRemoteAddr(Activity meta)
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
    String ipAddress = (String) args[1] ;
    
    adapterParameter.setRemoteAddr(ipAddress) ;

    return 0 ;
  }

}
