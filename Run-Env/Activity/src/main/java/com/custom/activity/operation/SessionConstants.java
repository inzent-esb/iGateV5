package com.custom.activity.operation;

public interface SessionConstants {
  
  
  public static final String DEFAULT_LOGOFF_DT = "99991231235959999";
  

  public static final String SELECT_SESSION_CHECK_QUERY = "from EchoUserSession\r\n" + 
          "WHERE tellerCd = :TELLER_CD \r\n" + 
          "and logoffDt = :LOGOFF_DT \r\n" + 
          "and loginFlag = :LOGIN_FLAG ";
  
  public static final String UPDATE_SESSION_LOGOFF_QUERY = "update EchoUserSession \r\n"
          + "set pk.logoffDt = :LOGOFF_NEW_DT , loginFlag = :LOGOFF_FLAG \r\n"
          + "WHERE pk.tellerCd = :TELLER_CD \r\n" 
          + "and pk.logoffDt = :LOGOFF_DT \r\n" 
          //+ "and loginFlag = :LOGIN_FLAG "
          ;
}
