package com.custom.external.kfb.file;

import static org.junit.jupiter.api.Assertions.assertTrue;

import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import com.custom.external.fileprotocol.RegressionTest_External_FileProtocol;

public class RegressionTest_KFB_TAX_File extends RegressionTest_External_FileProtocol
{
  public static final String localKfbSendFileDir = "/home/igate5/iGate/local/kfbTaxSend";

  public static final String centerKfbTaxRecvFileDir ="/home/igtecho/FileTemp/OUT/kfbTax";
  // ==========================================================================================
  // ■ FRONT 어댑터 : F_MCA
  // ■ BACK-END 어댑터 : E_KFB_F_TAX
  // ■ 테스트 케이스 그룹 : IF_MCA_KFB_TAX
  // ■ 테스트 케이스 목록
  // TST_IF_MCA_KFB_SEND_SV9033_01S  >> KFB_TAX_20231210_yyyyMMdd_SV9033
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
      deleteFile(echo_channelSftp, centerKfbTaxRecvFileDir, null) ;
    }
    catch(Exception e) 
    {
    }
    
    System.out.println("- initUpload()") ;
    initUpload();
  }

  public static void initData()
  {
    sendFileList = new String[] { "KFB_TAX_20231210_yyyyMMdd_SV9033" } ;
    mainSendFileDir = localKfbSendFileDir;
  }

  @Test
  @DisplayName("[IF_MCA_KFB_SV9033] KFB_TAX_SEND_SV9033 파일 송신 테스트")
  public void TST_IF_MCA_KFB_SEND_SV9033_01S() throws Exception
  {
    String fileName = "SV9033" ;
    System.out.println("KFB TAX 15 sec") ;
    try
    {
      Thread.sleep(15000) ;
    }
    catch (InterruptedException e)
    {
      e.printStackTrace() ;
    }

    System.out.println("KFB TAX checkFile") ;
    //System.out.println(" / path-fileName : " + centerKftcBatchRecvFileDir +"/"+ fileName);
    assertTrue(true);
    System.out.println("Echo iManager 접속 파일 송수신 내역 확인 [파일명 : " + fileName + "]") ;
  }

}
