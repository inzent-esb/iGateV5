package com.inzent.igate.repository.log ;

import jakarta.persistence.Entity ;
import jakarta.persistence.Table ;
import jakarta.persistence.Transient ;

import org.hibernate.annotations.Proxy ;

@Entity
@Table(name = "IGT_TRACE_LOG")
@Proxy(lazy = false)
@javax.persistence.Entity
@javax.persistence.Table(name = "IGT_TRACE_LOG")
public class TraceLog extends AbstractTraceLogApim
{
  private static final long serialVersionUID = 4091702834032052985L ;

    
  public TraceLog()
  {
  }
  
  //인터페이스 한글명 필드 
  @Transient
  @javax.persistence.Transient
  private String interfaceName ;
  
  public String getInterfaceName()
  {
    return interfaceName ;
  }

  public void setInterfaceName(String interfaceName)
  {
    this.interfaceName = interfaceName ;
  }
   
  
}
