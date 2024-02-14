package com.custom.rest ;

import org.junit.jupiter.api.Test ;

import com.custom.RegressionUtils ;

public class RegressionTestREST extends RegressionUtils
{
  // ==========================================================================================
  // ■ FRONT 어댑터 : I_MYD
  // ■ BACK-END 어댑터 : I_PAY
  // ■ 테스트 케이스 그룹 : TST_IF_MYD_PAY [고객정보]
  // ■ 테스트 케이스 목록
  // TST_IF_MYD_PAY_0150_01S [결재내역 조회 01 정상 케이스 ]
  // TST_IF_MYD_PAY_0151_01S [결재내역 등록 01 정상 케이스 ]
  // TST_IF_MYD_PAY_0151_02F [결재내역 등록 02 실패 케이스 ] - 중복등록 Duplicate Error
  // TST_IF_MYD_PAY_0152_01S [결재내역 수정 01 정상 케이스 ]
  // TST_IF_MYD_PAY_0153_01S [결재내역 삭제 01 정상 케이스 ]
  // ==========================================================================================
  
  @Test // select Success
  public void TST_IF_MYD_PAY_0150_01S() throws Exception
  {
    REST_tester("IF_MYD_PAY_0150_01S.dat", "GET", "mydata/payment", "0");
  }

  @Test // insert Success
  public void TST_IF_MYD_PAY_0151_01S() throws Exception
  {
    REST_tester("IF_MYD_PAY_0151_01S.dat", "PUT", "mydata/payment", "0");
  }

  @Test // insert Fail
  public void TST_IF_MYD_PAY_0151_02F() throws Exception
  {
    REST_tester("IF_MYD_PAY_0151_02F.dat", "PUT", "mydata/payment", "1");
  }

  @Test // update Success
  public void TST_IF_MYD_PAY_0152_01S() throws Exception
  {
    REST_tester("IF_MYD_PAY_0152_01S.dat", "POST", "mydata/payment", "0") ;
  }

  @Test // delete Success
  public void TST_IF_MYD_PAY_0153_01S() throws Exception
  {
    REST_tester("IF_MYD_PAY_0153_01S.dat", "DELETE", "mydata/payment", "0");
  }
  
//==========================================================================================
 // ■ FRONT 어댑터 : I_MYD
 // ■ BACK-END 어댑터 : I_COM, I_EDW
 // ■ 테스트 케이스 그룹 : REST - Legacy
 // ■ 테스트 케이스 목록
 // TST_IF_MYD_COM_0010_01S [신용등급 조회 01 정상 케이스 ]
 // TST_IF_MYD_HUB_0020_01S [신용등급 조회 01 정상 케이스 ]
 // ==========================================================================================
  
  @Test 
  public void TST_IF_MYD_COM_0010_01S() throws Exception
  {
    //INB_tester("IF_INB_COM_0013_01S.dat", "0") ;
    REST_tester("IF_MYD_COM_0010_01S.dat", "GET", "mydata/userinfo", "0");
  }
  
  @Test 
  public void TST_IF_MYD_HUB_0020_01S() throws Exception
  {
    //INB_tester("IF_INB_COM_0013_01S.dat", "0") ;
    REST_tester("IF_MYD_HUB_0020_01S.dat", "POST", "mydata/marketing", "0");
  }
  
//==========================================================================================
 // ■ FRONT 어댑터 : I_TER
 // ■ BACK-END 어댑터 : I_PAY
 // ■ 테스트 케이스 그룹 : Legacy - REST
 // ■ 테스트 케이스 목록
 // TST_IF_TER_PAY_0150_01S [신용등급 조회 01 정상 케이스 ]
 // ==========================================================================================
  
  @Test 
  public void TST_IF_TER_PAY_0150_01S() throws Exception
  {
    TER_tester("IF_TER_PAY_0150_01S.dat", "0") ;
  }
}
