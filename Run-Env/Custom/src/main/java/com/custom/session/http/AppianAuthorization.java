package com.custom.session.http ;

import com.inzent.igate.message.HttpConstants ;
import com.inzent.igate.message.ValueObject ;
import com.inzent.igate.session.AbstractPooledSession ;
import com.inzent.igate.session.http.IHandlerAuthorization ;

public class AppianAuthorization implements IHandlerAuthorization
{
  public AppianAuthorization(AbstractPooledSession session)
  {
  }

  @Override
  public void onRequest(ValueObject valueObject) throws Exception
  {
    ValueObject headers = (ValueObject) valueObject.get(HttpConstants.HEADER) ;
    if (null == headers)
    {
      headers = new ValueObject(false, true) ; // HTTP Header를 Setting
      valueObject.put(HttpConstants.HEADER, headers) ;
    }

    // Appian-API-Key Setting
    headers.put("Appian-API-Key", "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiI4ZjAyOGE3MS0xOWU5LTQ5N2YtYWQzOC0zNzFhNTE2NzRhZmIifQ.CAZ5Br769oDFh2jUrI2aScplgfu1DayjL383YqjUL18") ;
  }
}
