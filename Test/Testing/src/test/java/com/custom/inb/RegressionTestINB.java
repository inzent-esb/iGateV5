package com.custom.inb ;

import org.junit.jupiter.api.Test ;

import com.custom.RegressionUtils ;

public class RegressionTestINB extends RegressionUtils
{
  // ==========================================================================================
  // ■ FRONT 어댑터 : I_INB
  // ■ BACK-END 어댑터 : I_COM
  // ■ 테스트 케이스 그룹 : TST_IF_INB_COM [고객정보]
  // ■ 테스트 케이스 목록
  // TST_IF_INB_COM_0010_01S [고객정보 조회 01 정상 케이스 ]
  // TST_IF_INB_COM_0011_01S [고객정보 등록 01 정상 케이스 ]
  // TST_IF_INB_COM_0011_02F [고객정보 등록 02 실패 케이스 ] - 중복등록 Duplicate Error
  // TST_IF_INB_COM_0012_01S [고객정보 수정 01 정상 케이스 ]
  // TST_IF_INB_COM_0013_01S [고객정보 삭제 01 정상 케이스 ]
  // ==========================================================================================

  @Test // select Success
  public void TST_IF_INB_COM_0010_01S() throws Exception
  {
    INB_tester("IF_INB_COM_0010_01S.dat", "0") ;
  }

  @Test // insert Success
  public void TST_IF_INB_COM_0011_01S() throws Exception
  {
    INB_tester("IF_INB_COM_0011_01S.dat", "0") ;
  }

  @Test // insert Fail
  public void TST_IF_INB_COM_0011_02F() throws Exception
  {
    INB_tester("IF_INB_COM_0011_02F.dat", "1") ;
  }

  @Test // update Success
  public void TST_IF_INB_COM_0012_01S() throws Exception
  {
    INB_tester("IF_INB_COM_0012_01S.dat", "0") ;
  }

  @Test // delete Success
  public void TST_IF_INB_COM_0013_01S() throws Exception
  {
    INB_tester("IF_INB_COM_0013_01S.dat", "0") ;
  }

  // ==========================================================================================
  // ■ FRONT 어댑터 : I_INB
  // ■ BACK-END 어댑터 : I_COM
  // ■ 테스트 케이스 그룹 : TST_IF_INB_COM [신용등급]
  // ■ 테스트 케이스 목록
  // TST_IF_INB_COM_0100_01S [신용등급 조회 01 정상 케이스 ]
  // ==========================================================================================

  @Test // select Success
  public void TST_IF_INB_COM_0100_01S() throws Exception
  {
    INB_tester("IF_INB_COM_0100_01S.dat", "0") ;
  }
  
  // ==========================================================================================
  // ■ FRONT 어댑터 : I_INB
  // ■ BACK-END 어댑터 : I_MCA ( 복합거래 ) <-> I_COM, I_COR, I_EDW
  // ■ 테스트 케이스 그룹 : TST_IF_INB_MCA [복합거래]
  // ■ 테스트 케이스 목록
  // TST_IF_INB_MCA_0100_01S [ [조건 복합] 고객_가입_및_정보업데이트 | 01 정상 케이스 ]
  // TST_IF_INB_MCA_0200_01S [ [순차 복합] 고객_주계좌_조회 | 01 정상 케이스 ]
  // TST_IF_INB_MCA_0300_01S [ [병렬 복합] 마이페이지 ( timeoutNo All 응답) | 01 정상 케이스 ]
  // TST_IF_INB_MCA_0301_01S [ [병렬 복합] 마이페이지 ( timeoutNo 부거래 skip) | 01 정상 케이스 ]
  // TST_IF_INB_MCA_0302_01S [ [병렬 복합] 마이페이지 ( timeout All 응답) | 01 정상 케이스 ]
  // TST_IF_INB_MCA_0303_01F [ [병렬 복합] 마이페이지 ( timeout Error ) | 01 실패 케이스 ]
  // ==========================================================================================

  // [조건 복합] 고객_가입_및_정보업데이트
  // * 서비스1 SV_COM_0010 고객정보조회 > 조건 병렬 거래
  // * 서비스2 SV_COM_0011 고객정보등록 (신규고객)
  // * 서비스3 SV_COM_0012 고객정보수정 (기존고객)
  @Test
  public void TST_IF_INB_MCA_0100_01S() throws Exception
  {
    INB_tester("IF_INB_MCA_0100_01S.dat", "0") ;
  }

  // [순차 복합] 고객_주계좌_조회
  // * 서비스1 SV_COM_0010 고객정보조회
  // * 서비스2 SV_COR_0030 계좌목록조회
  // * 서비스3 SV_COR_0050 거래내역조회
  @Test
  public void TST_IF_INB_MCA_0200_01S() throws Exception
  {
    INB_tester("IF_INB_MCA_0200_01S.dat", "0") ;
  }

  // [병렬 복합] 마이페이지 ( timeoutNo All 응답)
  // - Fork timeout : 0
  // * 서비스1 [SV_COM_0010] 고객정보조회
  // * 서비스2 (주) [SV_COR_0030] 계좌목록조회 (sleep : 1초)
  // * 서비스3 (부) [SV_EDW_0040] 추천상품조회 (sleep : 0초)
  @Test
  public void TST_IF_INB_MCA_0300_01S() throws Exception
  {
    INB_tester("IF_INB_MCA_0300_01S.dat", "0") ;
  }

  // [병렬 복합] 마이페이지 ( timeoutNo 부거래 skip)
  // - Fork timeout : 0
  // * 서비스1 [SV_COM_0010] 고객정보조회
  // * 서비스2 (주) [SV_COR_0030] 계좌목록조회 (sleep : 1초)
  // * 서비스3 (부) [SV_EDW_0040] 추천상품조회 (sleep : 5초)
  @Test
  public void TST_IF_INB_MCA_0301_01S() throws Exception
  {
    INB_tester("IF_INB_MCA_0301_01S.dat", "0") ;
  }

  // [병렬 복합] 마이페이지 ( timeout All 응답)
  // - Fork timeout : 3000
  // * 서비스1 [SV_COM_0010] 고객정보조회
  // * 서비스2 (주) [SV_COR_0030] 계좌목록조회 (sleep : 1초)
  // * 서비스3 (부) [SV_EDW_0040] 추천상품조회 (sleep : 2초)
  @Test
  public void TST_IF_INB_MCA_0302_01S() throws Exception
  {
    INB_tester("IF_INB_MCA_0302_01S.dat", "0") ;
  }

  // [병렬 복합] 마이페이지 ( timeout Error )
  // - Fork timeout : 3000
  // * 서비스1 [SV_COM_0010] 고객정보조회
  // * 서비스2 (주) [SV_COR_0030] 계좌목록조회 (sleep : 1초)
  // * 서비스3 (부) [SV_EDW_0040] 추천상품조회 (sleep : 5초)
  @Test
  public void TST_IF_INB_MCA_0303_01F() throws Exception
  {
    INB_tester("IF_INB_MCA_0303_01F.dat", "2") ;
  }
  
  //[파일거래 전 처리] 대외파일거래 전, Echo서버의 파일송신내역 삭제
  // - Echo 서버의 IGT_FILE_REPOSITORY 테이블 DELETE
  // 
  @Test // External File( Delete IGT_FILE_REPOSITORY )
  public void TST_EXTERNAL_INIT_01S() throws Exception
  {
	  DEL_tester("IF_DEL_FILE_REPOSITORY_01S.dat", "0") ;
  }
}
