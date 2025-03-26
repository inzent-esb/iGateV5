package com.inzent.igate.repository.log;

import java.io.Serializable ;

import javax.persistence.Column ;
import javax.persistence.Entity ;
import javax.persistence.Id ;
import javax.persistence.Table ;

import org.hibernate.annotations.Proxy ;

import com.inzent.imanager.repository.FieldRestriction ;


/**
 * UserToken 엔티티 클래스
 * 
 * - 사용자의 인증 토큰 정보를 저장하는 테이블 매핑
 * - USER_ID를 기본 키(PK)로 사용
 * - TOKEN 컬럼에 사용자의 인증 토큰을 저장
 */
@Entity
@Table(name = "IGT_USER_TOKEN")
@Proxy(lazy = false)
public class UserToken implements Serializable
{
  private static final long serialVersionUID = 545950243346849062L ;

  @Id
  @Column(name = "USER_ID")
  @FieldRestriction(unformalize = FieldRestriction.BLANK, nullable = false, where = FieldRestriction.EQ)
  private String userId ;

  @Column(name = "TOKEN", nullable = false )
  private String token;

  /**
   * 기본 생성자
   */
  public UserToken() {}

  /**
   * 생성자 (사용자 ID 및 토큰 설정)
   *
   * @param userId 사용자 ID
   * @param token  인증 토큰
   */
  public UserToken(String userId, String token) {
    this.userId = userId;
    this.token = token;
  }

  // Getter 및 Setter 메서드
  
  public String getUserId()
  {
    return userId ;
  }

  public void setUserId(String userId)
  {
    this.userId = userId ;
  }

  public String getToken()
  {
    return token ;
  }

  public void setToken(String token)
  {
    this.token = token ;
  }

  /**
   * 객체 문자열 표현 
   */
  @Override
  public String toString() {
    return "UserToken{userId='" + userId + "', token='" + token + "'}";
  }

}
