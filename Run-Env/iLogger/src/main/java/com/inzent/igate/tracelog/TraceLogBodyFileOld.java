package com.inzent.igate.tracelog ;

import java.io.File ;
import java.rmi.RemoteException ;

import com.inzent.igate.repository.log.AbstractTraceLog ;
import com.inzent.igate.tracelog.TraceLogBodyFile ;

/**
 * <code>TraceLogBodyFileOld</code>
 * v5.4.0 이전 버전에서 저장한 추적로그(fileName에 전체경로가 있는 로그)를 읽기위한 TraceLogBody bean 이다. 
 *
 * @since 2023. 11. 17.
 * @version 5.1
 * @author Jaesuk Byon
 */
public class TraceLogBodyFileOld<T extends AbstractTraceLog> extends TraceLogBodyFile<T>
{
  @Override
  public String getMessage(T traceLog) throws RemoteException
  {
    int offset = traceLog.getFileName().lastIndexOf(File.separatorChar) ;
    if (0 < offset)
      traceLog.setFileName(traceLog.getFileName().substring(offset + 1)) ;

    return super.getMessage(traceLog) ;
  }

  @Override
  public Object getBody(T traceLog) throws RemoteException
  {
    int offset = traceLog.getFileName().lastIndexOf(File.separatorChar) ;
    if (0 < offset)
      traceLog.setFileName(traceLog.getFileName().substring(offset + 1)) ;

    return super.getBody(traceLog) ;
  }
}
