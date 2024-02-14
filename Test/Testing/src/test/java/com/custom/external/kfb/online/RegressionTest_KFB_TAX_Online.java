package com.custom.external.kfb.online ;

import java.io.IOException ;
import java.net.ServerSocket ;

import org.junit.jupiter.api.AfterAll ;
import org.junit.jupiter.api.BeforeAll ;
import org.junit.jupiter.api.Test ;

import com.custom.RegressionUtils ;

public class RegressionTest_KFB_TAX_Online extends RegressionUtils
{
  
  protected static ServerSocket serverSocket ;
  
  @BeforeAll
  public static void init()
  {
    try
    {
      serverSocket = new ServerSocket(ECHO_KFB_TAX_CONNECTOR_PORT) ;
      serverSocket.setSoTimeout(TIMEOUT) ;
    }
    catch (IOException e)
    {
      e.printStackTrace() ;
    }
  }

  @AfterAll
  public static void destory()
  {
    try
    {
      serverSocket.close() ;
    }
    catch (Exception e)
    {
      e.printStackTrace() ;
    }
  }
  // ==========================================================================================
  // ■ FRONT 어댑터 : E_KFB_O_TAX
  // ■ BACK-END 어댑터 : I_ATS
  // ■ 테스트 케이스 그룹 : TST_IF_KFB_ATS [세금우대]
  // ■ 테스트 케이스 목록
  // TST_IF_KFB_ATS_0800100_01S [개시 처리 01 정상 케이스 ]
  // ==========================================================================================
  
  @Test // 개시 처리 Success
  public void TST_IF_KFB_ATS_0800100_01S() throws Exception
  {
	JUNIT_KFB_TAX_tester(serverSocket, "IF_KFB_ATS_0800100_01S.dat", "000");
  }
}
