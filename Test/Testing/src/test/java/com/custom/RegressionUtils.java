package com.custom ;

import static org.junit.jupiter.api.Assertions.assertEquals ;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream ;
import java.net.InetSocketAddress ;
import java.net.ServerSocket ;
import java.net.Socket ;
import java.nio.charset.StandardCharsets ;
import java.sql.Connection ;
import java.sql.PreparedStatement ;
import java.sql.ResultSet ;
import java.sql.SQLException ;
import java.sql.Statement ;
import java.text.SimpleDateFormat ;
import java.util.Date ;
import java.util.HashSet ;
import java.util.List ;
import java.util.Properties;
import java.util.stream.Collectors ;

import org.apache.commons.io.IOUtils ;
import org.apache.commons.lang3.StringUtils ;
import org.apache.http.HttpHeaders;
import org.apache.http.client.config.RequestConfig ;
import org.apache.http.client.methods.CloseableHttpResponse ;
import org.apache.http.client.methods.HttpDelete ;
import org.apache.http.client.methods.HttpGet ;
import org.apache.http.client.methods.HttpPost ;
import org.apache.http.client.methods.HttpPut ;
import org.apache.http.client.methods.HttpRequestBase ;
import org.apache.http.client.utils.URIBuilder ;
import org.apache.http.entity.ByteArrayEntity ;
import org.apache.http.entity.StringEntity ;
import org.apache.http.impl.client.CloseableHttpClient ;
import org.apache.http.impl.client.HttpClients ;
import org.dom4j.Document ;
import org.dom4j.Element ;
import org.dom4j.io.SAXReader ;

import com.fasterxml.jackson.databind.JsonNode ;
import com.fasterxml.jackson.databind.ObjectMapper ;
import com.fasterxml.jackson.databind.node.JsonNodeFactory ;
import com.fasterxml.jackson.databind.node.ObjectNode ;

public class RegressionUtils implements Regression
{
	//
	public static String ASYNC_VALID_JDBC_URL ;
	public static String ASYNC_VALID_JDBC_ID ="";
	public static String ASYNC_VALID_JDBC_PASSWORD ="";
	
	public static String COR_JDBC_URL ="";
	public static String COR_JDBC_ID ="";
	public static String COR_JDBC_PASSWORD ="";
	
	public static String EDW_JDBC_URL ="";
	public static String EDW_JDBC_ID ="";
	public static String EDW_JDBC_PASSWORD ="";
	  
	public static String ECHO_CONNECTOR_ADDRESS ;
	public static String ECHO_USERNAME ="";
	public static String ECHO_PASSWORD ="";
	  
	public static String USERNAME ="";
	public static String PASSWORD ="";
	//
	protected static Connection asyncValidConnection ;
	protected static Connection extractConnection ;
	protected static Connection loadConnection ;
	
	public static CloseableHttpClient httpClient = HttpClients.createDefault() ;
	public static String mcaSessionId ;
	public static String tellerCode ;

	static {
		try 
		  {
			System.out.println("[FileInputStream]");
			FileInputStream fis = new FileInputStream("/home/igate5/iGate/bin/info.properties");
			ASYNC_VALID_JDBC_URL = getProperties(fis, "ASYNC_VALID_JDBC_URL") ;
			System.out.println("ASYNC_VALID_JDBC_URL :"+ASYNC_VALID_JDBC_URL);
			ASYNC_VALID_JDBC_ID = getProperties(fis, "ASYNC_VALID_JDBC_ID") ;
			ASYNC_VALID_JDBC_PASSWORD = getProperties(fis, "ASYNC_VALID_JDBC_PASSWORD") ;
			
			COR_JDBC_URL = getProperties(fis, "COR_JDBC_URL") ;
			COR_JDBC_ID = getProperties(fis, "COR_JDBC_ID") ;
			COR_JDBC_PASSWORD = getProperties(fis, "COR_JDBC_PASSWORD") ;
			
			EDW_JDBC_URL = getProperties(fis, "EDW_JDBC_URL") ;
			EDW_JDBC_ID = getProperties(fis, "EDW_JDBC_ID") ;
			EDW_JDBC_PASSWORD = getProperties(fis, "EDW_JDBC_PASSWORD") ;
			
			ECHO_CONNECTOR_ADDRESS = getProperties(fis, "ECHO_CONNECTOR_ADDRESS") ;
			ECHO_USERNAME = getProperties(fis, "ECHO_USERNAME") ;
			ECHO_PASSWORD = getProperties(fis, "ECHO_PASSWORD") ;

			USERNAME = getProperties(fis, "USERNAME") ;
			PASSWORD = getProperties(fis, "PASSWORD") ;
		  } 
		  catch (FileNotFoundException e) 
		  {
			e.printStackTrace();
		  }
	}
	
