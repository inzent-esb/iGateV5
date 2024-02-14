package com.custom.ter ;

import static org.junit.jupiter.api.Assertions.assertEquals ;

import java.net.ServerSocket ;
import java.net.Socket ;

import org.junit.jupiter.api.AfterAll ;
import org.junit.jupiter.api.BeforeAll ;

import com.custom.RegressionUtils ;
import com.fasterxml.jackson.databind.JsonNode ;
import com.fasterxml.jackson.databind.ObjectMapper ;

public class RegressionTestTER_PUSH extends RegressionUtils
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
 * @param fileName     : 거래요청 전문 파일
 * @param ResponseCode :  0 정상 , 1 외부에러 , 2 내부에러
 * @throws Exception  
 */
  public void PUSH_tester(String fileName, String ResponseCode) throws Exception
  {
//    HttpPost httpPost = new HttpPost("http://192.168.20.202:2001/iManager/igate/job/control.json?command=execute") ;
//    List<NameValuePair> param = new ArrayList<NameValuePair>();
//    param.add(new BasicNameValuePair("jobId", "JOB_PUSH_SENDER"));
//    httpPost.setEntity(new UrlEncodedFormEntity(param));
//
//    JsonNode jsonPushNode = new ObjectMapper().readTree(httpClient.execute(httpPost).getEntity().getContent()) ;
//    
//    System.out.println("PUSH CALL RESULT : " + jsonPushNode.path("result").textValue() ) ;
//
    JsonNode jsonNode ;
    try (Socket socket = serverSocket.accept())
    {
      socket.setSoTimeout(TIMEOUT) ;
      jsonNode = new ObjectMapper().readTree(socket.getInputStream()) ;
    }

    assertEquals(ResponseCode, jsonNode.path(HEADER_ID).path(STANDARD_HEADER_ID).path(RESPONSE_CODE_FIELD).textValue()) ;
  }

  /* ==========================================================================================
   *  ■ FRONT 어댑터      : I_TER
   *  ■ BACK-END 어댑터 : I_COM (계정계)
   *  ■ 테스트 케이스 그룹 : TST_IF_TER_COM [공지사항]
   *  ■ 테스트 케이스 목록  
   *     TST_IF_TER_HUB_0110_01S [PUSH 메시지 01 정상 케이스 ]
   * ==========================================================================================
   */

//  @Test
//  public void TST_IF_TER_MCA_0110_01S() throws Exception
//  {
//	  PUSH_tester("IF_TER_MCA_0110_01S.dat", "0") ;
//  }
}
