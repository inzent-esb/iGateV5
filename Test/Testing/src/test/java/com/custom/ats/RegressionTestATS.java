package com.custom.ats ;

import org.junit.jupiter.api.Test ;

import com.custom.RegressionUtils ;

public class RegressionTestATS extends RegressionUtils
{
  // ==========================================================================================
  // ■ FRONT 어댑터 : I_ATS
  // ■ BACK-END 어댑터 : E_KCB_O_KFM
  // ■ 테스트 케이스 그룹 : TST_IF_ATS_KCB
  // ■ 테스트 케이스 목록
  // TST_IF_ATS_KCB_0100120_01S [KCB CIS 신용보고서 0100/120]
  // ==========================================================================================

  @Test // KCB CIS 신용보고서 0100/120 Success
  public void TST_IF_ATS_KCB_0100120_01S() throws Exception
  {
    ATS_tester("IF_ATS_KCB_0100120_01S.dat", "0") ;
  }

  // ==========================================================================================
  // ■ FRONT 어댑터 : I_ATS
  // ■ BACK-END 어댑터 : E_NICE_O_CBU
  // ■ 테스트 케이스 그룹 : TST_IF_ATS_NICE
  // ■ 테스트 케이스 목록
  // TST_IF_ATS_NIC_02001F003_01S [NICE 개인 MyReport 0200/1F003]
  // ==========================================================================================

  @Test // NICE 개인 MyReport 0200/1F003 Success
  public void TST_IF_ATS_NIC_02001F003_01S() throws Exception
  {
    ATS_tester("IF_ATS_NIC_02001F003_01S.dat", "0") ;
  }

  // ==========================================================================================
  // ■ FRONT 어댑터 : I_ATS
  // ■ BACK-END 어댑터 : E_KFB_O_TAX
  // ■ 테스트 케이스 그룹 : TST_IF_ATS_KFB
  // ■ 테스트 케이스 목록
  // TST_IF_ATS_KFB_0200200_01S [KFB 세금우대정보 조회 0200/200]
  // ==========================================================================================
  
  @Test // KFB 세금우대정보 조회 0200/200 Success
  public void TST_IF_ATS_KFB_0200200_01S() throws Exception
  {
    ATS_tester("IF_ATS_KFB_0200200_01S.dat", "0") ;
  }

  // ==========================================================================================
  // ■ FRONT 어댑터 : I_ATS
  // ■ BACK-END 어댑터 : E_KCI_O_CRI
  // ■ 테스트 케이스 그룹 : TST_IF_ATS_KCI
  // ■ 테스트 케이스 목록
  // TST_IF_ATS_KCI_0200200_01S [KCI 금융신용도판단및공공정보조회 0200/200]
  // ==========================================================================================
  
  @Test // KCI 금융신용도판단및공공정보조회 0200/200 Success
  public void TST_IF_ATS_KCI_0200200_01S() throws Exception
  {
    ATS_tester("IF_ATS_KCI_0200200_01S.dat", "0") ;
  }
}
