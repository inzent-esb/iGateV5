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
    MessageConverter messageConverter = MessageBeans.SINGLETON.createMessageConverter(adapterParameter.getAdapter(),
        request ? adapterParameter.getRequestData() : adapterParameter.getResponseData()) ;
    Object object = messageConverter.getParseData() ;

    adapterParameter.setConverted(object) ;

    header = ((JsonNode) (object instanceof ValueObject ? ((ValueObject) object).get(HttpConstants.BODY) : object)).path(HEADER_ID).path(STANDARD_HEADER_ID) ;
    
    //transactionContextBean.setValue(LANG_CD, header.path(LANG_CD_FIELD).asText()) ;
  }

  @Override
  protected int getTelegramType(AdapterParameter adapterParameter, boolean request) throws IGateException
  {
    switch (header.path(TELEGRAM_TYPE_FIELD).asText())
    {
    case "D" :
    case "R" :
      return RESPONSE_NORMAL ;

    case "B" : // 원인없는 BID (PUSH) 세팅
      return PUSH_NORMAL ;

    default :
      //RestrictInterface 액티비티에서 제어할 지점
      adapterParameter.setBranch(header.path(BRANCH_FIELD).asText()) ;
      return REQUEST_NORMAL ;
    }
  }

  @Override
  protected void initializeInterfaceRequest(AdapterParameter adapterParameter) throws IGateException
  {
    super.initializeInterfaceRequest(adapterParameter) ;

    // 회기 테트스를 위한 코드
    transactionContextBean.setValue(IP_ADDRESS, adapterParameter.getRemoteAddr()) ;
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
}
