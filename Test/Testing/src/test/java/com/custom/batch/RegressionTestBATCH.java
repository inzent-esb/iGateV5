package com.custom.batch ;

import static org.junit.jupiter.api.Assertions.assertEquals ;
import static org.junit.jupiter.api.Assertions.assertTrue ;

import java.io.InputStream ;
import java.sql.DriverManager ;
import java.sql.SQLException ;
import java.text.SimpleDateFormat ;
import java.util.ArrayList ;
import java.util.Date ;
import java.util.HashSet ;
import java.util.Iterator ;
import java.util.List ;
import java.util.Set ;
import java.util.Vector ;

import org.junit.jupiter.api.AfterAll ;
import org.junit.jupiter.api.BeforeAll ;
import org.junit.jupiter.api.DisplayName ;
import org.junit.jupiter.api.Nested ;
import org.junit.jupiter.api.Test ;

import com.custom.RegressionUtils ;
import com.jcraft.jsch.Channel ;
import com.jcraft.jsch.ChannelSftp ;
import com.jcraft.jsch.ChannelSftp.LsEntry ;
import com.jcraft.jsch.JSch ;
import com.jcraft.jsch.Session ;
import com.jcraft.jsch.SftpException ;

import lombok.extern.slf4j.Slf4j ;

@Slf4j
@DisplayName("DB TO DB 거래테스트")
public class RegressionTestBATCH extends RegressionUtils
{

  private static final String COR_EDW_0120_INSERT_QUERY = "insert into COR_0120 values(?, SUBSTR(DATE_FORMAT(NOW(3), '%Y%m%d%h%i%s%f'),1,17), 'TEST', 'N')" ;
  private static final String COR_EDW_0120_EXTRACT_VALID_QUERY = "select COUNT(*) as ROWCNT from IF_COR_0120 where T_RESULT = 'Y' and  TRANCE_CODE in (%s) " ;
  private static final String COR_EDW_0120_LOAD_VALID_QUERY = "select COUNT(*) as ROWCNT from EDW_0120 where TRANCE_CODE in (%s) " ;
  
  private static final String COR_EDW_0121_VALID_QUERY = "select COUNT(*) as ROWCNT from EDW_0121" ;
  
  //UPDATE ASYNC
  private static final String COR_EDW_0122_INSERT_QUERY = "insert into COR_0122 values(?, SUBSTR(DATE_FORMAT(NOW(3), '%Y%m%d%h%i%s%f'),1,17), 'TEST')" ;
  private static final String COR_EDW_0122_EXTRACT_VALID_QUERY = "select COUNT(*) as ROWCNT from IF_COR_0122 where T_RESULT = 'Y' and  TRANCE_CODE in (%s) " ;
  private static final String COR_EDW_0122_LOAD_VALID_QUERY = "select COUNT(*) as ROWCNT from EDW_0122 where TRANCE_CODE in (%s) " ;
  
  //DELETE SYNC
  private static final String COR_EDW_0124_INSERT_QUERY = "insert into COR_0124 values(?, SUBSTR(DATE_FORMAT(NOW(3), '%Y%m%d%h%i%s%f'),1,17), 'TEST')" ;
  private static final String COR_EDW_0124_EXTRACT_VALID_QUERY = "select COUNT(*) as ROWCNT from IF_COR_0124 " ;
  private static final String COR_EDW_0124_LOAD_VALID_QUERY = "select COUNT(*) as ROWCNT from EDW_0124 where TRANCE_CODE in (%s) " ;
  
  //DELETE ASYNC
  private static final String COR_EDW_0125_INSERT_QUERY = "insert into COR_0124 values(?, SUBSTR(DATE_FORMAT(NOW(3), '%Y%m%d%h%i%s%f'),1,17), 'TEST')" ;
  private static final String COR_EDW_0125_EXTRACT_VALID_QUERY = "select COUNT(*) as ROWCNT from IF_COR_0124 " ;
  private static final String COR_EDW_0125_LOAD_VALID_QUERY = "select COUNT(*) as ROWCNT from EDW_0124 where TRANCE_CODE in (%s) " ;
  