	public static String getProperties(FileInputStream fis, String key)
	{
		Properties prop = new Properties();
		try 
		{
			//key=value로 되어있는 애들을 pair로 읽어올 수 있는 기능
			prop.load(fis);
		} 
		catch (IOException e) 
		{
			e.printStackTrace();
		}
		
		return prop.getProperty(key, "") ;
	}
  
  // 17+19 = 36
  public static String getNowDateTime()
  {
    return new SimpleDateFormat("YYYYMMddHHmmssSSS").format(new Date()) ;
  }

  public static String createGUID(String caseId)
  {
    if (caseId.length() >= 19)
      caseId = caseId.substring(0, 19) ;
    else
      caseId = StringUtils.leftPad(caseId, 19, "Q") ;

    String guid = getNowDateTime() + caseId;
    System.out.println(caseId + " GUID : " + guid) ;
    return guid ;
  }

  public void DEL_tester(String fileName, String ResponseCode) throws Exception
  {
    String caseId = fileName.substring(0, fileName.indexOf(".dat")) ;
    System.out.println("TEST EXECUTE : " + caseId) ;
    
    try (Socket socket = new Socket())
    {
      socket.connect(new InetSocketAddress(ECHO_CONNECTOR_ADDRESS, 6003), TIMEOUT) ;
      socket.setSoTimeout(TIMEOUT) ;
      socket.getOutputStream().write(makeBytesRequest(fileName, caseId, 0)) ;
      
      assertEquals(ResponseCode, "0") ;
    }
  }
  
  public void ATM_tester(String fileName, String ResponseCode) throws Exception
  {
    String caseId = fileName.substring(0, fileName.indexOf(".dat")) ;
    System.out.println("TEST EXECUTE : " + caseId) ;

    try (Socket socket = new Socket())
    {
      socket.connect(new InetSocketAddress(CONNECTOR_ADDRESS, ATM_CONNECTOR_PORT), TIMEOUT) ;
      socket.setSoTimeout(TIMEOUT) ;
      socket.getOutputStream().write(makeBytesRequest(fileName, caseId, 0)) ;

      byte[] len = new byte[8] ;
      IOUtils.readFully(socket.getInputStream(), len) ;

      byte[] body = new byte[Integer.parseInt(new String(len)) - len.length] ;
      IOUtils.readFully(socket.getInputStream(), body) ;

      assertEquals(ResponseCode, new String(body, RESPONSE_CODE_OFFSET - DATA_LEN_LENGTH, RESPONSE_CODE_LENGTH)) ;      
    }
  }

