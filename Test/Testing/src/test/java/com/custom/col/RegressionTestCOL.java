package com.custom.col ;

import static org.junit.jupiter.api.Assertions.assertEquals ;

import java.io.IOException ;
import java.net.InetSocketAddress ;
import java.net.ServerSocket ;
import java.net.Socket ;

import org.junit.jupiter.api.AfterAll ;
import org.junit.jupiter.api.BeforeAll ;
import org.junit.jupiter.api.Test ;

import com.custom.RegressionUtils ;

public class RegressionTestCOL extends RegressionUtils
{
  protected static ServerSocket serverSocket ;

  @BeforeAll
  public static void init()
  {
    try
    {
      serverSocket = new ServerSocket(COL_CONNECTOR_PORT + 100) ;
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

  /**
   *  
 * @param fileName     : 거래요청 전문 파일
 * @param ResponseCode :  0 정상 , 1 외부에러 , 2 내부에러
 * @throws Exception  
 */
  public void ONEWAY_tester(String fileName, String ResponseCode) throws Exception
  {
    String caseId = fileName.substring(0, fileName.indexOf(".dat")) ;
    System.out.println("TEST EXECUTE : " + caseId) ;

    try (Socket socket = new Socket())
    {
      socket.connect(new InetSocketAddress(CONNECTOR_ADDRESS, COL_CONNECTOR_PORT), TIMEOUT) ;
      socket.setSoTimeout(TIMEOUT) ;
      socket.getOutputStream().write(makeBytesRequest(fileName, caseId, 0)) ;
      
      if (socket.isConnected())
        assertEquals(ResponseCode, "0") ;
    }
  }

  // ==========================================================================================
  // ■ FRONT 어댑터 : I_COL
  // ■ BACK-END 어댑터 : I_EDW
  // ■ 테스트 케이스 그룹 : TST_IF_COL_EDW [추천상품]
  // ■ 테스트 케이스 목록
  // TST_IF_COL_EDW_0040_01S [추천상품 조회 01 정상 케이스 ]
  // TST_IF_COL_EDW_0041_01S [추천상품 등록 01 정상 케이스 ]
  // TST_IF_COL_EDW_0041_02F [추천상품 등록 02 실패 케이스 ] - 중복등록 Duplicate Error
  // TST_IF_COL_EDW_0042_01S [추천상품 수정 01 정상 케이스 ]
  // TST_IF_COL_EDW_0043_01S [추천상품 삭제 01 정상 케이스 ]
  // ==========================================================================================

  @Test // select Success
  public void TST_IF_COL_EDW_0040_01S() throws Exception
  {
    COL_tester(serverSocket, "IF_COL_EDW_0040_01S.dat", "0") ;
  }

  @Test // insert Success
  public void TST_IF_COL_EDW_0041_01S() throws Exception
  {
    COL_tester(serverSocket, "IF_COL_EDW_0041_01S.dat", "0") ;
  }

  @Test // insert Fail
  public void TST_IF_COL_EDW_0041_02F() throws Exception
  {
    COL_tester(serverSocket, "IF_COL_EDW_0041_02F.dat", "1") ;
  }

  @Test // update Success
  public void TST_IF_COL_EDW_0042_01S() throws Exception
  {
    COL_tester(serverSocket, "IF_COL_EDW_0042_01S.dat", "0") ;
  }

  @Test // delete Success
  public void TST_IF_COL_EDW_0043_01S() throws Exception
  {
    COL_tester(serverSocket, "IF_COL_EDW_0043_01S.dat", "0") ;
  }

  // ==========================================================================================
  // ■ FRONT 어댑터 : I_COL
  // ■ BACK-END 어댑터 : I_HUB
  // ■ 테스트 케이스 그룹 : TST_IF_COL_HUB [마케팅대상]
  // ■ 테스트 케이스 목록
  // TST_IF_COL_HUB_0020_01S [마케팅대상 조회 01 정상 케이스 ]
  // TST_IF_COL_HUB_0021_01S [마케팅대상 등록 01 정상 케이스 ]
  // TST_IF_COL_HUB_0021_02F [마케팅대상 등록 02 실패 케이스 ] - 중복등록 Duplicate Error
  // TST_IF_COL_HUB_0022_01S [마케팅대상 수정 01 정상 케이스 ]
  // TST_IF_COL_HUB_0023_01S [마케팅대상 삭제 01 정상 케이스 ]
  // ==========================================================================================

  @Test // select Success
  public void TST_IF_COL_HUB_0020_01S() throws Exception
  {
    COL_tester(serverSocket, "IF_COL_HUB_0020_01S.dat", "0") ;
  }

  @Test // insert Success
  public void TST_IF_COL_HUB_0021_01S() throws Exception
  {
    COL_tester(serverSocket, "IF_COL_HUB_0021_01S.dat", "0") ;
  }

  @Test // insert Fail
  public void TST_IF_COL_HUB_0021_02F() throws Exception
  {
    COL_tester(serverSocket, "IF_COL_HUB_0021_02F.dat", "1") ;
  }

  @Test // update Success
  public void TST_IF_COL_HUB_0022_01S() throws Exception
  {
    COL_tester(serverSocket, "IF_COL_HUB_0022_01S.dat", "0") ;
  }

  @Test // delete Success
  public void TST_IF_COL_HUB_0023_01S() throws Exception
  {
    COL_tester(serverSocket, "IF_COL_HUB_0023_01S.dat", "0") ;
  }

  // ==========================================================================================
  // ■ FRONT 어댑터 : I_COL
  // ■ BACK-END 어댑터 : I_COR
  // ■ 테스트 케이스 그룹 : TST_IF_COL_COR [거래]
  // ■ 테스트 케이스 목록
  // TST_IF_COL_COR_0050_01S [거래내역 조회 01 정상 케이스 ]
  // TST_IF_COL_COR_0051_01S [입금거래 01 정상 케이스 ]
  // TST_IF_COL_COR_0052_01S [출금거래 01 정상 케이스 ]
  // ==========================================================================================

  @Test // select Success
  public void TST_IF_COL_COR_0050_01S() throws Exception
  {
    COL_tester(serverSocket, "IF_COL_COR_0050_01S.dat", "0") ;
  }

  @Test // insert,update Success
  public void TST_IF_COL_COR_0051_01S() throws Exception
  {
    COL_tester(serverSocket, "IF_COL_COR_0051_01S.dat", "0") ;
  }

  @Test // insert,update Success
  public void TST_IF_COL_COR_0052_01S() throws Exception
  {
    COL_tester(serverSocket, "IF_COL_COR_0052_01S.dat", "0") ;
  }

  // ==========================================================================================
  // ■ FRONT 어댑터 : I_COL
  // ■ BACK-END 어댑터 : I_COM
  // ■ 테스트 케이스 그룹 : TST_IF_COL_COM [신용등급]
  // ■ 테스트 케이스 목록
  // TST_IF_COL_COM_0100_01S [신용등급 조회 01 정상 케이스 ]
  // ==========================================================================================

  @Test // select Success
  public void TST_IF_COL_COM_0100_01S() throws Exception
  {
    COL_tester(serverSocket, "IF_COL_COM_0100_01S.dat", "0") ;
  }

  // ==========================================================================================
  // ■ FRONT 어댑터 : I_COL
  // ■ BACK-END 어댑터 : I_PRD
  // ■ 테스트 케이스 그룹 : TST_IF_COL_PRD [추천상품]
  // ■ 테스트 케이스 목록
  // TST_IF_COL_PRD_0040_01S [추천상품 조회 01 정상 케이스 ]
  // ==========================================================================================

  @Test // select Success
  public void TST_IF_COL_PRD_0040_01S() throws Exception
  {
    COL_tester(serverSocket, "IF_COL_PRD_0040_01S.dat", "0") ;
  }

  // ==========================================================================================
  // ■ FRONT 어댑터 : I_COL
  // ■ BACK-END 어댑터 : I_CRM
  // ■ 테스트 케이스 그룹 : TST_IF_COL_CRM [고객출입통보]
  // ■ 테스트 케이스 목록
  // TST_IF_COL_CRM_0060_01S [고객출입통보 01 정상 케이스 ]
  // ==========================================================================================

  @Test // select Success
  public void TST_IF_COL_CRM_0060_01S() throws Exception
  {
    ONEWAY_tester("IF_COL_CRM_0060_01S.dat", "0") ;
  }

  // ==========================================================================================
  // ■ FRONT 어댑터 : I_COL
  // ■ BACK-END 어댑터 : E_KFTC_O_ELB
  // ■ 테스트 케이스 그룹 : TST_IF_COL_E_KFTC_O_ELB [금융결제원 전자금융공동망 당발 타행이체]
  // ■ 테스트 케이스 목록
  // TST_IF_COL_KFTC_02004000_01S [금융결제원 전자금융공동망 당발 타행이체 01 정상 케이스 ]
  // ==========================================================================================

  @Test // select Success
  public void TST_IF_COL_KFTC_02004000_01S() throws Exception
  {
    COL_tester(serverSocket, "IF_COL_KFTC_02004000_01S.dat", "0") ;
  }
}
