package com.custom.ter ;

import org.junit.jupiter.api.Test ;

import com.custom.RegressionUtils ;
import com.fasterxml.jackson.databind.JsonNode ;

public class RegressionTestTER extends RegressionUtils
{
  @Test
  public void TST_IF_TER_MCA_0000_00S() throws Exception
  {
    JsonNode jsonNode = TER_tester("IF_TER_COM_0098_01S.dat", "0") ;

    mcaSessionId = jsonNode.path(HEADER_ID).path(STANDARD_HEADER_ID).path(MCA_ESSION_ID_FIELD).textValue() ;
    tellerCode = jsonNode.path(HEADER_ID).path(STANDARD_HEADER_ID).path(TELLER_CODE_FIELD).textValue() ;
  }

  // ==========================================================================================
  // ■ FRONT 어댑터 : I_TER
  // ■ BACK-END 어댑터 : I_MCA (로컬거래)
  // ■ 테스트 케이스 그룹 : TST_IF_TER_MCA [공지사항]
  // ■ 테스트 케이스 목록
  // TST_IF_TER_MCA_0001_01S [공지사항 조회 01 정상 케이스 ]
  // TST_IF_TER_MCA_0002_01S [공지사항 등록 01 정상 케이스 ]
  // TST_IF_TER_MCA_0002_02F [공지사항 등록 02 실패 케이스 ] - 중복등록 Duplicate Error
  // TST_IF_TER_MCA_0003_01S [공지사항 수정 01 정상 케이스 ]
  // TST_IF_TER_MCA_0003_02F [공지사항 수정 02 실패 케이스 ] - 조건에 해당하는 항목 미존재
  // TST_IF_TER_MCA_0004_01S [공지사항 삭제 01 정상 케이스 ]
  // TST_IF_TER_MCA_0004_02F [공지사항 삭제 02 실패 케이스 ] - 조건에 해당하는 항목 미존재
  // ==========================================================================================

  @Test // select Success
  public void TST_IF_TER_MCA_0001_01S() throws Exception
  {
    TER_tester("IF_TER_MCA_0001_01S.dat", "0") ;
  }

  @Test // insert Success
  public void TST_IF_TER_MCA_0002_01S() throws Exception
  {
    TER_tester("IF_TER_MCA_0002_01S.dat", "0") ;
  }

  @Test // insert Fail
  public void TST_IF_TER_MCA_0002_02F() throws Exception
  {
    TER_tester("IF_TER_MCA_0002_02F.dat", "2") ;
  }

  @Test // update Success
  public void TST_IF_TER_MCA_0003_01S() throws Exception
  {
    TER_tester("IF_TER_MCA_0003_01S.dat", "0") ;
  }

  @Test // update Fail
  public void TST_IF_TER_MCA_0003_02F() throws Exception
  {
    TER_tester("IF_TER_MCA_0003_02F.dat", "2") ;
  }

  @Test // delete Success
  public void TST_IF_TER_MCA_0004_01S() throws Exception
  {
    TER_tester("IF_TER_MCA_0004_01S.dat", "0") ;
  }

  @Test // delete Fail
  public void TST_IF_TER_MCA_0004_02F() throws Exception
  {
    TER_tester("IF_TER_MCA_0004_02F.dat", "2") ;
  }

  // ==========================================================================================
  // ■ FRONT 어댑터 : I_TER
  // ■ BACK-END 어댑터 : I_HUB
  // ■ 테스트 케이스 그룹 : TST_IF_TER_HUB [마케팅대상]
  // ■ 테스트 케이스 목록
  // TST_IF_TER_HUB_0020_01S [마케팅대상 조회 01 정상 케이스 ]
  // TST_IF_TER_HUB_0021_01S [마케팅대상 등록 01 정상 케이스 ]
  // TST_IF_TER_HUB_0021_02F [마케팅대상 등록 02 실패 케이스 ] - 중복등록 Duplicate Error
  // TST_IF_TER_HUB_0022_01S [마케팅대상 수정 01 정상 케이스 ]
  // TST_IF_TER_HUB_0023_01S [마케팅대상 삭제 01 정상 케이스 ]
  // ==========================================================================================

  @Test // select Success
  public void TST_IF_TER_HUB_0020_01S() throws Exception
  {
    TER_tester("IF_TER_HUB_0020_01S.dat", "0") ;
  }

  @Test // insert Success
  public void TST_IF_TER_HUB_0021_01S() throws Exception
  {
    TER_tester("IF_TER_HUB_0021_01S.dat", "0") ;
  }

