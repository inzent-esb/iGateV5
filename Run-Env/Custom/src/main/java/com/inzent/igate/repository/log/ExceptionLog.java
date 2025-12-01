package com.inzent.igate.repository.log ;

import jakarta.persistence.Entity ;
import jakarta.persistence.Table ;

import org.hibernate.annotations.Proxy ;

@Entity
@Table(name = "IGT_EXCEPTION_LOG")
@Proxy(lazy = false)
@javax.persistence.Entity
@javax.persistence.Table(name = "IGT_EXCEPTION_LOG")
public class ExceptionLog extends AbstractExceptionLog
{
  private static final long serialVersionUID = 2068016941595993412L ;
}
