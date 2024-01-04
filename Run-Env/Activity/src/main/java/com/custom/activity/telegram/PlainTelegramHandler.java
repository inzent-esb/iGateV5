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

import org.apache.commons.lang3.StringUtils ;

import com.inzent.igate.activity.adapter.AbstractTelegramHandler ;
import com.inzent.igate.adapter.AdapterParameter ;
import com.inzent.igate.exception.IGateException ;
import com.inzent.igate.message.Record ;
import com.inzent.igate.repository.meta.Activity ;
import com.inzent.igate.util.StringCodec ;

/**
 * <code>TelegramHandler</code>
 */
public class PlainTelegramHandler extends AbstractTelegramHandler implements CustomHandlerConstants
{
  public PlainTelegramHandler(Activity activity)
  {
    super(activity) ;
  }

  @Override
  public boolean isAck(AdapterParameter adapterParameter) throws IGateException
  {
    return Objects.equals("D", StringCodec.decode((byte[]) adapterParameter.getResponseData(), TELEGRAM_TYPE_OFFSET, TELEGRAM_TYPE_LENGTH, adapterParameter.getAdapter().getCharset())) ;
  }

  @Override
  public Record makeResponse(AdapterParameter adapterParameter, Throwable throwable) throws IGateException
  {
    return makeResponse(logger, adapterParameter, throwable) ;
  }

  @Override
  protected int getTelegramType(AdapterParameter adapterParameter, boolean request) throws IGateException
  {
    byte[] buffer = (byte[]) (request ? adapterParameter.getRequestData() : adapterParameter.getResponseData()) ;
    switch (StringCodec.decode(buffer, TELEGRAM_TYPE_OFFSET, TELEGRAM_TYPE_LENGTH, adapterParameter.getAdapter().getCharset()))
    {
    case "D" :
    case "R" :
      return RESPONSE_NORMAL ;

    case "B" : // 원인없는 BID (PUSH) 세팅
      return PUSH_NORMAL ;

    default :
      // RestrictInterface 액티비티에서 제어할 지점
      adapterParameter.setBranch(StringCodec.decode(buffer, BRANCH_OFFSET, BRANCH_LENGTH, adapterParameter.getAdapter().getCharset())) ;
      return REQUEST_NORMAL ;
    }
  }

  @Override
  protected void initializeInterfaceRequest(AdapterParameter adapterParameter) throws IGateException
  {
    super.initializeInterfaceRequest(adapterParameter) ;

    // 회기 테트스를 위한 코드
    if(!adapterParameter.getAdapter().getAdapterId().startsWith(PRE_FIX_STD) || 
        !isInterfaceResponseSync(adapterParameter, getMessageId(adapterParameter, true)))
    {      
      transactionContextBean.setValue(IP_ADDRESS, adapterParameter.getRemoteAddr()) ;
    }
  }

  @Override
  protected String getTransactionId(AdapterParameter adapterParameter, boolean request) throws IGateException
  {
    return StringCodec.decode((byte[]) (request ? adapterParameter.getRequestData() : adapterParameter.getResponseData()), TID_OFFSET, TID_LENGTH, adapterParameter.getAdapter().getCharset()) ;
  }

  @Override
  protected String getMessageId(AdapterParameter adapterParameter, boolean request) throws IGateException
  {
    return StringCodec.decode((byte[]) (request ? adapterParameter.getRequestData() : adapterParameter.getResponseData()),
        MID_OFFSET, MID_LENGTH, adapterParameter.getAdapter().getCharset()) ;
  }

  @Override
  protected String getInterfaceId(AdapterParameter adapterParameter, String messageId) throws IGateException
  {
    return StringUtils.stripEnd(StringCodec.decode((byte[]) adapterParameter.getRequestData(), IID_OFFSET, IID_LENGTH, adapterParameter.getAdapter().getCharset()), null) ;
  }

  @Override
  protected boolean isInterfaceResponseSync(AdapterParameter adapterParameter, String messageId) throws IGateException
  {
    return Objects.equals("S", StringCodec.decode((byte[]) adapterParameter.getRequestData(), SYNC_MODE_OFFSET, 1, adapterParameter.getAdapter().getCharset())) ;
  }

  @Override
  protected String getServiceId(AdapterParameter adapterParameter, String messageId) throws IGateException
  {
    return StringUtils.stripEnd(StringCodec.decode((byte[]) adapterParameter.getResponseData(), SID_OFFSET, SID_LENGTH, adapterParameter.getAdapter().getCharset()), null) ;
  }

  @Override
  protected void analyze(AdapterParameter adapterParameter, boolean request) throws IGateException
  {
	  //transactionContextBean.setValue(LANG_CD, StringCodec.decode((byte[]) (request ? adapterParameter.getRequestData() : adapterParameter.getResponseData()), LANG_CD_FIELD_OFFSET, LANG_CD_FIELD_LENGTH, adapterParameter.getAdapter().getCharset()) ) ;
  }
}