  @Test // insert Fail
  public void TST_IF_TER_HUB_0021_02F() throws Exception
  {
    TER_tester("IF_TER_HUB_0021_02F.dat", "1") ;
  }

  @Test // update Success
  public void TST_IF_TER_HUB_0022_01S() throws Exception
  {
    TER_tester("IF_TER_HUB_0022_01S.dat", "0") ;
  }

  @Test // delete Success
  public void TST_IF_TER_HUB_0023_01S() throws Exception
  {
    TER_tester("IF_TER_HUB_0023_01S.dat", "0") ;
  }

  // ==========================================================================================
  // ■ FRONT 어댑터 : I_TER
  // ■ BACK-END 어댑터 : I_COM
  // ■ 테스트 케이스 그룹 : TST_IF_TER_COM [고객정보]
  // ■ 테스트 케이스 목록
  // TST_IF_TER_COM_0010_01S [고객정보 조회 01 정상 케이스 ]
  // TST_IF_TER_COM_0011_01S [고객정보 등록 01 정상 케이스 ]
  // TST_IF_TER_COM_0011_02F [고객정보 등록 02 실패 케이스 ] - 중복등록 Duplicate Error
  // TST_IF_TER_COM_0012_01S [고객정보 수정 01 정상 케이스 ]
  // TST_IF_TER_COM_0013_01S [고객정보 삭제 01 정상 케이스 ]
  // ==========================================================================================

  @Test // select Success
  public void TST_IF_TER_COM_0010_01S() throws Exception
  {
    TER_tester("IF_TER_COM_0010_01S.dat", "0") ;
  }

  @Test // insert Success
  public void TST_IF_TER_COM_0011_01S() throws Exception
  {
    TER_tester("IF_TER_COM_0011_01S.dat", "0") ;
  }

  @Test // insert Fail
  public void TST_IF_TER_COM_0011_02F() throws Exception
  {
    TER_tester("IF_TER_COM_0011_02F.dat", "1") ;
  }

  @Test // update Success
  public void TST_IF_TER_COM_0012_01S() throws Exception
  {
    TER_tester("IF_TER_COM_0012_01S.dat", "0") ;
  }

  @Test // delete Success
  public void TST_IF_TER_COM_0013_01S() throws Exception
  {
    TER_tester("IF_TER_COM_0013_01S.dat", "0") ;
  }

  // ==========================================================================================
  // ■ FRONT 어댑터 : I_TER
  // ■ BACK-END 어댑터 : I_COR
  // ■ 테스트 케이스 그룹 : TST_IF_TER_COR [계좌정보]
  // ■ 테스트 케이스 목록
  // TST_IF_TER_COR_0030_01S [계좌정보 조회 01 정상 케이스 ]
  // TST_IF_TER_COR_0031_01S [계좌정보 등록 01 정상 케이스 ]
  // TST_IF_TER_COR_0031_02F [계좌정보 등록 02 실패 케이스 ] - 중복등록 Duplicate Error
  // TST_IF_TER_COR_0032_01S [계좌정보 삭제 01 정상 케이스 ]
  // ==========================================================================================

  @Test // select Success
  public void TST_IF_TER_COR_0030_01S() throws Exception
  {
    TER_tester("IF_TER_COR_0030_01S.dat", "0") ;
  }

  @Test // insert Success
  public void TST_IF_TER_COR_0031_01S() throws Exception
  {
    TER_tester("IF_TER_COR_0031_01S.dat", "0") ;
  }

  @Test // insert Fail
  public void TST_IF_TER_COR_0031_02F() throws Exception
  {
    TER_tester("IF_TER_COR_0031_02F.dat", "1") ;
  }

  @Test // delete Success
  public void TST_IF_TER_COR_0032_01S() throws Exception
  {
    TER_tester("IF_TER_COR_0032_01S.dat", "0") ;
  }

  @Test
  public void TST_IF_TER_COR_0033_01S() throws Exception
  {
    TER_tester("IF_TER_COM_0099_01S.dat", "0") ;
  }
  
  // ==========================================================================================
  // ■ FRONT 어댑터 : I_TER
  // ■ BACK-END 어댑터 : I_PRD
  // ■ 테스트 케이스 그룹 : TST_IF_TER_PRD [추천상품]
  // ■ 테스트 케이스 목록
  // TST_IF_TER_PRD_0040_01S [추천상품 조회 01 정상 케이스 ]
  // ==========================================================================================

  @Test // select Success
  public void TST_IF_TER_PRD_0040_01S() throws Exception
  {
    TER_tester("IF_TER_PRD_0040_01S.dat", "0") ;
  }
}
