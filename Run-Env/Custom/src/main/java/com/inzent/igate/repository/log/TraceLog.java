package com.inzent.igate.repository.log ;

import javax.persistence.Entity ;
import javax.persistence.NamedQuery;
import javax.persistence.Table ;

import org.hibernate.annotations.Proxy ;

@Entity
@Table(name = "IGT_TRACE_LOG")
@NamedQuery(name = TraceLog.SQL, query="SELECT distinct transactionId from TraceLog group by transactionId having count (transactionId)=1")

@Proxy(lazy = false)
public class TraceLog extends AbstractTraceLog
{
  private static final long serialVersionUID = 4091702834032052985L ;
  
  public static final String SQL = "traceLog.select.noloss" ;
}