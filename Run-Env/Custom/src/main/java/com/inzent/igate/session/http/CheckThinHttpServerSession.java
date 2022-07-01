package com.inzent.igate.session.http;

import java.nio.channels.SocketChannel;

import com.inzent.igate.adapter.AdapterParameter;
import com.inzent.igate.connector.OutBoundConnector;
import com.inzent.igate.session.SessionPool;

public class CheckThinHttpServerSession extends ThinHttpServerSession {

	public CheckThinHttpServerSession(OutBoundConnector connector, SessionPool sessionPool, AdapterParameter param)
			throws Exception {
		super(connector, sessionPool, param);
	}
	
	public CheckThinHttpServerSession(OutBoundConnector connector, SessionPool sessionPool,
			AdapterParameter param, SocketChannel channel) throws Exception {
		super(connector, sessionPool, param, channel);
	}
	
	@Override
	public boolean isClosing() {
		
		if(0 >= keepAliveMax)
			logger.error("keepAliveMax Closer");
		else
			logger.error("keepAliveMax Cnt[" + this.keepAliveMax + "]");
		
		return super.isClosing();
	}

}
