package com.custom.activity.telegram ;

import java.text.MessageFormat ;

import org.apache.commons.lang3.StringUtils ;
import org.apache.commons.logging.Log ;

import com.custom.message.CustomMessageConstants ;
import com.inzent.igate.adapter.AdapterParameter ;
import com.inzent.igate.context.TransactionContext ;
import com.inzent.igate.exception.IGateException ;
import com.inzent.igate.message.ArrayImpl ;
import com.inzent.igate.message.IMessageBuilder ;
import com.inzent.igate.message.MessageBeans ;
import com.inzent.igate.message.MessageConverter ;
import com.inzent.igate.message.Record ;
import com.inzent.igate.message.RecordImpl ;
import com.inzent.igate.util.message.MessageTranslator ;

public interface CustomHandlerConstants extends CustomMessageConstants
{
  public static String MID_FIELD = "ProgressNo" ;
  public static String MID_PATH = HEADER_ID + Record.NAME_SEPARATOR_STRING + STANDARD_HEADER_ID + Record.NAME_SEPARATOR_STRING + MID_FIELD ;
  public static int MID_OFFSET = TID_OFFSET + TID_LENGTH ;
  public static int MID_LENGTH = 2 ;

  public static String CMGRCD_FIELD = "CmgrCd" ;
  public static String CMGRCD_PATH = HEADER_ID + Record.NAME_SEPARATOR_STRING + STANDARD_HEADER_ID + Record.NAME_SEPARATOR_STRING + CMGRCD_FIELD ;
  public static int CMGRCD_OFFSET = MID_OFFSET + MID_LENGTH ;
  public static int CMGRCD_LENGTH = 4 ;

  public static String CHANNELID_FIELD = "Channelid" ;
  public static String CHANNELID_PATH = HEADER_ID + Record.NAME_SEPARATOR_STRING + STANDARD_HEADER_ID + Record.NAME_SEPARATOR_STRING + CHANNELID_FIELD ;
  public static int CHANNELID_OFFSET = CMGRCD_OFFSET + CMGRCD_LENGTH ;
  public static int CHANNELID_LENGTH = 2 ;

  public static String SESSIONID_FIELD = "MCIsessionId" ;
  public static String SESSIONID_PATH = HEADER_ID + Record.NAME_SEPARATOR_STRING + STANDARD_HEADER_ID + Record.NAME_SEPARATOR_STRING + SESSIONID_FIELD ;
  public static int SESSIONID_OFFSET = CHANNELID_OFFSET + CHANNELID_LENGTH ;
  public static int SESSIONID_LENGTH = 40 ;

  public static String IP_ADDRESS = "IPADDRESS" ;
  public static String IP_ADDRESS_FIELD = "IpAddress" ;
  public static String IP_ADDRESS_PATH = HEADER_ID + Record.NAME_SEPARATOR_STRING + STANDARD_HEADER_ID + Record.NAME_SEPARATOR_STRING + IP_ADDRESS_FIELD ;
  public static int IP_ADDRESS_OFFSET = SESSIONID_OFFSET + SESSIONID_LENGTH ;
  public static int IP_ADDRESS_LENGTH = 32 ;

  public static String MAC_ADDRESS_FIELD = "MacAddress" ;
  public static String MAC_ADDRESS_PATH = HEADER_ID + Record.NAME_SEPARATOR_STRING + STANDARD_HEADER_ID + Record.NAME_SEPARATOR_STRING + MAC_ADDRESS_FIELD ;
  public static int MAC_ADDRESS_OFFSET = IP_ADDRESS_OFFSET + IP_ADDRESS_LENGTH ;
  public static int MAC_ADDRESS_LENGTH = 12 ;

  public static String BRANCH_FIELD = "TerminalBranch" ;
  public static String BRANCH_PATH = HEADER_ID + Record.NAME_SEPARATOR_STRING + STANDARD_HEADER_ID + Record.NAME_SEPARATOR_STRING + BRANCH_FIELD ;
  public static int BRANCH_OFFSET = MAC_ADDRESS_OFFSET + MAC_ADDRESS_LENGTH ;
  public static int BRANCH_LENGTH = 4 ;

  public static String TELLER_CODE_FIELD = "TellerCd" ;
  public static String TELLER_CODE_PATH = HEADER_ID + Record.NAME_SEPARATOR_STRING + STANDARD_HEADER_ID + Record.NAME_SEPARATOR_STRING + TELLER_CODE_FIELD ;
  public int TELLER_CODE_OFFSET = BRANCH_OFFSET + BRANCH_LENGTH ;
  public int TELLER_CODE_LENGTH = 6 ;