  //CHECK POINT
  private static final String COR_EDW_0126_INSERT_QUERY = "insert into COR_0126(T_DATE, ID, NAME, ADDR, DATA) values(now(), ?, SUBSTR(DATE_FORMAT(NOW(3), '%Y%m%d%h%i%s%f'),1,17), 'SEOUL', 'TEST')" ;
  private static final String COR_EDW_0126_LOAD_VALID_QUERY = "select COUNT(*) as ROWCNT from EDW_0126 where ID in (%s) " ;
  
  private static final String COR_EDW_0140_INSERT_QUERY = "insert into COR_0140 values(?, SUBSTR(DATE_FORMAT(NOW(3), '%Y%m%d%h%i%s%f'),1,17), null, 100000,'N')" ;
  private static final String COR_EDW_0140_VALID_QUERY = "select COUNT(*) as ROWCNT from TEST_VALID where DATETIME >= ? and TESTCASE = 'IF_COR_EDW_0140' and KEY_01 = ? and RESULT = 'Y' " ;
  
  private static final String COR_EDW_0142_INSERT_QUERY = "INSERT INTO COR_0142 (name, age, tel, addr001, addr002, product01, product02, temp) VALUES(?, '35', '111-1111-1111', '서울시', '강남구', 'RND Center', 'iGate R&D', '해당없음')";
  private static final String COR_EDW_0143_VALID_QUERY = "select COUNT(*) as ROWCNT from TEST_VALID where DATETIME >= ? and TESTCASE = 'IF_COM_EDW_0143' and KEY_01 in ('홍길동','스미스','주걸륜','워싱턴') and RESULT = 'Y' " ;
  private static final String COM_COR_0144_VALID_QUERY = "select COUNT(*) as ROWCNT from COR_0144" ;

  private static final String ASYNC_VALID_TABLE = "TEST_VALID";
  // private static final String COR_EDW_0121_EXTRACT_TABLE = "COR_0121" ;
  private static final String COR_EDW_0121_LOAD_TABLE = "EDW_0121" ;
  private static final String COM_COR_0144_LOAD_TABLE = "COR_0144" ;
  private static final String COR_EDW_0120_LOAD_TABLE = "EDW_0120" ; 

  private static SimpleDateFormat dataFormat = new SimpleDateFormat("yyyyMMddhhmmssSSS") ;
  
  // Database
  private static final Set<String> FETCHCODESET = new HashSet<String>() ;
  private static final Set<String> ROWCODESET = new HashSet<String>() ;
  private static String FIRSTCODE ;
  private static String FIRSTTIME ;
  private static String STARTTIME ;

  // FILE
  public static final String[] localFileList = new String[] {"IF_MCA_COM_0130_01S.dat"} ;
  public static final String[] sftpFileList = new String[] { "IF_COM_MCA_0131_01S.dat", "IF_COM_EDW_0143_01S.dat", "IF_COM_COR_0144_01S.dat" } ;
  private static Session session = null ;
  private static Channel channel = null ;
  private static ChannelSftp channelSftp = null ;

  // BATCh
  private static final int DEFFERRED_TIME = 90 ;
  private static final int FETCHCOUNT = 100 ;
  private static final int ROWCOUNT = 10 ;

