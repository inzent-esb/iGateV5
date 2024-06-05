package com.custom.external.fileprotocol ;

import java.io.InputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Vector;

import org.junit.jupiter.api.AfterAll;
import org.junit.jupiter.api.DisplayName;

import com.custom.RegressionUtils;
import com.jcraft.jsch.Channel ;
import com.jcraft.jsch.ChannelSftp ;
import com.jcraft.jsch.ChannelSftp.LsEntry;
import com.jcraft.jsch.JSch ;
import com.jcraft.jsch.JSchException ;
import com.jcraft.jsch.Session ;
import com.jcraft.jsch.SftpException ;

@DisplayName("대외 파일 거래테스트")
public abstract class RegressionTest_External_FileProtocol extends RegressionUtils
{
  protected static Session session = null ;
  protected static Channel channel = null ;
  protected static ChannelSftp channelSftp = null ;


  protected static Session echo_session = null ;
  protected static Channel echo_channel = null ;
  protected static ChannelSftp echo_channelSftp = null ;

  protected static final SimpleDateFormat dataFormat = new SimpleDateFormat("yyyyMMddhhmmssSSS") ;
  protected static String TodayDateTime  = dataFormat.format(new Date());
  public static String[] sendFileList = new String[] { } ;
  public static String mainSendFileDir = null;
  public static String echoRecvFileDir = null;

  //  @BeforeAll
  public static void initUpload()
  {
    System.out.println("-- mainInit()") ;
    mainInit();

    System.out.println("-- mainFileUpload()") ;
    mainFileUpload();

    try
    {
      Thread.sleep(10000) ;
    }
    catch (InterruptedException e)
    {
      e.printStackTrace() ;
    }
  }

  public static void echoInit()
  {
    JSch jsch = new JSch() ;
    try
    {
      echo_session = jsch.getSession(ECHO_USERNAME, ECHO_CONNECTOR_ADDRESS, ftpPort) ;
      echo_session.setPassword(ECHO_PASSWORD) ;

      java.util.Properties config = new java.util.Properties() ;
      config.put("StrictHostKeyChecking", "no") ;
      echo_session.setConfig(config) ;
      echo_session.connect() ;

      echo_channel = echo_session.openChannel("sftp") ;
      echo_channel.connect() ;
    }
    catch (JSchException e)
    {
      System.out.println("- echoInit() >>> --- Fail ---") ;
      e.printStackTrace() ;
    }

    echo_channelSftp = (ChannelSftp) echo_channel ;
  }
  

  public static void deleteFile(ChannelSftp chlSftp, String FileDir, String delFileName)
  {
    try
    {
      // 기존파일 삭제
      Vector fileList = null ;
      List<String> fileNameList = new ArrayList<String>() ;
      fileList = chlSftp.ls(FileDir) ;
      chlSftp.cd(FileDir) ;
      for (Object o : fileList)
      {
        String fileName = ((LsEntry) o).getFilename();
        if (".".equals(fileName) || "..".equals(fileName))
          continue;
        
        if( delFileName!=null )
        {
          if( fileName.equals(delFileName))
            fileNameList.add(fileName);    
        }
        else
          fileNameList.add(fileName);        
      }
      if (fileNameList.size() > 0 )       
    	System.out.println("### Directory to sftp : " + FileDir ) ;
      for (String deleteFile : fileNameList)
      {
        System.out.println("### Deleting file to sftp : " + deleteFile) ;
        chlSftp.rm(deleteFile) ;
      }
    }
    catch (SftpException e)
    {
      e.printStackTrace() ;
    }
 
  }
  
