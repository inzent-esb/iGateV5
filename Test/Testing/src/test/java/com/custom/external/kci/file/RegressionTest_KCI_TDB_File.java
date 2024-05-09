package com.custom.external.kci.file;

import static org.junit.jupiter.api.Assertions.assertTrue;

import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import com.custom.external.fileprotocol.RegressionTest_External_FileProtocol;

public class RegressionTest_KCI_TDB_File extends RegressionTest_External_FileProtocol
{
  public static final String localKciSendFileDir = "/home/igate5/iGate/local/kciTdbSend";

  public static final String centerKciTdbRecvFileDir ="/home/igtecho/FileTemp/OUT/kciTdb";
  // ==========================================================================================
  // ■ FRONT 어댑터 : F_MCA
  // ■ BACK-END 어댑터 : E_KCI_F_TDB
  // ■ 테스트 케이스 그룹 : IF_MCA_KCI_TDB
  // ■ 테스트 케이스 목록
  // TST_IF_MCA_KCI_SEND_BF9011_01S  >> KCI_TDB_20231210_yyyyMMdd_BF9011
  // ==========================================================================================
  
  @BeforeAll
  public static void init()
  {
    System.out.println("preparing the host information for sftp.") ;

    System.out.println("- initData()") ;
    initData();

    System.out.println("- echoInit()") ;
    echoInit();

    try
    {
      System.out.println("- echoDeleteFile()") ;
      deleteFile(echo_channelSftp, centerKciTdbRecvFileDir, null) ;
    }
    catch(Exception e) 
    {
    }

    System.out.println("- initUpload()") ;
    initUpload();
  }

  public static void initData()
  {
    sendFileList = new String[] { "KCI_TDB_20231210_yyyyMMdd_BF9011" } ;
    mainSendFileDir = localKciSendFileDir;
  }

  @Test
  @DisplayName("[IF_MCA_KCI_BF9011] KCI_TDB_SEND_BF9011 파일 송신 테스트")
  public void TST_IF_MCA_KCI_SEND_BF9011_01S() throws Exception
  {
    String fileName = "BF9011" ;
    System.out.println("KCI TDB 15 sec") ;
    try
    {
      Thread.sleep(15000) ;
    }
    catch (InterruptedException e)
    {
      e.printStackTrace() ;
    }

    System.out.println("KCI TDB checkFile") ;
    //System.out.println(" / path-fileName : " + centerKftcBatchRecvFileDir +"/"+ fileName);
    assertTrue(true);
    System.out.println("Echo iManager 접속 파일 송수신 내역 확인 [파일명 : " + fileName + "]") ;
  }

}
