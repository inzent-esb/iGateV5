package com.inzent.igate.repository.log ;

import java.io.Serializable ;

import javax.persistence.Column ;
import javax.persistence.Entity ;
import javax.persistence.Id ;
import javax.persistence.NamedQueries ;
import javax.persistence.NamedQuery ;
import javax.persistence.Table ;

import org.hibernate.annotations.Proxy ;

@Entity
@Table(name = "IGT_MCI_SESSION")
@Proxy(lazy = false)
@NamedQueries({ 
  @NamedQuery(name = MciSession.SELECT_LOGINED, query = "FROM MciSession WHERE empId=:empId AND sessionDelYn='N'"),
  @NamedQuery(name = MciSession.UPDATE_LOGOUT_NORMAL, query = "UPDATE MciSession SET sessionDelYn='Y', logoffYms=:logoffYms WHERE mciSessionId=:mciSessionId"),
  @NamedQuery(name = MciSession.UPDATE_LOGOUT_FORCE, query = "UPDATE MciSession SET sessionDelYn='Y' WHERE mciSessionId=:mciSessionId") })
public class MciSession implements Serializable
{
  private static final long serialVersionUID = -7384444813173745206L ;

  public static final String SELECT_LOGINED = "mciSession.select.logined" ;
  public static final String UPDATE_LOGOUT_NORMAL = "mciSession.update.logout.normal" ;
  public static final String UPDATE_LOGOUT_FORCE = "mciSession.update.logout.force" ;

  @Id
  @Column(name = "MCI_SESSION_ID")
  private String mciSessionId ;

  @Column(name = "MCI_INSTANCE_ID")
  private String mciInstanceId ;

  @Column(name = "CMGRCD")
  private String cmgrCd ;

  @Column(name = "CHANNEL_CODE")
  private String channelCode ;

  @Column(name = "CHANNEL_IP")
  private String channelIp ;

  @Column(name = "MAC_ADDRESS")
  private String macAddress ;

  @Column(name = "BRNCD")
  private String brnCd ;

  @Column(name = "EMPID")
  private String empId ;

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

  public String getMciInstanceId()
  {
    return mciInstanceId ;
  }

  public void setMciInstanceId(String mciInstanceId)
  {
    this.mciInstanceId = mciInstanceId ;
  }

  public String getCmgrCd()
  {
    return cmgrCd ;
  }

  public void setCmgrCd(String cmgrCd)
  {
    this.cmgrCd = cmgrCd ;
  }

  public String getChannelCode()
  {
    return channelCode ;
  }

  public void setChannelCode(String channelCode)
  {
    this.channelCode = channelCode ;
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

  public String getBrnCd()
  {
    return brnCd ;
  }

  public void setBrnCd(String brnCd)
  {
    this.brnCd = brnCd ;
  }

  public String getEmpId()
  {
    return empId ;
  }

  public void setEmpId(String empId)
  {
    this.empId = empId ;
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
}