  public static String SYNC_MODE_FIELD = "SyncMode" ; // Sync 구분
  public static String SYNC_MODE_PATH = HEADER_ID + Record.NAME_SEPARATOR_STRING + STANDARD_HEADER_ID + Record.NAME_SEPARATOR_STRING + SYNC_MODE_FIELD ;
  public int SYNC_MODE_OFFSET = TELLER_CODE_OFFSET + TELLER_CODE_LENGTH + 1 ;
  public int SYNC_MODE_LENGTH = 1 ;

  public static String TELEGRAM_TYPE_FIELD = "RequestMode" ;
  public static String TELEGRAM_TYPE_PATH = HEADER_ID + Record.NAME_SEPARATOR_STRING + STANDARD_HEADER_ID + Record.NAME_SEPARATOR_STRING + TELEGRAM_TYPE_FIELD ;
  public static int TELEGRAM_TYPE_OFFSET = SYNC_MODE_OFFSET + SYNC_MODE_LENGTH ;
  public static int TELEGRAM_TYPE_LENGTH = 1 ; // 요청응답구분

  public static String RESPONSE_CODE_FIELD = "ResponseCode" ;
  public static String RESPONSE_CODE_PATH = HEADER_ID + Record.NAME_SEPARATOR_STRING + STANDARD_HEADER_ID + Record.NAME_SEPARATOR_STRING + RESPONSE_CODE_FIELD ;

  public static String IID_FIELD = "InterfaceID" ;
  public static int IID_OFFSET = TELEGRAM_TYPE_OFFSET + TELEGRAM_TYPE_LENGTH + 1 + 2 ;
  public static int IID_LENGTH = 20 ;

  public static String SID_FIELD = "ServiceID" ;
  public static String SID_PATH = HEADER_ID + Record.NAME_SEPARATOR_STRING + STANDARD_HEADER_ID + Record.NAME_SEPARATOR_STRING + SID_FIELD ;
  public static int SID_OFFSET = IID_OFFSET + IID_LENGTH ;
  public static int SID_LENGTH = 20 ;
    
  //채널 헤더 C_RESULT	응답코드
  public static String CHL_RESPONSE_CODE_FIELD = "C_RESULT" ;
  public static String CHL_RESPONSE_CODE_PATH = HEADER_ID + Record.NAME_SEPARATOR_STRING + STANDARD_CHANNEL_HEADER_ID + Record.NAME_SEPARATOR_STRING + CHL_RESPONSE_CODE_FIELD ;
   
  public default Record makeResponse(Log logger, AdapterParameter adapterParameter, Throwable throwable) throws IGateException
  {
    MessageConverter messageConverter = MessageBeans.SINGLETON.createMessageConverter(adapterParameter.getAdapter(), adapterParameter.getRequestData()) ;

    Record record = MessageBeans.SINGLETON.messageBuilder.createInterfaceRequestHeader(messageConverter, null, logger) ;
    messageConverter.parse(record, logger) ;

    String errorCode = MessageTranslator.getStandardCode(throwable) ;

    // 전문해더부
    record.setFieldValue(MID_PATH, ((Number) record.getFieldValue(MID_PATH)).intValue() + 1) ;
    record.setFieldValue(TELEGRAM_TYPE_PATH, "R") ;
    record.setFieldValue(RESPONSE_CODE_PATH, "2") ;
    
    //채널 헤더 C_RESULT	응답코드
    if(record.hasField(CHL_RESPONSE_CODE_PATH) )
    	record.setFieldValue(RESPONSE_CODE_PATH, "99") ;	

    // 에러메세지부
    Record addRecord = ((RecordImpl) record).addIndividualRecord(IMessageBuilder.EMPTY_RECORD, MESSAGE_ID) ;
    Record errorHeader = addRecord.addRecord(DATA_HEADER_RECORD, DATA_HEADER_ID) ;
    errorHeader.setFieldValue(DATA_TYPE_FIELD, DATA_TYPE_MSG_ERROR) ;
    errorHeader.setFieldValue(SERVICE_ID_FIELD, TransactionContext.getValue(TransactionContext.SERVICE, (String) null)) ;

    Record errorBody = addRecord.addRecord(MESSAGE_RECORD, DATA_BODY_ID) ;
    ArrayImpl messageContent = (ArrayImpl) errorBody.getField(MESSAGE_CONTENT_FIELD) ;
    int idx = 0 ;
    for (String message : MessageTranslator.getStandardMessage(errorCode, 
        adapterParameter.getAdapterId(), (String) record.getFieldValue(LANG_CD_PATH)))
    {
      if (StringUtils.isBlank(message))
        break ;

      if (0 == idx)
        message = MessageFormat.format(message, throwable instanceof IGateException ? throwable.getMessage() : throwable.toString()) ;

      messageContent.getField(idx++).setValue(message) ;
    }
    messageContent.offAddMode() ;

    return record ;
  }
}
