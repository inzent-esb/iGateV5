/*******************************************************************************
 * This program and the accompanying materials are made
 * available under the terms of the Inzent MCA License v1.0
 * which accompanies this distribution.
 * 
 * Contributors:
 *     Inzent Corporation - initial API and implementation
 *******************************************************************************/
package com.custom.message ;

import com.inzent.igate.message.Record ;

public interface CustomMessageConstants
{
  public String HEADER_ID = "Header" ;

  public String STANDARD_HEADER_ID = "StandardHeader" ;
  public String STANDARD_HEADER_RECORD = "HDR_STANDARD" ; // 표준 헤더부
  
  
  //채널 헤더
  public String STANDARD_CHANNEL_HEADER_ID = "ChannelHeader" ;
  

  public int STD_HEADER_LENGTH = 220 ; // 전문헤더 220 (길이 8 + GUID 36 + 전문헤더 정보 176 )

  public static String TID_FIELD = "Guid" ;
  public static String TID_PATH = HEADER_ID + Record.NAME_SEPARATOR_STRING + STANDARD_HEADER_ID + Record.NAME_SEPARATOR_STRING + TID_FIELD ;
  public static int TID_OFFSET = 8 ;
  public static int TID_LENGTH = 36 ;
  
  public static String MID_FIELD = "ProgressNo" ;
  
  public static String LANG_CD = "LANGCD" ; // 언어코드
  public static String LANG_CD_FIELD = "LangCd" ; // 언어코드
  public static String LANG_CD_PATH = HEADER_ID + Record.NAME_SEPARATOR_STRING + STANDARD_HEADER_ID + Record.NAME_SEPARATOR_STRING + LANG_CD_FIELD ;
  public static int LANG_CD_FIELD_OFFSET = 150 ;
  public static int LANG_CD_FIELD_LENGTH = 2 ;

  public static final String BODY_ROOT = "Body" ;

  public String DATA_HEADER_ID = "DataHeader" ; // RECORD_DATA
  public String DATA_HEADER_RECORD = "HDR_DATA_HEADER" ; // 표준 데이터공통부
  public String DATA_HEADER_MAPPING = "HMP_DATA_HEADER" ; // HDR_DATA_COMMON -> HDR_DATA_COMMON

  public String DATA_TYPE_FIELD = "DataType" ; // 메시지 종류
  public String DATA_TYPE_DATA = "IO" ; // 개별부
  public String DATA_TYPE_MSG_NORMAL = "MN" ; // 정상메시지
  public String DATA_TYPE_MSG_ERROR = "ER" ; // 에러 메시지
  public int DATA_TYPE_LENGTH = 2 ;
  
  public int DATA_LEN_LENGTH = 8 ; // 길이부

  public String SERVICE_ID_FIELD = "ServiceID";
  public int SERVICE_ID_LENGTH = 20 ;

  public int SCREEN_ID_LENGTH = 12 ;

  public String FORM_COUNT_FIELD = "FormCount" ;
  public int FORM_COUNT_LENGTH = 2 ;

  public String FORM_ID_FIELD = "FormID" ;

  public String DATA_BODY_ID = "DataBody" ; // 개별부

  public String MESSAGE_ID = "Message" ; // 메시지 정보
  public String MESSAGE_RECORD = "HDR_MESSAGE" ; // 메시지부

  public String MESSAGE_CODE_FIELD = "MessageCode" ; //메시지코드
  public String MESSAGE_CONTENT_COUNT_FIELD = "MessageCount" ; // MessageContent 건수
  public String MESSAGE_CONTENT_FIELD = "MessageContent" ; //MessageContent 필드
  
  public static final String PRE_FIX_STD = "I_" ;
  public static final String PRE_FIX_NON = "E_" ;
}
