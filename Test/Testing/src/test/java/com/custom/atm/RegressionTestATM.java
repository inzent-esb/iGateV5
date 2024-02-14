package com.custom.atm ;

import org.junit.jupiter.api.Test ;

import com.custom.RegressionUtils ;

public class RegressionTestATM extends RegressionUtils
{
  // ==========================================================================================
  // ■ FRONT 어댑터 : I_ATM
  // ■ BACK-END 어댑터 : I_COM (Bypass)
  // ■ 테스트 케이스 그룹 : TST_IF_ATM_COM [Bypass거래]
  // ■ 테스트 케이스 목록
  // TST_IF_ATM_COM_0000_01S [Bypass거래]
  // ==========================================================================================

  @Test // Bypass Success
  public void TST_IF_ATM_COM_0000_01S() throws Exception
  {
    ATM_tester("IF_ATM_COM_0000_01S.dat", "0") ;
  }
}
