package com.inzent.igate.session.http;

import java.nio.channels.SocketChannel;

import com.inzent.igate.adapter.AdapterParameter;
import com.inzent.igate.connector.OutBoundConnector;
import com.inzent.igate.message.HttpConstants;
import com.inzent.igate.message.ValueObject;
import com.inzent.igate.session.SessionPool;

public class HeaderCustomThinHttpServerSession extends ThinHttpServerSession {

	public HeaderCustomThinHttpServerSession(OutBoundConnector connector, SessionPool sessionPool,
			AdapterParameter param) throws Exception {
		super(connector, sessionPool, param);
	}

	public HeaderCustomThinHttpServerSession(OutBoundConnector connector, SessionPool sessionPool,
			AdapterParameter param, SocketChannel channel) throws Exception {
		super(connector, sessionPool, param, channel);
	}

	  protected ValueObject makeResponse(Object buf, AdapterParameter param) throws Exception
	  {
	    ValueObject valueObject = super.makeResponse(buf, param) ;

	    ValueObject headerValueObject = (ValueObject) valueObject.get(HttpConstants.HEADER) ;
	    
	    headerValueObject.put(HEADER_CONTENT_TYPE , "application/json;charset="+param.getAdapter().getCharset()) ;

	    return valueObject ;
	  }
}