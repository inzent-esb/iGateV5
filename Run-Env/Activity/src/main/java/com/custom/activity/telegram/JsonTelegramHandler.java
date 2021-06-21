/*******************************************************************************
 * This program and the accompanying materials are made
 * available under the terms of the Inzent MCA License v1.0
 * which accompanies this distribution.
 * 
 * Contributors:
 *     Inzent Corporation - initial API and implementation
 *******************************************************************************/
package com.custom.activity.telegram ;

import java.util.Objects ;

import com.fasterxml.jackson.databind.JsonNode ;
import com.inzent.igate.activity.adapter.AbstractTelegramHandler ;
import com.inzent.igate.adapter.AdapterParameter ;
import com.inzent.igate.exception.IGateException ;
import com.inzent.igate.message.HttpConstants;
import com.inzent.igate.message.MessageBeans ;
import com.inzent.igate.message.MessageConverter ;
import com.inzent.igate.message.Record ;
import com.inzent.igate.message.ValueObject;
import com.inzent.igate.repository.meta.Activity ;
import com.inzent.igate.util.Numeric;

/**
 * <code>TelegramHandler</code>
 *
 * @since 2019. 10. 10.
 * @version 5.0
 * @author Jaesuk
 */
public class JsonTelegramHandler extends AbstractTelegramHandler implements CustomHandlerConstants
{
  protected JsonNode header ;

  public JsonTelegramHandler(Activity activity)
  {
    super(activity) ;
  }

  @Override
  public boolean isAck(AdapterParameter adapterParameter) throws IGateException
  {
    return Objects.equals("D", header.path(TELEGRAM_TYPE_FIELD).asText()) ;
  }

  @Override
  public Record makeResponse(AdapterParameter adapterParameter, Throwable throwable) throws IGateException
  {
    return makeResponse(logger, adapterParameter, throwable) ;
  }

  @Override
  protected void analyze(AdapterParameter adapterParameter, boolean request) throws IGateException
  {
    super.analyze(adapterParameter, request) ;

    MessageConverter messageConverter = MessageBeans.SINGLETON.createMessageConverter(adapterParameter.getAdapter(),
        request ? adapterParameter.getRequestData() : adapterParameter.getResponseData()) ;
    Object object = messageConverter.getParseData() ;

    adapterParameter.setConverted(object) ;

    header = ((JsonNode) (object instanceof ValueObject ? ((ValueObject) object).get(HttpConstants.BODY) : object)).path(HEADER_ID).path(STANDARD_HEADER_ID) ;
  }

  @Override
  protected int getTelegramType(AdapterParameter adapterParameter, boolean request) throws IGateException
  {
    switch (header.path(TELEGRAM_TYPE_FIELD).asText())
    {
    case "D" :
    case "R" :
      return RESPONSE_NORMAL ;

    default :
      //RestrictInterface 액티비티에서 제어할 지점
      adapterParameter.setBranch(header.path(BRANCH_FIELD).asText()) ;
      return REQUEST_NORMAL ;
    }
  }

  @Override
  protected String getTransactionId(AdapterParameter adapterParameter, boolean request) throws IGateException  
  { 
    return header.path(TID_FIELD).asText() ;
  }

  @Override
  protected String getMessageId(AdapterParameter adapterParameter, boolean request) throws IGateException
  {
	  String midValue =  header.path(MID_FIELD).asText() ;
	  com.inzent.igate.util.Numeric midNumeric = new Numeric(midValue, null, MID_LENGTH, 0);	  

	  return midNumeric.toString();
	  //return header.path(MID_FIELD).asText() ;
  }

  @Override
  protected String getInterfaceId(AdapterParameter adapterParameter, String messageId) throws IGateException
  {
    return header.path(IID_FIELD).asText() ;
  }

  @Override
  protected boolean isInterfaceResponseSync(AdapterParameter adapterParameter, String messageId)
  {
    return Objects.equals("S", header.path(SYNC_MODE_FIELD).asText()) ;
  }

  @Override
  protected String getServiceId(AdapterParameter adapterParameter, String messageId) throws IGateException
  {
    return header.path(SID_FIELD).asText() ;
  }
  
  @Override
  protected void initializeInterfaceRequest(AdapterParameter adapterParameter) throws IGateException{
    super.initializeInterfaceRequest(adapterParameter);
    
    String interfaceId = adapterParameter.getInterface().getInterfaceId();

    logger.debug("interfaceId : '" + interfaceId + "'");
    logger.debug("TER_LOGIN_INTERFACEID : " + TER_LOGIN_INTERFACEID);
    logger.debug("interfaceId.equals(TER_LOGIN_INTERFACEID) : " + interfaceId.equals(TER_LOGIN_INTERFACEID));
    
    // 세션정보를 세팅한다.
    setSessionInfo(adapterParameter);
    // 로그인거래일 경우 아래값을 세팅하여 공통변수에 넣는다.
    /*if(StringUtils.isNotEmpty(interfaceId) && interfaceId.equals(TER_LOGIN_INTERFACEID)) {
      setSessionInfo(adapterParameter);
    }*/

    // 회기 테트스를 위한 코드
    transactionContextBean.setValue(IP_ADDRESS, adapterParameter.getRemoteAddr()) ;
  }
  
  private void setSessionInfo(AdapterParameter adapterParameter) throws IGateException{
    // 부점정보
    //String brnCd = adapterParameter.getBranch();
    
    // 그룹사코드
    String cmgrCd = header.path(CMGRCD_FIELD).asText() ;
    logger.debug("cmgrCd : " + cmgrCd);
    
    // 직원번호
    String tellerCd = header.path(TELLER_CODE_FIELD).asText() ;
    logger.debug("tellerCd : " + tellerCd);
    
    // 채널코드
    String channelCd = header.path(CHANNELID_FIELD).asText() ;
    logger.debug("channelCd : " + channelCd);
    
    // IP주소
    String ipAddress = header.path(IP_ADDRESS_FIELD).asText() ;
    logger.debug("ipAddress : " + ipAddress);
    
    // MAC 주소
    String macAddress = header.path(MAC_ADDRESS_FIELD).asText() ;
    logger.debug("macAddress : " + macAddress);
    
    // MCI SESSION ID
    String mciSessionId = header.path(SESSIONID_FIELD).asText() ;
    logger.debug("mciSessionId : " + mciSessionId);
    
    // 로그인 처리를 위한 공통변수 세팅.
    transactionContextBean.setValue(CMGRCD, cmgrCd) ;
    transactionContextBean.setValue(TELLER_CODE, tellerCd) ;
    transactionContextBean.setValue(CHANNELID, channelCd) ;
    transactionContextBean.setValue(IP_ADDRESS, ipAddress) ;
    transactionContextBean.setValue(MAC_ADDRESS, macAddress) ;
    transactionContextBean.setValue(SESSIONID, mciSessionId) ;
    
  }
}
