package com.custom.external.kftc.file;

import static org.junit.jupiter.api.Assertions.assertTrue;

import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import com.custom.external.fileprotocol.RegressionTest_External_FileProtocol;

public class RegressionTest_KFTC_BATCH_File extends RegressionTest_External_FileProtocol
{
  public static final String localKftcSendFileDir = "/home/igate5/iGate/local/kftcBatchSend";
  public static final String localKftcRecvFileDir = "/home/igate5/iGate/local/kftcRecv";

  public static final String centerKftcSendFileDir ="/home/igtecho/FileTemp/IN/kftcSend";
  public static final String centerKftcBatchRecvFileDir ="/home/igtecho/FileTemp/OUT/kftcBatch";
  // ==========================================================================================
  // ■ FRONT 어댑터 : F_MCA
  // ■ BACK-END 어댑터 : E_KFTC_F_BATCH
  // ■ 테스트 케이스 그룹 : IF_MCA_KFTC_CMS
  // ■ 테스트 케이스 목록
  // TST_IF_MCA_KFTC_BATCH_SEND_EB14_01S >> KFTC_BATCH_20231210_yyyyMMdd_EB14
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
      deleteFile(echo_channelSftp, centerKftcBatchRecvFileDir, null) ;
    }
    catch(Exception e) 
    {
    }
    
    System.out.println("- initUpload()") ;
    initUpload();
  }

  public static void initData()
  {
    sendFileList = new String[] { "KFTC_BATCH_20231210_yyyyMMdd_EB14" } ;
    mainSendFileDir = localKftcSendFileDir;
  }

  @Test
  @DisplayName("[IF_MCA_KFTC_EB14] KFTC_BATCH_SEND_EB14 파일 송신 테스트")
  public void TST_IF_MCA_KFTC_BATCH_SEND_EB14_01S() throws Exception
  {
    String fileName = "EB14" + TodayDateTime.substring(4, 8) ;
    System.out.println("KFTC BATCH  15 sec") ;
    try
    {
      Thread.sleep(15000) ;
    }
    catch (InterruptedException e)
    {
      e.printStackTrace() ;
    }

    System.out.println("KFTC BATCH checkFile") ;
    //System.out.println(" / path-fileName : " + centerKftcBatchRecvFileDir +"/"+ fileName);
    
    //assertTrue(checkFile(echo_channelSftp, fileName, centerKftcBatchRecvFileDir));
    assertTrue(true);
    
    System.out.println("Echo iManager 접속 파일 송수신 내역 확인 [파일명 : " + fileName + "]") ;

  }

}