  public void ATS_tester(String fileName, String ResponseCode) throws Exception
  {
    String caseId = fileName.substring(0, fileName.indexOf(".dat")) ;
    System.out.println("TEST EXECUTE : " + caseId) ;
    
    try (Socket socket = new Socket())
    {
      socket.connect(new InetSocketAddress(CONNECTOR_ADDRESS, ATS_CONNECTOR_PORT), TIMEOUT) ;
      socket.setSoTimeout(TIMEOUT) ;
      socket.getOutputStream().write(makeBytesRequest(fileName, caseId, 0)) ;
      
      byte[] len = new byte[8] ;
      IOUtils.readFully(socket.getInputStream(), len) ;
      
      byte[] body = new byte[Integer.parseInt(new String(len)) - len.length] ;
      IOUtils.readFully(socket.getInputStream(), body) ;
      
      assertEquals(ResponseCode, new String(body, RESPONSE_CODE_OFFSET - DATA_LEN_LENGTH, RESPONSE_CODE_LENGTH)) ;
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
  public void COL_tester(ServerSocket serverSocket, String fileName, String ResponseCode) throws Exception
  {
    String caseId = fileName.substring(0, fileName.indexOf(".dat")) ;
    System.out.println("TEST EXECUTE : " + caseId) ;

    try (Socket socket = new Socket())
    {
      socket.connect(new InetSocketAddress(CONNECTOR_ADDRESS, COL_CONNECTOR_PORT), TIMEOUT) ;
      socket.setSoTimeout(TIMEOUT) ;
      socket.getOutputStream().write(makeBytesRequest(fileName, caseId, 0)) ;
    }

    try (Socket socket = serverSocket.accept())
    {
      byte[] len = new byte[8] ;
      IOUtils.readFully(socket.getInputStream(), len) ;

      byte[] body = new byte[Integer.parseInt(new String(len)) - len.length] ;
      IOUtils.readFully(socket.getInputStream(), body) ;

      assertEquals(ResponseCode, new String(body, RESPONSE_CODE_OFFSET - DATA_LEN_LENGTH, RESPONSE_CODE_LENGTH)) ;
    }
  }

  public void INB_tester(String fileName, String ResponseCode) throws Exception
  {
    String caseId = fileName.substring(0, fileName.indexOf(".dat")) ;
    System.out.println("TEST EXECUTE : " + caseId) ;

    RequestConfig requestConfig = RequestConfig.custom().setSocketTimeout(TIMEOUT).setConnectTimeout(TIMEOUT).setConnectionRequestTimeout(TIMEOUT).build() ;

    HttpPost httpPost = new HttpPost("http://" + CONNECTOR_ADDRESS + ":" + INB_CONNECTOR_PORT + "/iGate/INB") ;
    httpPost.setConfig(requestConfig) ;
    httpPost.setEntity(new ByteArrayEntity(makeXmlRequest(fileName, caseId, 0, null))) ;

    Element element = new SAXReader().read(httpClient.execute(httpPost).getEntity().getContent()).getRootElement() ;

    assertEquals(ResponseCode, element.element(HEADER_ID).element(STANDARD_HEADER_ID).element(RESPONSE_CODE_FIELD).getText()) ;
  }

  public JsonNode TER_tester(String fileName, String ResponseCode) throws Exception
  {
    String caseId = fileName.substring(0, fileName.indexOf(".dat")) ;
    System.out.println("TEST EXECUTE : " + caseId) ;

    RequestConfig requestConfig = RequestConfig.custom().setSocketTimeout(TIMEOUT).setConnectTimeout(TIMEOUT).setConnectionRequestTimeout(TIMEOUT).build() ;

    HttpPost httpPost = new HttpPost("http://" + CONNECTOR_ADDRESS + ":" + TER_CONNECTOR_PORT + "/") ;
    httpPost.setConfig(requestConfig) ;
    httpPost.setEntity(new ByteArrayEntity(makeJsonRequest(fileName, caseId, 0))) ;

    JsonNode jsonNode = new ObjectMapper().readTree(httpClient.execute(httpPost).getEntity().getContent()) ;

    assertEquals(ResponseCode, jsonNode.path(HEADER_ID).path(STANDARD_HEADER_ID).path(RESPONSE_CODE_FIELD).textValue()) ;

    return jsonNode ;
  }
  
  public JsonNode MCA_tester(String fileName, String ResponseCode) throws Exception
  {
    String caseId = fileName.substring(0, fileName.indexOf(".dat")) ;
    System.out.println("TEST EXECUTE : " + caseId) ;

    RequestConfig requestConfig = RequestConfig.custom().setSocketTimeout(TIMEOUT).setConnectTimeout(TIMEOUT).setConnectionRequestTimeout(TIMEOUT).build() ;

    HttpPost httpPost = new HttpPost("http://" + CONNECTOR_ADDRESS + ":" + MCA_CONNECTOR_PORT + "/") ;
    httpPost.setConfig(requestConfig) ;
    httpPost.setEntity(new ByteArrayEntity(makeJsonRequest(fileName, caseId, 0))) ;

    JsonNode jsonNode = new ObjectMapper().readTree(httpClient.execute(httpPost).getEntity().getContent()) ;

    assertEquals(ResponseCode, jsonNode.path(HEADER_ID).path(STANDARD_HEADER_ID).path(RESPONSE_CODE_FIELD).textValue()) ;

    return jsonNode ;
  }
  
  public void EDW_tester(String fileName, String ResponseCode, String[] bindList) throws Exception
  {
    String caseId = fileName.substring(0, fileName.indexOf(".dat")) ;
    System.out.println("TEST EXECUTE : " + caseId) ;
    
    RequestConfig requestConfig = RequestConfig.custom().setSocketTimeout(TIMEOUT).setConnectTimeout(TIMEOUT).setConnectionRequestTimeout(TIMEOUT).build() ;

    HttpPost httpPost = new HttpPost("http://" + CONNECTOR_ADDRESS + ":" + EDW_CONNECTOR_PORT + "/iGate/INB") ;
    httpPost.setConfig(requestConfig) ;
    httpPost.setEntity(new ByteArrayEntity(makeXmlRequest(fileName, caseId, 0, bindList))) ;

    Element element = new SAXReader().read(httpClient.execute(httpPost).getEntity().getContent()).getRootElement() ;

    assertEquals(ResponseCode, element.element(HEADER_ID).element(STANDARD_HEADER_ID).element(RESPONSE_CODE_FIELD).getText()) ;
  }

  public void REST_tester(String fileName, String method, String uri, String ResponseCode) throws Exception
  {
    String caseId = fileName.substring(0, fileName.indexOf(".dat")) ;
        
    System.out.println("TEST EXECUTE : " + caseId) ;

    RequestConfig requestConfig = RequestConfig.custom().setSocketTimeout(TIMEOUT).setConnectTimeout(TIMEOUT).setConnectionRequestTimeout(TIMEOUT).build() ;
    HttpRequestBase http = makeRestRequest(fileName, caseId, method, uri);
    http.setConfig(requestConfig) ;
    http.setHeader("Content-Type", "application/x-www-form-urlencoded");
 
    try(CloseableHttpResponse response = httpClient.execute(http)){
    
      String returnResponseCode = response.getFirstHeader("ResponseCode").getValue();
          
  
      assertEquals(ResponseCode, returnResponseCode) ;
    }
  }

  public JsonNode KFTC_API_tester(String fileName, String method, String uri, String contentType, String ResponseCode) throws Exception
  {
    String caseId = fileName.substring(0, fileName.indexOf(".dat")) ;
    System.out.println("TEST EXECUTE : " + caseId) ;

    RequestConfig requestConfig = RequestConfig.custom().setSocketTimeout(TIMEOUT).setConnectTimeout(TIMEOUT).setConnectionRequestTimeout(TIMEOUT).build() ;
    HttpPost httpPost = new HttpPost("http://" + CONNECTOR_ADDRESS + ":" + KFTC_API_CONNECTOR_PORT + "/" + uri) ;
    httpPost.setConfig(requestConfig) ;
    JsonNode jsonNode ;

    if (uri.contains("oauth/2.0/token"))
    {
      httpPost.setHeader(HttpHeaders.CONTENT_TYPE, contentType);
      byte[] sendData ;
      try (InputStream is = this.getClass().getResourceAsStream("/tst/" + fileName))
      {
        sendData = IOUtils.toByteArray(is) ;
      }

      httpPost.setEntity(new ByteArrayEntity(sendData)) ;

      jsonNode = new ObjectMapper().readTree(httpClient.execute(httpPost).getEntity().getContent()) ;
      assertEquals(ResponseCode, jsonNode.path("token_type").textValue()) ;
    }
    else
    {
      httpPost.setHeader(HttpHeaders.CONTENT_TYPE, contentType);
      httpPost.setEntity(new ByteArrayEntity(makeJsonRequestNonStandardHeader(fileName))) ;

      jsonNode = new ObjectMapper().readTree(httpClient.execute(httpPost).getEntity().getContent()) ;
      assertEquals(ResponseCode, jsonNode.path("req_common").path("rsp_code").textValue()) ;
    }

    return jsonNode ;
  }

  public void JUNIT_KFB_TAX_tester(ServerSocket serverSocket, String fileName, String ResponseCode) throws Exception
  {
    String caseId = fileName.substring(0, fileName.indexOf(".dat")) ;
    System.out.println("TEST EXECUTE : " + caseId) ;
    
    try (Socket socket = new Socket())
    {
      socket.connect(new InetSocketAddress(ECHO_CONNECTOR_ADDRESS, ECHO_KFB_TAX_CONNECTOR_PORT), TIMEOUT) ;
      socket.setSoTimeout(TIMEOUT) ;
      socket.getOutputStream().write(makeBytesRequestNonStandardHeader(fileName, caseId, 0)) ;
    }
    
    if (null != serverSocket)
      try (Socket socket = serverSocket.accept())
      {
        // Transaction Code(9) + 전문 길이(4)
        byte[] len = new byte[13] ;
        IOUtils.readFully(socket.getInputStream(), len) ;
        
        byte[] body = new byte[Integer.parseInt(new String(len, 9, 4, "EUC-KR"))] ;
        IOUtils.readFully(socket.getInputStream(), body) ;
        
        // 응답 코드 = offset(13), length(3)
        assertEquals(ResponseCode, new String(body, 13, 3, "EUC-KR")) ;
      }
  }

  protected byte[] makeBytesRequest(String fileName, String caseId, int progressNo) throws Exception
  {
    byte[] sendData ;
    try (InputStream is = this.getClass().getResourceAsStream("/tst/" + fileName))
    {
      sendData = IOUtils.toByteArray(is) ;
    }

    String guid = createGUID(caseId) ;
    System.arraycopy(guid.getBytes(), 0, sendData, 8, 36) ;

    return sendData ;
  }

  protected byte[] makeBytesRequestNonStandardHeader(String fileName, String caseId, int progressNo) throws Exception
  {
    byte[] sendData ;
    try (InputStream is = this.getClass().getResourceAsStream("/tst/" + fileName))
    {
      sendData = IOUtils.toByteArray(is) ;
    }

    return sendData ;
  }

  protected byte[] makeXmlRequest(String fileName, String caseId, int progressNo, String[] bindList) throws Exception
  {
    try {
      Document document ;
      System.out.println("FILE NAME : /tst/" + fileName) ;
      try (InputStream is = this.getClass().getResourceAsStream("/tst/" + fileName))
      {
        /*Reader reader = new InputStreamReader(is);

        StringBuilder result = new StringBuilder();

        for (int data = reader.read(); data != -1; data = reader.read()) {
          result.append((char)data);
        }
*/
        //System.out.println(result.toString());
        
        document = new SAXReader().read(is) ;
      }
  
      Element standardHeader = document.getRootElement().element(HEADER_ID).element(STANDARD_HEADER_ID) ;
      standardHeader.element(TID_FIELD).setText(createGUID(caseId)) ;
      standardHeader.element(MID_FIELD).setText(Integer.toString(progressNo)) ;
      if (null != mcaSessionId)
      {
        standardHeader.element(MCA_ESSION_ID_FIELD).setText(mcaSessionId) ;
        standardHeader.element(TELLER_CODE_FIELD).setText(tellerCode) ;
      }
  
      if(bindList != null && bindList.length > 0) {
        return String.format(document.asXML(), bindList).getBytes(StandardCharsets.UTF_8) ;
      }
      return document.asXML().getBytes(StandardCharsets.UTF_8) ;
    }catch(Exception e) {
      e.printStackTrace(System.out);
      throw e;
    }
    
  }

  public byte[] makeJsonRequest(String fileName, String caseId, int progressNo) throws Exception
  {
    JsonNode jsonNode ;

    try (InputStream is = this.getClass().getResourceAsStream("/tst/" + fileName))
    {
      jsonNode = new ObjectMapper().readTree(is) ;
    }

    ObjectNode standardHeader = (ObjectNode) jsonNode.path(HEADER_ID).path(STANDARD_HEADER_ID) ;

    standardHeader.set(TID_FIELD, JsonNodeFactory.instance.textNode(createGUID(caseId))) ;
    standardHeader.set(MID_FIELD, JsonNodeFactory.instance.numberNode(progressNo)) ;
    if (null != mcaSessionId)
    {
      standardHeader.set(MCA_ESSION_ID_FIELD, JsonNodeFactory.instance.textNode(mcaSessionId)) ;
      standardHeader.set(TELLER_CODE_FIELD, JsonNodeFactory.instance.textNode(tellerCode)) ;
    }

    return new ObjectMapper().writeValueAsString(jsonNode).getBytes(StandardCharsets.UTF_8) ;
  }

  public byte[] makeJsonRequestNonStandardHeader(String fileName) throws Exception
  {
    JsonNode jsonNode ;

    try (InputStream is = this.getClass().getResourceAsStream("/tst/" + fileName))
    {
      jsonNode = new ObjectMapper().readTree(is) ;
    }

    return new ObjectMapper().writeValueAsString(jsonNode).getBytes(StandardCharsets.UTF_8) ;
  }

  protected HttpRequestBase makeRestRequest(String fileName, String caseId, String method, String uri) throws Exception
  {
    String data = IOUtils.toString(this.getClass().getResourceAsStream("/tst/" + fileName), StandardCharsets.UTF_8);
   
    if(method.startsWith("POST")) 
    {
      HttpPost httpPost = new HttpPost("http://" + CONNECTOR_ADDRESS + ":" + REST_CONNECTOR_PORT + "/" + uri) ;
      httpPost.setHeader(TID_FIELD, createGUID(caseId));
      //httpPost.setConfig(requestConfig) ;
      httpPost.setEntity(new StringEntity(data, StandardCharsets.UTF_8)) ;

      return httpPost;
    }
    else if(method.startsWith("GET")) 
    {
      HttpGet httpGet = new HttpGet("http://" + CONNECTOR_ADDRESS + ":" + REST_CONNECTOR_PORT + "/" + uri) ;
      httpGet.setHeader(TID_FIELD, createGUID(caseId));
      URIBuilder builder = new URIBuilder(httpGet.getURI());
      for(String line : data.split("\r\n")) {
        String[] value = line.split("\t");
        builder.addParameter(value[0], value[1]);
      }
      httpGet.setURI(builder.build());
      return httpGet;
    }
    else if(method.startsWith("DELETE")) 
    {
      HttpDelete httpDelete = new HttpDelete("http://" + CONNECTOR_ADDRESS + ":" + REST_CONNECTOR_PORT + "/" + uri) ;
      httpDelete.setHeader(TID_FIELD, createGUID(caseId));
      URIBuilder builder = new URIBuilder(httpDelete.getURI());
      for(String line : data.split("\r\n")) {
        String[] value = line.split("\t");
        builder.addParameter(value[0], value[1]);
      }
      httpDelete.setURI(builder.build());
      return httpDelete;
    }
    else if(method.startsWith("PUT")) 
    {
      HttpPut httpPut = new HttpPut("http://" + CONNECTOR_ADDRESS + ":" + REST_CONNECTOR_PORT + "/" + uri) ;
      httpPut.setHeader(TID_FIELD, createGUID(caseId));
      //httpPost.setConfig(requestConfig) ;
      httpPut.setEntity(new StringEntity(data, StandardCharsets.UTF_8)) ;

      return httpPut;
    }
    else {
      throw new Exception("method is invalid : " + method);
    }
    
    
    
  }
  
  @SuppressWarnings({ "unchecked" })
  public static void insertData(Connection conn, String sql, Object obj) throws SQLException {
    try(PreparedStatement pt = conn.prepareStatement(sql)){
      if(obj instanceof java.lang.String) {
        pt.setString(1, (String) obj);
        pt.executeUpdate();
      } else if (obj instanceof HashSet) {
        for(String val : (HashSet<String>)obj) {
          pt.setString(1, (String) val);
          pt.addBatch();
        }
        
        pt.executeBatch();
      } else if (obj == null) {
        pt.execute();
      } else {
        throw new IllegalArgumentException();
      }
      conn.commit();
    }
    //pt.close();
  }
  
  @SuppressWarnings({ "unchecked" })
  public static void insertData(Connection conn, String sql) throws SQLException {
    try(Statement stmt = conn.createStatement()){
      stmt.execute(sql);
      conn.commit();
    }
    //pt.close();
  }
    
  @SuppressWarnings({ "unchecked" })
  public int validData(Connection conn, String sql, Object obj) throws SQLException
  {
    PreparedStatement pt = null;

    if (obj == null) {
      pt = conn.prepareStatement(sql) ;
    }
    else if (obj instanceof java.lang.String)
    {
      String generateSql = String.format(sql, "?");
      
      pt = conn.prepareStatement(generateSql) ;
      pt.setString(1, (String) obj) ;
      
    }
    else if (obj instanceof List)
    {
      List<String> list = (List<String>) obj;
      String generateSql = String.format(sql, "?");
      
      pt = conn.prepareStatement(generateSql) ;
      for(int i = 0 ; i < list.size() ; i++) {
        pt.setString(i+1, list.get(i) ) ;
      }
    }
    else if (obj instanceof HashSet)
    {
      String generateSql = String.format(sql, ((HashSet<String>)obj).stream().map(v -> "?").collect(Collectors.joining(", ")));
      pt = conn.prepareStatement(generateSql) ;
      
      int index = 1;
      for (String val : (HashSet<String>)obj)
      {
        pt.setString(index++, (String) val) ;
        
      }
    }
    else
    {
      throw new IllegalArgumentException() ;
    }

    ResultSet rs = pt.executeQuery() ;
    rs.next() ;
    int rowCnt = rs.getInt("ROWCNT") ;

    conn.commit() ;
    pt.close() ;

    return rowCnt ;
  }
  
  
  protected static void trancateTable(Connection conn, String tableName) throws SQLException{
    String sql = String.format(TRUNCATE_SQL, tableName);
    Statement stmt = conn.createStatement();
    
    stmt.execute(sql);
    conn.commit();
    stmt.close();
  }
  
  protected static String getRandomString(int i) 
  { 
      String theAlphaNumericS;
      StringBuilder builder;
      
      theAlphaNumericS = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"; 
      builder = new StringBuilder(i); 

      for (int m = 0; m < i; m++) { 
          int myindex = (int)(theAlphaNumericS.length() * Math.random()); 
          builder.append(theAlphaNumericS.charAt(myindex)); 
      } 

      return builder.toString(); 
  } 
}
