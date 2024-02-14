package com.custom.external.kftc.online ;

import org.junit.jupiter.api.Test ;

import com.custom.RegressionUtils ;

public class RegressionTest_KFTC_API_Online extends RegressionUtils
{
  // ==========================================================================================
  // ■ FRONT 어댑터 : E_KFTC_OBIP
  // ■ BACK-END 어댑터 : I_ATS
  // ■ 테스트 케이스 그룹 : TST_IF_KFTC_ATS [토큰발급및 선불목록조회 API]
  // ■ 테스트 케이스 목록
  // TST_IF_KFTC_ATS_oauth_01S [토큰발급 API 2-legged 01 정상 케이스 ]
  // TST_IF_KFTC_ATS_pays_01S [선불목록조회 API 01 정상 케이스 ]
  // ==========================================================================================
  
  @Test // 토큰 발급 Success
  public void TST_IF_KFTC_ATS_oauth_01S() throws Exception
  {
    KFTC_API_tester("IF_KFTC_ATS_oauth_01S.dat", "POST", "oauth/2.0/token", "application/x-www-form-urlencoded; charset=UTF-8", "Bearer");
  }

  @Test // 선불목록조회 Success
  public void TST_IF_KFTC_ATS_pays_01S() throws Exception
  {
    KFTC_API_tester("IF_KFTC_ATS_pays_01S.dat", "POST", "pays", "application/json; charset=UTF-8", "000");
  }
}
