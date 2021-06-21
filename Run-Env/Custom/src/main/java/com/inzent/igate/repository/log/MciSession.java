package com.inzent.igate.repository.log ;

import java.io.Serializable ;

import javax.persistence.Column ;
import javax.persistence.Entity ;
import javax.persistence.Id ;
import javax.persistence.Table ;

import org.hibernate.annotations.Proxy ;

@Entity
@Table(name = "IGT_MCI_SESSION", schema = "IGATE")
@Proxy(lazy = false)
public class MciSession implements Serializable, Comparable<MciSession>
{

  /**
   * 
   */
  private static final long serialVersionUID = -7384444813173745206L ;

  @Id
  @Column(name = "MCI_SESSION_ID")
  private String mciSessionId ;

  @Column(name = "BRNCD")
  private String brnCd ;

  @Column(name = "CMGRCD")
  private String cmgrCd ;

  @Column(name = "EMPID")
  private String empId ;

  @Column(name = "CHANNEL_CODE")
  private String channelCode ;

  @Column(name = "MCI_NODE_ID")
  private String mciNodeId ;

  @Column(name = "MCI_INSTANCE_ID")
  private String mciInstanceId ;

  @Column(name = "CHANNEL_IP")
  private String channelIp ;

  @Column(name = "MAC_ADDRESS")
  private String macAddress ;

  @Column(name = "LOGON_YMS")
  private String logonYms ;

  @Column(name = "LOGOFF_YMS")
  private String logoffYms ;

  @Column(name = "SESSION_DEL_YN")
  private String sessionDelYn ;

  public MciSession()
  {

  }

  public MciSession(String mciSessionId)
  {
    this.mciSessionId = mciSessionId ;
  }

  public String getMciSessionId()
  {
    return mciSessionId ;
  }

  public void setMciSessionId(String mciSessionId)
  {
    this.mciSessionId = mciSessionId ;
  }

  public String getBrnCd()
  {
    return brnCd ;
  }

  public void setBrnCd(String brnCd)
  {
    this.brnCd = brnCd ;
  }

  public String getCmgrCd()
  {
    return cmgrCd ;
  }

  public void setCmgrCd(String cmgrCd)
  {
    this.cmgrCd = cmgrCd ;
  }

  public String getEmpId()
  {
    return empId ;
  }

  public void setEmpId(String empId)
  {
    this.empId = empId ;
  }

  public String getChannelCode()
  {
    return channelCode ;
  }

  public void setChannelCode(String channelCode)
  {
    this.channelCode = channelCode ;
  }

  public String getMciNodeId()
  {
    return mciNodeId ;
  }

  public void setMciNodeId(String mciNodeId)
  {
    this.mciNodeId = mciNodeId ;
  }

  public String getMciInstanceId()
  {
    return mciInstanceId ;
  }

  public void setMciInstanceId(String mciInstanceId)
  {
    this.mciInstanceId = mciInstanceId ;
  }

  public String getChannelIp()
  {
    return channelIp ;
  }

  public void setChannelIp(String channelIp)
  {
    this.channelIp = channelIp ;
  }

  public String getMacAddress()
  {
    return macAddress ;
  }

  public void setMacAddress(String macAddress)
  {
    this.macAddress = macAddress ;
  }

  public String getLogonYms()
  {
    return logonYms ;
  }

  public void setLogonYms(String logonYms)
  {
    this.logonYms = logonYms ;
  }

  public String getLogoffYms()
  {
    return logoffYms ;
  }

  public void setLogoffYms(String logoffYms)
  {
    this.logoffYms = logoffYms ;
  }

  public String getSessionDelYn()
  {
    return sessionDelYn ;
  }

  public void setSessionDelYn(String sessionDelYn)
  {
    this.sessionDelYn = sessionDelYn ;
  }

  @Override
  public int compareTo(MciSession o)
  {
    // TODO Auto-generated method stub
    return mciSessionId.compareTo(o.mciSessionId) ;
  }

  @Override
  public int hashCode()
  {
    final int prime = 31 ;
    int result = 1 ;
    result = prime * result + ((mciSessionId == null) ? 0 : mciSessionId.hashCode()) ;
    return result ;
  }

  @Override
  public boolean equals(Object obj)
  {
    if (this == obj)
      return true ;
    if (obj == null)
      return false ;
    if (getClass() != obj.getClass())
      return false ;
    MciSession other = (MciSession) obj ;
    if (mciSessionId == null)
    {
      if (other.mciSessionId != null)
        return false ;
    }
    else if (!mciSessionId.equals(other.mciSessionId))
      return false ;
    return true ;
  }
}
