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
import com.inzent.igate.util.Numeric ;
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
  protected String getTransactionId(AdapterParameter adapterParameter, boolean request) throws IGateException
  {
    return StringCodec.decode((byte[]) (request ? adapterParameter.getRequestData() : adapterParameter.getResponseData()), TID_OFFSET, TID_LENGTH, adapterParameter.getAdapter().getCharset()) ;
  }

  @Override
  protected String getMessageId(AdapterParameter adapterParameter, boolean request) throws IGateException
  {
    return new Numeric(StringCodec.decode((byte[]) (request ? adapterParameter.getRequestData() : adapterParameter.getResponseData()),
        MID_OFFSET, MID_LENGTH, adapterParameter.getAdapter().getCharset()), null, MID_LENGTH, 0).toString() ;
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
  protected void initializeInterfaceRequest(AdapterParameter adapterParameter) throws IGateException
  {
    super.initializeInterfaceRequest(adapterParameter) ;

    setSessionInfo(adapterParameter) ;

    // 회기 테트스를 위한 코드
    transactionContextBean.setValue(IP_ADDRESS, adapterParameter.getRemoteAddr()) ;
  }

  protected void setSessionInfo(AdapterParameter adapterParameter) throws IGateException
  {
    // 그룹사코드
    String cmgrCd = StringCodec.decode((byte[]) adapterParameter.getRequestData(), CMGRCD_OFFSET, CMGRCD_LENGTH, adapterParameter.getAdapter().getCharset()) ;
    if (logger.isDebugEnabled())
      logger.debug("cmgrCd : " + cmgrCd) ;

    // 직원번호
    String tellerCd = StringUtils.stripEnd(StringCodec.decode((byte[]) adapterParameter.getRequestData(), TELLER_CODE_OFFSET, TELLER_CODE_LENGTH, adapterParameter.getAdapter().getCharset()), null) ;
    if (logger.isDebugEnabled())
      logger.debug("tellerCd : " + tellerCd) ;

    // 채널코드
    String channelCd = StringUtils.stripEnd(StringCodec.decode((byte[]) adapterParameter.getRequestData(), CHANNELID_OFFSET, CHANNELID_LENGTH, adapterParameter.getAdapter().getCharset()), null) ;
    if (logger.isDebugEnabled())
      logger.debug("channelCd : " + channelCd) ;

    // IP주소
    String ipAddress = StringUtils.stripEnd(StringCodec.decode((byte[]) adapterParameter.getRequestData(), IP_ADDRESS_OFFSET, IP_ADDRESS_LENGTH, adapterParameter.getAdapter().getCharset()), null) ;
    if (logger.isDebugEnabled())
      logger.debug("ipAddress : " + ipAddress) ;

    // MAC 주소
    String macAddress = StringUtils.stripEnd(StringCodec.decode((byte[]) adapterParameter.getRequestData(), MAC_ADDRESS_OFFSET, MAC_ADDRESS_LENGTH, adapterParameter.getAdapter().getCharset()), null) ;
    if (logger.isDebugEnabled())
      logger.debug("macAddress : " + macAddress) ;

    // 로그인 처리를 위한 공통변수 세팅.
    transactionContextBean.setValue(CMGRCD, cmgrCd) ;
    transactionContextBean.setValue(TELLER_CODE, tellerCd) ;
    transactionContextBean.setValue(CHANNELID, channelCd) ;
    transactionContextBean.setValue(IP_ADDRESS, ipAddress) ;
    transactionContextBean.setValue(MAC_ADDRESS, macAddress) ;
  }
}
