package com.custom.session.http ;

import org.apache.http.client.config.RequestConfig ;
import org.apache.http.client.methods.HttpRequestBase ;

import com.inzent.igate.adapter.AdapterParameter ;
import com.inzent.igate.connector.OutBoundConnector ;
import com.inzent.igate.message.HttpConstants ;
import com.inzent.igate.message.ValueObject ;
import com.inzent.igate.session.SessionPool ;
import com.inzent.igate.session.http.HttpComponentsSession ;
import com.inzent.igate.session.http.ThinHttpClientSession ;

public class AppianClientSession extends HttpComponentsSession
{
  public AppianClientSession(OutBoundConnector connector, SessionPool sessionPool, AdapterParameter adapterParameter)
  {
    super(connector, sessionPool, adapterParameter) ;
  }

  @Override
  protected HttpRequestBase makeRequest(AdapterParameter adapterParameter, RequestConfig.Builder builder) throws Exception
  {
    ValueObject valueObject ;
    if (adapterParameter.getRequestData() instanceof ValueObject)
      valueObject = (ValueObject) adapterParameter.getRequestData() ;
    else
    {
      // RequestData를 header를 포함하기 위한 ValueObject로 변경

      valueObject = new ValueObject() ;
      valueObject.put(HttpConstants.URI, adapterParameter.get(ThinHttpClientSession.HTTP_SERVICE_URI)) ;
      valueObject.put(HttpConstants.BODY, adapterParameter.getRequestData()) ;
    }

    ValueObject headers = (ValueObject) valueObject.get(HttpConstants.HEADER) ;
    if (null == headers)
      headers = new ValueObject(false, true) ; // HTTP Header를 Setting
    else
      headers.remove("Appian-API-Key") ;

    //Appian-API-Key Setting
    headers.put("Appian-API-Key", "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiI4ZjAyOGE3MS0xOWU5LTQ5N2YtYWQzOC0zNzFhNTE2NzRhZmIifQ.CAZ5Br769oDFh2jUrI2aScplgfu1DayjL383YqjUL18") ;

    adapterParameter.setRequestData(valueObject) ;

    return super.makeRequest(adapterParameter, builder) ;
  }
}
