package com.custom.activity.telegram ;

import com.inzent.igate.activity.adapter.AbstractTelegramHandler ;
import com.inzent.igate.adapter.AdapterParameter ;
import com.inzent.igate.context.TransactionContext ;
import com.inzent.igate.context.TransactionContextBean ;
import com.inzent.igate.exception.IGateException ;
import com.inzent.igate.repository.meta.Activity ;
import com.inzent.igate.message.HttpConstants;
import com.inzent.igate.message.MessageBeans;
import com.inzent.igate.message.Record;
import com.inzent.igate.message.ValueObject;
import com.inzent.igate.message.MessageConverter;

import org.apache.commons.lang3.StringUtils ;

public class RestTelegramHandler extends AbstractTelegramHandler implements CustomHandlerConstants
{

  protected ValueObject valueObject, header ;

  public RestTelegramHandler(Activity activity)
  {
    super(activity) ;
    // TODO Auto-generated constructor stub

  }

  @Override
  protected void analyze(AdapterParameter adapterParameter, boolean request) throws IGateException
  {
    // 요청응답 전문에서 valueObject, header를 추출한다.
    valueObject = (ValueObject) (request ? adapterParameter.getRequestData() : adapterParameter.getResponseData()) ;
    header = (ValueObject) valueObject.get(HttpConstants.HEADER) ;
  }

  @Override
  public boolean isAck(AdapterParameter arg0) throws IGateException
  {
    // TODO Auto-generated method stub
    return false ;
  }

  @Override
  public Record makeResponse(AdapterParameter adapterParameter, Throwable t) throws IGateException
  {
    // 에러전문 생성을 위한 MessageConverter를 생성한다.
    MessageConverter messageConverter = MessageBeans.SINGLETON.createMessageConverter(adapterParameter.getAdapter(), adapterParameter.getRequestData()) ;

    // 에러전문 Record를 생성한다.
    Record record = MessageBeans.SINGLETON.messageBuilder.createInterfaceRequestHeader(messageConverter, null, logger) ;
    messageConverter.parse(record, logger) ;

    // 에러전문 응답값을 세팅한다.
    record.setFieldValue("ResponseCode", "2") ;
    record.setFieldValue("ResponseMessage", t.getLocalizedMessage()) ;

    return record ;
  }

  @Override
  protected int getTelegramType(AdapterParameter adapterParameter, boolean request) throws IGateException
  {
    // TODO Auto-generated method stub
    if (request)
      return REQUEST_NORMAL ;
    else
      return RESPONSE_NORMAL ;
  }

  @Override
  protected String getTransactionId(AdapterParameter adapterParameter, boolean request) throws IGateException
  {
    // TODO Auto-generated method stub
    return (String) header.get(TID_FIELD) ;
  }

  @Override
  protected String getMessageId(AdapterParameter adapterParameter, boolean request) throws IGateException
  {
    if(request)
      // REST에서 표준전문에 MessageID가 없기 때문에 기본값을 설정해준다.
      return "00";
    else
      return TransactionContext.getValue(TransactionContextBean.MESSAGE, "00");
  }

  @Override
  protected String getInterfaceId(AdapterParameter adapterParameter, String messageId) throws IGateException
  {
    // 인터페이스ID가 설정되어있지 않는 경우 method + uri로 인터페이스 식별에서 인터페이스ID를 찾는다.
    if (StringUtils.isEmpty(TransactionContext.getValue(TransactionContext.INTERFACE, null)))
      return findInterfaceId(adapterParameter, valueObject.get(HttpConstants.METHOD) + " " + valueObject.get(HttpConstants.URI));
    
    return TransactionContext.getValue(TransactionContext.INTERFACE, null);
  }

  @Override
  protected boolean isInterfaceResponseSync(AdapterParameter adapterParameter, String messageId) throws IGateException
  {
    // TODO Auto-generated method stub
    return true ;
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
