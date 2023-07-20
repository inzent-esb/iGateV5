package com.inzent.igate.repository.log ;

import javax.persistence.Entity ;
import javax.persistence.Table ;

import org.hibernate.annotations.Proxy ;

@Entity
@Table(name = "IGT_EXCEPTION_LOG")
@Proxy(lazy = false)
public class ExceptionLog extends AbstractExceptionLog
{
  private static final long serialVersionUID = 2068016941595993412L ;
}