  // 테스트 초기화
  @SuppressWarnings("rawtypes")
  @BeforeAll
  public static void initBatch()
  {

    STARTTIME = dataFormat.format(new Date());
    log.info("preparing the host information for sftp.") ;
    try
    {
      // sftp 연결
      JSch jsch = new JSch() ;
      session = jsch.getSession(USERNAME, CONNECTOR_ADDRESS, ftpPort) ;
      session.setPassword(PASSWORD) ;
      java.util.Properties config = new java.util.Properties() ;
      config.put("StrictHostKeyChecking", "no") ;
      session.setConfig(config) ;
      session.connect() ;
      channel = session.openChannel("sftp") ;
      channel.connect() ;
      channelSftp = (ChannelSftp) channel ;
      // sftp 연결

      // 기존파일 삭제
      Vector fileList = null ;
      List<String> fileNameList = new ArrayList<String>() ;
      fileList = channelSftp.ls(localWriteFileDir) ;
      channelSftp.cd(localWriteFileDir) ;
      Iterator it = fileList.iterator() ;
      while (it.hasNext())
      {
        String fileName = ((LsEntry) it.next()).getFilename() ;
        if (".".equals(fileName) || "..".equals(fileName))
        {
          continue ;
        }
        fileNameList.add(fileName) ;
      }

      for (String deleteFile : fileNameList)
      {
        channelSftp.rm(deleteFile) ;
      }
      // 기존파일 삭제

      // 기존파일 삭제
      fileList = null ;
      fileNameList = new ArrayList<String>() ;
      fileList = channelSftp.ls(sftpWriteFileDir) ;
      channelSftp.cd(sftpWriteFileDir) ;
      it = fileList.iterator() ;
      while (it.hasNext())
      {
        String fileName = ((LsEntry) it.next()).getFilename() ;
        if (".".equals(fileName) || "..".equals(fileName))
        {
          continue ;
        }
        fileNameList.add(fileName) ;
      }

      for (String deleteFile : fileNameList)
      {
        channelSftp.rm(deleteFile) ;
      }
      // 기존파일 삭제

      // 테스트용 파일 업로드
      channelSftp.cd(sftpReadFileDir) ;
      for (String fn : sftpFileList)
      {
        try(InputStream in = RegressionTestBATCH.class.getResourceAsStream("/tst/" + fn) ){
          channelSftp.put(in, fn) ;
        }
      }

      // 테스트용 파일 업로드
      channelSftp.cd(localReadFileDir) ;
      for (String fn : localFileList)
      {
        try(InputStream in = RegressionTestBATCH.class.getResourceAsStream("/tst/" + fn) ){
          channelSftp.put(in, fn) ;
        }
      }
      // 테스트용 파일 업로드

    }
    catch (Exception ex)
    {
      log.info(ex.toString()) ;
      log.info("Exception found while tranfer the response.") ;
    }
    finally
    {
      // channelSftp.exit();
      // channel.disconnect();
      // session.disconnect();
    }
    
    try
    {
      Class.forName(ASYNC_VALID_JDBC_DRIVER) ;
      Class.forName(COR_JDBC_DRIVER) ;
      Class.forName(EDW_JDBC_DRIVER) ;
      
      try
      {
        asyncValidConnection = DriverManager.getConnection(ASYNC_VALID_JDBC_URL, ASYNC_VALID_JDBC_ID, ASYNC_VALID_JDBC_PASSWORD) ;
        asyncValidConnection.setAutoCommit(false) ;
      }
      catch (SQLException e)
      {
        e.printStackTrace() ;
      }

      try
      {
        extractConnection = DriverManager.getConnection(COR_JDBC_URL, COR_JDBC_ID, COR_JDBC_PASSWORD) ;
        extractConnection.setAutoCommit(false) ;
      }
      catch (SQLException e)
      {
        e.printStackTrace() ;
      }

      try
      {
        loadConnection = DriverManager.getConnection(EDW_JDBC_URL, EDW_JDBC_ID, EDW_JDBC_PASSWORD) ;
        loadConnection.setAutoCommit(false) ;
      }
      catch (SQLException e)
      {
        e.printStackTrace() ;
      }

      boolean isFirst = true ;
      while (FETCHCODESET.size() < FETCHCOUNT)
      {
        String code = getRandomString(10) ;
        FETCHCODESET.add(code) ;
        if (isFirst)
        {
          FIRSTCODE = code ;
          FIRSTTIME = new SimpleDateFormat("yyyyMMddhhmmssSSS").format(new Date()) ;
          isFirst = false ;
        }
      }

      while (ROWCODESET.size() < ROWCOUNT)
      {
        String code = getRandomString(10) ;
        ROWCODESET.add(code) ;
      }
      try
      {
        trancateTable(asyncValidConnection, ASYNC_VALID_TABLE);
        trancateTable(extractConnection, COM_COR_0144_LOAD_TABLE);
        trancateTable(loadConnection, COR_EDW_0121_LOAD_TABLE) ;
        
        insertData(extractConnection, COR_EDW_0142_INSERT_QUERY, FIRSTCODE) ;
        insertData(extractConnection, COR_EDW_0140_INSERT_QUERY, FIRSTCODE) ;
        insertData(extractConnection, COR_EDW_0120_INSERT_QUERY, FETCHCODESET) ;
        insertData(extractConnection, COR_EDW_0122_INSERT_QUERY, FETCHCODESET) ;
        insertData(extractConnection, COR_EDW_0124_INSERT_QUERY, FETCHCODESET) ;
        insertData(extractConnection, COR_EDW_0125_INSERT_QUERY, FETCHCODESET) ;
        insertData(extractConnection, COR_EDW_0126_INSERT_QUERY, FETCHCODESET) ;
      }
      catch (SQLException e)
      {
        e.printStackTrace() ;
      }

      log.info("Waiting Batch Process ( " + DEFFERRED_TIME + " s )");
      Thread.sleep(DEFFERRED_TIME * 1000) ;

    }
    catch (ClassNotFoundException e)
    {
      e.printStackTrace() ;
    }
    catch (InterruptedException e)
    {
      e.printStackTrace() ;
    }
  }

