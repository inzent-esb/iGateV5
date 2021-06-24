package com.inzent.igate.repository.log ;

import javax.persistence.Entity ;
import javax.persistence.Table ;

import org.hibernate.annotations.Proxy ;

@Entity
@Table(name = "IGT_TRACE_LOG")
@Proxy(lazy = false)
public class TraceLog extends AbstractTraceLog
{
  private static final long serialVersionUID = 4091702834032052985L ;
}