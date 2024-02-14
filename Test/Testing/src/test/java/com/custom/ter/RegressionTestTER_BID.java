package com.custom.ter ;

import static org.junit.jupiter.api.Assertions.assertEquals ;

import java.net.ServerSocket ;
import java.net.Socket ;

import org.apache.http.client.config.RequestConfig ;
import org.apache.http.client.methods.HttpPost ;
import org.apache.http.entity.ByteArrayEntity ;
import org.junit.jupiter.api.AfterAll ;
import org.junit.jupiter.api.BeforeAll ;
import org.junit.jupiter.api.Test ;

import com.custom.RegressionUtils ;
import com.fasterxml.jackson.databind.JsonNode ;
import com.fasterxml.jackson.databind.ObjectMapper ;

public class RegressionTestTER_BID extends RegressionUtils
{
  protected static ServerSocket serverSocket ;

  @BeforeAll
  public static void init()
  {
    try
    {
      serverSocket = new ServerSocket(TER_CONNECTOR_PORT + 100) ;
      serverSocket.setSoTimeout(TIMEOUT) ;
    }
    catch (Exception e)
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
   * @param fileName
   *          : 거래요청 전문 파일
   * @param ResponseCode
   *          : 0 정상 , 1 외부에러 , 2 내부에러
   * @throws Exception
   */
  public void TST_tester(String fileName, String ResponseCode) throws Exception
  {
    String caseId = fileName.substring(0, fileName.indexOf(".dat")) ;
    System.out.println("TEST EXECUTE : " + caseId) ;

    RequestConfig requestConfig = RequestConfig.custom().setSocketTimeout(TIMEOUT).setConnectTimeout(TIMEOUT).setConnectionRequestTimeout(TIMEOUT).build() ;

    HttpPost httpPost = new HttpPost("http://" + CONNECTOR_ADDRESS + ":" + TER_CONNECTOR_PORT + "/") ;
    httpPost.setConfig(requestConfig) ;
    httpPost.setEntity(new ByteArrayEntity(makeJsonRequest(fileName, caseId, 0))) ;

    //httpClient.execute(httpPost) ;
    new ObjectMapper().readTree(httpClient.execute(httpPost).getEntity().getContent()) ;

    JsonNode jsonBidNode ;
    try (Socket socket = serverSocket.accept())
    {
      socket.setSoTimeout(TIMEOUT) ;
      jsonBidNode = new ObjectMapper().readTree(socket.getInputStream()) ;
    }

    assertEquals(ResponseCode, jsonBidNode.path(HEADER_ID).path(STANDARD_HEADER_ID).path(RESPONSE_CODE_FIELD).textValue()) ;
  }

  // ==========================================================================================
  // ■ FRONT 어댑터 : I_TER
  // ■ BACK-END 어댑터 : I_COM
  // ■ 테스트 케이스 그룹 : TST_IF_TER_COM [신용등급]
  // ■ 테스트 케이스 목록
  // TST_IF_TER_COM_0100_01S [신용등급 조회 01 정상 케이스 ]
  // TST_IF_TER_COM_0101_01S [신용등급 등록 01 정상 케이스 ]
  // TST_IF_TER_COM_0102_01S [신용등급 수정 01 정상 케이스 ]
  // TST_IF_TER_COM_0103_01S [신용등급 삭제 01 정상 케이스 ]
  // ==========================================================================================

  @Test // select Success
  public void TST_IF_TER_COM_0100_01S() throws Exception
  {
    TST_tester("IF_TER_COM_0100_01S.dat", "0") ;
  }

  @Test // insert Success
  public void TST_IF_TER_COM_0101_01S() throws Exception
  {
    TST_tester("IF_TER_COM_0101_01S.dat", "0") ;
  }

  @Test // update Success
  public void TST_IF_TER_COM_0102_01S() throws Exception
  {
    TST_tester("IF_TER_COM_0102_01S.dat", "0") ;
  }

  @Test // delete Success
  public void TST_IF_TER_COM_0103_01S() throws Exception
  {
    TST_tester("IF_TER_COM_0103_01S.dat", "0") ;
  }
}