  @AfterAll
  public static void destory()
  {
    try
    {
      if (loadConnection != null && !loadConnection.isClosed())
        loadConnection.close() ;
    }
    catch (Exception e)
    {
      e.printStackTrace() ;
    }
    try
    {
      if (extractConnection != null && !extractConnection.isClosed())
        extractConnection.close() ;
    }
    catch (Exception e)
    {
      e.printStackTrace() ;
    }
    try
    {
      if (asyncValidConnection != null && !asyncValidConnection.isClosed())
        asyncValidConnection.close() ;
    }
    catch (Exception e)
    {
      e.printStackTrace() ;
    }

    channelSftp.exit() ;
    channel.disconnect() ;
    session.disconnect() ;
  }
  
  @SuppressWarnings("unchecked")
  public boolean checkFile(String fileName, String path)
  {
    // fileName+"*.Response"

    try
    {
      Vector<ChannelSftp.LsEntry> fileAndFolderList = channelSftp.ls(path) ;
      for (ChannelSftp.LsEntry item : fileAndFolderList)
      {
        if (item.getFilename().contains(fileName))
          if (item.getFilename().contains(".Response"))
            return true ;
      }
    }
    catch (SftpException e)
    {
      e.printStackTrace() ;
    }

    return false ;
  }

  /**
   * DB TO AP는 처리완료 여부를 인터페이스 테이블의 결과를 가지고 판단.
   */
  @Nested
  @DisplayName("DB TO AP")
  class DBTOAP
  {

    @Test // DB2AP SYNC
    @DisplayName("[IF_COR_EDW_0140] DB TO AP 동기거래 테스트 ")
    public void TST_IF_COR_EDW_0140_01S() throws Exception
    {
      List<String> list = new ArrayList<String>();
      list.add(STARTTIME);
      list.add(FIRSTCODE);
      assertEquals(validData(extractConnection, COR_EDW_0140_VALID_QUERY, list ), 1) ;
      
      
    }

  }

  /**
   * DB TO DB는 인터페이스 테이블 처리결과값을 기준으로 확인.
   */
  @Nested
  @DisplayName("DB TO DB")
  class DBTODB
  {
    @Test
    @DisplayName("[IF_COR_EDW_0120] DB TO DB 거래 테스트 [Update Sync] ")
    public void TST_IF_COR_EDW_0120_01S() throws Exception
    {
      assertEquals(validData(extractConnection, COR_EDW_0120_EXTRACT_VALID_QUERY, FETCHCODESET), FETCHCOUNT) ;
      assertEquals(validData(loadConnection, COR_EDW_0120_LOAD_VALID_QUERY, FETCHCODESET), FETCHCOUNT) ;
    }
    
    @Test
    @DisplayName("[IF_COR_EDW_0122] DB TO DB 거래 테스트 [Update ASync]")
    public void TST_IF_COR_EDW_0122_01S() throws Exception
    {
      assertEquals(validData(extractConnection, COR_EDW_0122_EXTRACT_VALID_QUERY, FETCHCODESET), FETCHCOUNT) ;
      assertEquals(validData(loadConnection, COR_EDW_0122_LOAD_VALID_QUERY, FETCHCODESET), FETCHCOUNT) ;
    }
    
    @Test
    @DisplayName("[IF_COR_EDW_0124] DB TO DB 거래 테스트 [Delete Sync]")
    public void TST_IF_COR_EDW_0124_01S() throws Exception
    {
      assertEquals(validData(extractConnection, COR_EDW_0124_EXTRACT_VALID_QUERY, null), 0) ;
      assertEquals(validData(loadConnection, COR_EDW_0124_LOAD_VALID_QUERY, FETCHCODESET), FETCHCOUNT) ;
    }
    
