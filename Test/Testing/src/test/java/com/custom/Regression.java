package com.custom ;

public interface Regression
{
  public static final String TRUNCATE_SQL = "TRUNCATE TABLE %s";
  
  public static final String ASYNC_VALID_JDBC_URL ="";
  public static final String ASYNC_VALID_JDBC_DRIVER = "com.mysql.cj.jdbc.Driver";
  public static final String ASYNC_VALID_JDBC_ID ="";
  public static final String ASYNC_VALID_JDBC_PASSWORD ="";
  public static final String ASYNC_VALID_FLAG = "T";
  
  public static final String COR_JDBC_URL ="";
  public static final String COR_JDBC_DRIVER = "com.mysql.cj.jdbc.Driver";
  public static final String COR_JDBC_ID ="";
  public static final String COR_JDBC_PASSWORD ="";
  
  public static final String EDW_JDBC_URL ="";
  public static final String EDW_JDBC_DRIVER = "oracle.jdbc.driver.OracleDriver";
  public static final String EDW_JDBC_ID ="";
  public static final String EDW_JDBC_PASSWORD ="";
  
  public static final String CONNECTOR_ADDRESS = "tuto.inzent.com" ;
  public static final int TER_CONNECTOR_PORT = 5001 ;
  public static final int ATM_CONNECTOR_PORT = 5011 ;
  public static final int COL_CONNECTOR_PORT = 5021 ;
  public static final int INB_CONNECTOR_PORT = 2002 ;
  public static final int MCA_CONNECTOR_PORT = 20000 ;
  public static final int EDW_CONNECTOR_PORT = 5023 ;
  public static final int REST_CONNECTOR_PORT = 5031 ;
  public static final int ATS_CONNECTOR_PORT = 6060 ;
  public static final int KFTC_API_CONNECTOR_PORT = 6080 ;
  public static final int TIMEOUT = 10000 ;

  public static final String ECHO_CONNECTOR_ADDRESS ="";
  public static final int ECHO_KFB_TAX_CONNECTOR_PORT = 6113 ;
  public static final String echo_username ="";
  public static final String echo_password ="";

  public static final int DATA_LEN_LENGTH = 8 ;
  public static final int RESPONSE_CODE_OFFSET = 149 ;
  public static final int RESPONSE_CODE_LENGTH = 1 ;
  public static final String HEADER_ID = "Header" ;
  public static final String STANDARD_HEADER_ID = "StandardHeader" ;
  public static final String TID_FIELD = "Guid" ;
  public static final String MID_FIELD = "ProgressNo" ;
  public static final String MCA_ESSION_ID_FIELD = "MCIsessionId" ;
  public static final String TELLER_CODE_FIELD = "TellerCd" ;
  public static final String RESPONSE_CODE_FIELD = "ResponseCode" ;
  
  public static final String sftpReadFileDir = "/home/igate5/iGate/sftp/read";
  public static final String sftpWriteFileDir = "/home/igate5/iGate/sftp/write";
  public static final String localReadFileDir = "/home/igate5/iGate/local/read";
  public static final String localWriteFileDir = "/home/igate5/iGate/local/write";
  public static final String[] localFileList = new String[] { "IF_MCA_COM_0130_01S.dat" };
  public static final String[] sftpFileList = new String[] { "IF_COM_MCA_0131_01S.dat" };
  public static final String username ="";
  public static final String password ="";
  public static final int ftpPort = 22;
  
}
