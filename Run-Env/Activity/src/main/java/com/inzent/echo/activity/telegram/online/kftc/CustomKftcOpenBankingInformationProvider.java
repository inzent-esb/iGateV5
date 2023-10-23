package com.inzent.echo.activity.telegram.online.kftc ;

import com.fasterxml.jackson.databind.JsonNode ;
import com.inzent.igate.activity.adapter.online.kftc.KftcOpenBankingInformationProvider ;
import com.inzent.igate.adapter.AdapterParameter ;
import com.inzent.igate.context.TransactionContextBean ;
import com.inzent.igate.exception.IGateException ;
import com.inzent.igate.message.HttpConstants ;
import com.inzent.igate.message.ValueObject ;
import com.inzent.igate.repository.meta.Activity ;

public class CustomKftcOpenBankingInformationProvider extends KftcOpenBankingInformationProvider
{
  protected ValueObject valueObject ;
  protected JsonNode jsonNode ;

  public CustomKftcOpenBankingInformationProvider(Activity activity)
  {
    super(activity) ;
  }

  @Override
  protected void analyze(AdapterParameter adapterParameter, boolean request) throws IGateException
  {
    ValueObject valueObject_custom = (ValueObject) (request ? adapterParameter.getRequestData() : adapterParameter.getResponseData()) ;
    
    logger.debug("## analyze request :["  + request + "]") ;
    logger.debug("## analyze valueObject_custom :["  + valueObject_custom + "]") ;
    logger.debug("## analyze uri :["  + (String) valueObject_custom.get(HttpConstants.URI) + "]") ;
    logger.debug("## analyze uri/oauth: ["  + ((String) valueObject_custom.get(HttpConstants.URI)).startsWith("/oauth") + "]") ;
    
    super.analyze(adapterParameter, request) ;
    
    logger.debug("## analyze ==============================================================================") ;
    logger.debug("## analyze valueObject :["  + valueObject + "]") ;
    logger.debug("## analyze uri :["  + (String) valueObject.get(HttpConstants.URI) + "]") ;
    logger.debug("## analyze uri/oauth: ["  + ((String) valueObject.get(HttpConstants.URI)).startsWith("/oauth") + "]") ;
    if (!((String) valueObject.get(HttpConstants.URI)).startsWith("/oauth"))
    {
    	logger.debug("## analyze if jsonNode:["  + jsonNode + "]") ;
    	logger.debug("## analyze if res_common:["  + jsonNode.path("res_common") + "]") ;
    	logger.debug("## analyze if res_common.rsp_code:["  + jsonNode.path("res_common").path("rsp_code").asText() + "]") ;
    	logger.debug("## analyze if res_common2:["  + jsonNode.path("res_common2") + "]") ;
    	logger.debug("## analyze if res_common2.rsp_code2:["  + jsonNode.path("res_common2").path("rsp_code2").asText() + "]") ;
    }
    
//    valueObject = (ValueObject) (request ? adapterParameter.getRequestData() : adapterParameter.getResponseData()) ;
//
//    if (!((String) valueObject.get(HttpConstants.URI)).startsWith("/oauth"))
//      try
//      {
//        jsonNode = ApimTelegramHandler.objectMapper.readTree(new StringReader(new String((byte[]) valueObject.get(HttpConstants.BODY), adapterParameter.getAdapter().getCharset()))) ;
//      }
//      catch (Throwable t)
//      {
//        throw new IGateActivityException(getId(), t,
//            ActivityMessage.ANALYZE_ERROR, ActivityMessage.ANALYZE_ERROR_MESSAGE,
//            getId(), t.toString()) ;
//      }
  }

  @Override
  protected int getTelegramType(AdapterParameter adapterParameter, boolean request) throws IGateException
  {
    return REQUEST_NORMAL ;
  }

  @Override
  protected String getTransactionId(AdapterParameter adapterParameter, boolean request) throws IGateException
  {
    if (null == jsonNode)
      return "" ;

    return jsonNode.path(request ? "req_common" : "res_common").path("tran_id").asText() ;
  }

  @Override
  protected String getMessageId(AdapterParameter adapterParameter, boolean request) throws IGateException
  {
    if (request)
      return ((String) valueObject.get(HttpConstants.METHOD)) + " " + ((String) valueObject.get(HttpConstants.URI)) ;
    else
      return (String) transactionContextBean.getContext(TransactionContextBean.EXTERNAL_MESSAGE) ;
  }

  @Override
  protected String getResponse(AdapterParameter adapterParameter) throws IGateException
  {
    if (null == jsonNode)
      return "" ;

    return jsonNode.path("res_common").path("rsp_code").asText() ;
  }

  @Override
  protected boolean isInterfaceResponseSync(AdapterParameter adapterParameter, String messageId) throws IGateException
  {
    return true ;
  }
}