    @Test
    @DisplayName("[IF_COR_EDW_0125] DB TO DB 거래 테스트 [Delete ASync]")
    public void TST_IF_COR_EDW_0125_01S() throws Exception
    {
      assertEquals(validData(extractConnection, COR_EDW_0125_EXTRACT_VALID_QUERY, null), 0) ;
      assertEquals(validData(loadConnection, COR_EDW_0125_LOAD_VALID_QUERY, FETCHCODESET), FETCHCOUNT) ;
    }
    
    @Test
    @DisplayName("[IF_COR_EDW_0126] DB TO DB 거래 테스트 [Check Point]")
    public void TST_IF_COR_EDW_0126_01S() throws Exception
    {
      assertEquals(validData(loadConnection, COR_EDW_0126_LOAD_VALID_QUERY, FETCHCODESET), FETCHCOUNT) ;
    }
  }

  /**
   * AP TO DB는 HTTP응답의 ResponseCode 값으로 정상처리 확인
   */
  @Nested
  @DisplayName("AP TO DB")
  class APTODB
  {

    @Test //
    @DisplayName("[IF_EDW_COR_0141] AP TO DB 동기거래 테스트 ")
    public void TST_IF_EDW_COR_0141_01S() throws Exception
    {
      String[] bindList = { FIRSTCODE, FIRSTTIME, dataFormat.format(new Date()) } ;
      EDW_tester("IF_EDW_COR_0141_01S.dat", "0", bindList, INSTANCE_2_SOCKET_OFFSET) ;
      assertTrue(true) ; 
    }
  }

  /**
   * DB TO DB는 인터페이스 테이블이 없음으로 수신 DB 적재 개수로 확인.
   */
  @Nested
  @DisplayName("DB TRIGGER")
  class TRIGGER
  {
    @Test // DB2AP SYNC
    @DisplayName("[IF_COR_EDW_0121] Trigger 동기거래 테스트 ")
    public void TST_IF_COR_EDW_0121_01S() throws Exception
    {

      MCA_tester("IF_COR_EDW_0121_01S.dat", "0") ;

      Thread.sleep(5000) ;

      assertEquals(validData(loadConnection, COR_EDW_0121_VALID_QUERY, null), 100) ;
    }
  }

  // 업로드된 파일 확인
  // local 2 sftp FILETEST1
  @Nested
  @DisplayName("Local TO SFTP")
  class Local2SFTP
  {

    @Test
    @DisplayName("[IF_MCA_COM_0130] Local TO SFTP 파일거래 테스트")
    public void TST_IF_MCA_COM_0130_01S() throws Exception
    {
      assertEquals(checkFile("IF_MCA_COM_0130_01S.dat", sftpWriteFileDir), true) ;
    }

  }

  // sftp 2 local FILETEST2
  @Nested
  @DisplayName("SFTP TO Local")
  class SFTP2Local
  {

    @Test
    @DisplayName("[IF_COM_MCA_0131] SFTP TO Local 파일거래 테스트")
    public void TST_IF_COM_MCA_0131_01S() throws Exception
    {
      assertEquals(checkFile("IF_COM_MCA_0131_01S.dat", localWriteFileDir), true) ;
    }

  }
  

  @Nested
  @DisplayName("DB TO SFTP")
  class DB2SFTP
  {
    @Test
    @DisplayName("[IF_COR_COM_0142] DB - SFTP 테스트")
    public void TST_IF_COR_COM_0142_01S() throws Exception
    {
      assertEquals(checkFile("IF_COR_COM_0142", sftpWriteFileDir), true) ;
    }
    
    
  }
  
  @Nested
  @DisplayName("SFTP TO AP")
  class SFTP2AP
  {
    @Test
    @DisplayName("[IF_COM_EDW_0143] SFTP TO Online 테스트")
    public void TST_IF_COM_EDW_0143_01S() throws Exception
    {
      assertEquals(validData(asyncValidConnection, COR_EDW_0143_VALID_QUERY, STARTTIME), 4) ;
    }
    
    
  }
  
  @Nested
  @DisplayName("SFTP TO DB")
  class SFTP2DB
  {
    @Test
    @DisplayName("[IF_COM_COR_0144] SFTP TO Database 테스트")
    public void TST_IF_COM_COR_0144_01S() throws Exception
    {
      assertEquals(validData(extractConnection, COM_COR_0144_VALID_QUERY, null), 4) ;
    }
  }
  
}
