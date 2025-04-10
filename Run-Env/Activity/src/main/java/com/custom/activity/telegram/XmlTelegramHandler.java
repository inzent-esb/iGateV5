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

import org.dom4j.Document ;
import org.dom4j.Element ;

import com.inzent.igate.activity.adapter.AbstractTelegramHandler ;
import com.inzent.igate.adapter.AdapterParameter ;
import com.inzent.igate.exception.IGateException ;
import com.inzent.igate.message.HttpConstants ;
import com.inzent.igate.message.MessageBeans ;
import com.inzent.igate.message.MessageConverter ;
import com.inzent.igate.message.Record ;
import com.inzent.igate.message.ValueObject ;
import com.inzent.igate.repository.meta.Activity ;

/**
 * <code>TelegramHandler</code>
 *
 * @since 2019. 10. 10.
 * @version 5.0
 * @author Jaesuk
 */
public class XmlTelegramHandler extends AbstractTelegramHandler implements CustomHandlerConstants
{
  protected Element header ;

  public XmlTelegramHandler(Activity activity)
  {
    super(activity) ;
  }

  @Override
  public boolean isAck(AdapterParameter adapterParameter) throws IGateException
  {
    return Objects.equals("D", header.elementText(TELEGRAM_TYPE_FIELD)) ;
  }

  @Override
  public Record makeResponse(AdapterParameter adapterParameter, Throwable throwable) throws IGateException
  {
    return makeResponse(logger, adapterParameter, throwable) ;
  }

  @Override
  protected void analyze(AdapterParameter adapterParameter, boolean request) throws IGateException
  {
    MessageConverter messageConverter = MessageBeans.SINGLETON.createMessageConverter(adapterParameter.getAdapter(), request ? adapterParameter.getRequestData() : adapterParameter.getResponseData()) ;
    Object object = messageConverter.getParseData() ;

    adapterParameter.setConverted(object) ;

    header = ((Document) (object instanceof ValueObject ? ((ValueObject) object).get(HttpConstants.BODY) : object)).getRootElement().element(HEADER_ID).element(STANDARD_HEADER_ID) ;
    
    //transactionContextBean.setValue(LANG_CD, header.elementText(LANG_CD_FIELD)) ;
  }

  @Override
  protected int getTelegramType(AdapterParameter adapterParameter, boolean request) throws IGateException
  {
    switch (header.elementText(TELEGRAM_TYPE_FIELD))
    {
    case "D" :
    case "R" :
      return RESPONSE_NORMAL ;

    case "B" : // 원인없는 BID (PUSH) 세팅
      return PUSH_NORMAL ;

    default :
      // RestrictInterface 액티비티에서 제어할 지점
      adapterParameter.setBranch(header.elementText(BRANCH_FIELD)) ;
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
    return header.elementText(TID_FIELD) ;
  }

  @Override
  protected String getMessageId(AdapterParameter adapterParameter, boolean request) throws IGateException
  {
    return header.elementText(MID_FIELD) ;
  }

  @Override
  protected String getInterfaceId(AdapterParameter adapterParameter, String messageId) throws IGateException
  {
    return header.elementText(IID_FIELD) ;
  }

  @Override
  protected boolean isInterfaceResponseSync(AdapterParameter adapterParameter, String messageId)
  {
    return Objects.equals("S", header.elementText(SYNC_MODE_FIELD)) ;
  }

  @Override
  protected String getServiceId(AdapterParameter adapterParameter, String messageId) throws IGateException
  {
    return header.elementText(SID_FIELD) ;
  }

  @Override
  protected String getResponse(AdapterParameter adapterParameter) throws IGateException
  {
    return null ;
  } 
  
  @Override
  protected Object getHealthCheckResponse(AdapterParameter adapterParameter) throws IGateException
  {
    return null;
  }
}