  public static void mainInit()
  {
    // sftp 연결 시작
    JSch jsch = new JSch() ;
    try
    {
      session = jsch.getSession(USERNAME, CONNECTOR_ADDRESS, ftpPort) ;
      session.setPassword(PASSWORD) ;

      java.util.Properties config = new java.util.Properties() ;
      config.put("StrictHostKeyChecking", "no") ;
      session.setConfig(config) ;
      session.connect() ;
      channel = session.openChannel("sftp") ;
      channel.connect() ;

    }
    catch (JSchException e)
    {
      e.printStackTrace() ;
    }
    channelSftp = (ChannelSftp) channel ;
    // sftp 연결
    try
    {
      // 기존파일 삭제
      Vector fileList = null ;
      List<String> fileNameList = new ArrayList<String>() ;
      fileList = channelSftp.ls(mainSendFileDir) ;
      channelSftp.cd(mainSendFileDir) ;
      for (Object o : fileList)
      {
        String fileName = ((LsEntry) o).getFilename();
        if (".".equals(fileName) || "..".equals(fileName))
          continue;
        fileNameList.add(fileName);
      }
      if (fileNameList.size() > 0 )       
    	System.out.println("### Directory to sftp : " + mainSendFileDir ) ;
      for (String deleteFile : fileNameList)
      {
        System.out.println("### Deleting file to sftp : " + deleteFile) ;
        channelSftp.rm(deleteFile) ;
      }
    }
    catch (SftpException e)
    {
      e.printStackTrace() ;
    }
  }

  public static void mainFileUpload()
  {
    try{
      // 테스트용 파일 업로드
      channelSftp.cd(mainSendFileDir) ;
      for (String fn : sendFileList)
      {
        InputStream a = RegressionTest_External_FileProtocol.class.getResourceAsStream("/tst/" + fn) ;
        String sendFileName = fn.replace("yyyyMMdd", TodayDateTime.substring(0, 8));

        System.out.println("### Uploading file to sftp : " + mainSendFileDir + "/" + sendFileName) ;
        channelSftp.put(a, sendFileName) ;
      }
    }
    catch (Exception ex)
    {
      System.out.println(ex.toString()) ;
      System.out.println("Exception found while tranfer the response.") ;
    }
    finally
    {
      ;
    }
  }

/*
    @Test
    @DisplayName("[IF_MCA_FILE] 파일 송신 테스트")
    public void TST_IF_MCA_FILE_01S() throws Exception
    {
      String fileName = "EB00" + TodayDateTime.substring(4, 8) ;
      System.out.println("FILE  10 sec") ;
      try
      {
        Thread.sleep(10000) ;
      }
      catch (InterruptedException e)
      {
        e.printStackTrace() ;
      }

      System.out.println("FILEcheckFile") ;
      //System.out.println(" / path-fileName : " + centerKftcBatchRecvFileDir +"/"+ fileName);
      assertTrue(checkFile(echo_channelSftp, fileName, echoRecvFileDir));
    }
*/

  @AfterAll
  public static void closeSFTP()
  {
    System.out.println("- mainCloseSFTP()") ;
    mainCloseSFTP();

    System.out.println("- echoCloseSFTP()") ;
    echoCloseSFTP();
  }

  public static void mainCloseSFTP()
  {
    channelSftp.exit() ;
    channel.disconnect() ;
    session.disconnect() ;
  }

  public static void echoCloseSFTP()
  {
    if (echo_channelSftp != null)
      echo_channelSftp.exit() ;
    
    if (echo_channel != null)
      echo_channel.disconnect() ;
    
    if (echo_session != null)
      echo_session.disconnect() ;
  }

  @SuppressWarnings("unchecked")
  public boolean checkFile( ChannelSftp chlSftp, String fileName, String path)
  {
    System.out.print(" - checkFile / filePath : " +  path +"/" + fileName );
    try
    {
      Vector<ChannelSftp.LsEntry> fileAndFolderList = chlSftp.ls(path) ;
      for (ChannelSftp.LsEntry item : fileAndFolderList)
      {
        if (item.getFilename().contains(fileName))
        {
          System.out.println(" >> true " );
          return true;
        }
      }
    }
    catch (SftpException e)
    {
      e.printStackTrace() ;
    }
    System.out.println(" >> false " );
    return false ;
 }

}

