package com.inzent.imanager.token;

import java.util.Optional ;

import org.springframework.beans.factory.annotation.Autowired ;
import org.springframework.beans.factory.annotation.Value ;

import com.inzent.igate.openapi.entity.usertoken.UserTokenService ;
import com.inzent.igate.repository.log.UserToken ;



/**
 * DuplicateLoginTokenRepository
 * 
 * 중복 로그인 정책에 따라 AccessToken 및 RefreshToken을 관리하는 저장소 클래스.
 * - 중복 로그인을 허용할지 여부 ('allowDuplicateLogin')
 * - RefreshToken을 사용하여 로그아웃을 지연할지 여부 ('useRefreshToken')
 * - UserTokenService를 사용하여 DB에서 토큰을 저장, 조회, 검증
 * 
 * 주요 기능:
 * - AccessToken 및 RefreshToken 저장 ('saveAccessToken', 'saveRefreshToken')
 * - AccessToken 및 RefreshToken 유효성 검증 ('isValidAccessToken', 'isValidRefreshToken')
 * - 사용자 토큰을 DB에서 조회 ('getUserToken')
 * - 토큰 저장 및 갱신 ('saveToken')
 */

public class DuplicateLoginTokenRepository extends TokenRepository
{
  // 중복 로그인을 허용할지 여부 (true: 허용(기본값), false: 마지막 로그인만 유지)
  @Value("#{systemProperties['imanager.token.allowDuplicateLogin']?:'true'}")
  private boolean allowDuplicateLogin;    
  
  // 중복 로그인을 허용하지 않을 경우, RefreshToken을 사용할지 여부
  // - true: RefreshToken 체크 시 로그아웃 ( imanager.token.expiration.access 설정 시간 동안 사용가능 )
  // - false: AccessToken 사용하여 즉시 로그아웃 (기본값)  
  @Value("#{systemProperties['imanager.token.useRefreshToken'] ?: 'false'}")
  private boolean useRefreshToken; 

  // UserTokenService를 사용하여 사용자 토큰 정보를 DB에서 관리
  @Autowired  
  private UserTokenService userTokenService;
  

  /**
   * RefreshToken을 저장하는 메서드
   * - 중복 로그인이 허용되거나 (allowDuplicateLogin == true)
   * - 중복 로그인을 허용하지 않지만 RefreshToken을 사용하지 않는 경우
   *   → 부모 클래스 ('TokenRepository')의 'saveRefreshToken()'을 호출.
   * - 그 외의 경우, DB에 직접 저장 ('saveToken()' 호출).
   *
   * @param userId 사용자 ID
   * @param token  저장할 RefreshToken 값
   * @return 저장된 RefreshToken 값
   */  
  @Override
  protected String saveRefreshToken(String userId, String token)
  {
    if(allowDuplicateLogin || (!allowDuplicateLogin && !useRefreshToken))
      return super.saveRefreshToken(userId, token) ;
    
    return saveToken(userId, token) ;
  }

  /**
   * RefreshToken의 유효성을 검증하는 메서드
   * - 중복 로그인이 허용되거나 (allowDuplicateLogin == true)
   * - 중복 로그인을 허용하지 않지만 RefreshToken을 사용하지 않는 경우
   *   → 부모 클래스 ('TokenRepository')의 'isValidRefreshToken()'을 호출하여 검증.
   * - 그 외의 경우, DB에서 직접 검증 ('isValidToken()' 호출).
   *
   * @param userId 사용자 ID
   * @param token  검증할 RefreshToken 값
   * @return RefreshToken이 유효하면 true, 그렇지 않으면 false
   */
  @Override
  public boolean isValidRefreshToken(String userId, String token)
  {
    if(allowDuplicateLogin || (!allowDuplicateLogin && !useRefreshToken))
      return super.isValidRefreshToken(userId, token) ;

    return isValidToken(userId, token);
  }
  

  /**
   * AccessToken의 유효성을 검증하는 메서드
   * - 중복 로그인이 허용되거나 (allowDuplicateLogin == true)
   * - 중복 로그인을 허용하지 않지만 RefreshToken을 사용하는 경우
   *   → 부모 클래스 ('TokenRepository')의 'isValidAccessToken()'을 호출하여 검증.
   * - 그 외의 경우, DB에서 직접 검증 ('isValidToken()' 호출).
   *
   * @param userId 사용자 ID
   * @param token  검증할 AccessToken 값
   * @return AccessToken이 유효하면 true, 그렇지 않으면 false
   */
 
  @Override
  protected boolean isValidAccessToken(String userId, String token)
  {
    if(allowDuplicateLogin || (!allowDuplicateLogin && useRefreshToken))
      return super.isValidAccessToken(userId, token) ;

    return isValidToken(userId, token);
  }
  

  /**
   * AccessToken을 저장하는 메서드
   * - 중복 로그인이 허용되거나 (allowDuplicateLogin == true)
   * - 중복 로그인을 허용하지 않지만 RefreshToken을 사용하는 경우
   *   → 부모 클래스 ('TokenRepository')의 'saveAccessToken()'을 호출.
   * - 그 외의 경우, DB에 직접 저장 ('saveToken()' 호출).
   *
   * @param userId 사용자 ID
   * @param token  저장할 AccessToken 값
   * @return 저장된 AccessToken 값
   */  
  @Override
  protected String saveAccessToken(String userId, String token)
  {
    if(allowDuplicateLogin || (!allowDuplicateLogin && useRefreshToken))
      return super.saveAccessToken(userId, token) ;
  
    return saveToken(userId, token) ;
  }


  /**
   * DB에서 사용자 토큰 정보를 조회하는 메서드
   *
   * @param userId 사용자 ID
   * @return Optional<UserToken> (사용자의 토큰 정보)
   */
  private Optional<UserToken> getUserToken(String userId) 
  {
    try {
      return Optional.ofNullable(userTokenService.get(userId));
    }catch (Exception e) {
      logger.error("Error retrieving user token: " + e.getMessage(), e);
        return Optional.empty();
    }
  }

  /**
   * 토큰이 유효한지 확인하는 메서드
   * - DB에서 사용자 토큰을 조회한 후, 입력된 토큰과 일치하는지 비교.
   *
   * @param userId 사용자 ID
   * @param token  검증할 토큰 값
   * @return 토큰이 유효하면 true, 그렇지 않으면 false
   */
  private boolean isValidToken(String userId, String token) 
  {
    if (token == null || token.isEmpty()) {
      throw new IllegalArgumentException("Invalid token.");
    }
    
    if (userId == null || userId.isEmpty()) {
      throw new IllegalArgumentException("Invalid user ID.");
    }
    
    Optional<UserToken> storedToken = getUserToken(userId);
    return storedToken.map(userToken -> token.equals(userToken.getToken())).orElse(false);
  }

  /**
   * DB에 사용자 토큰을 저장하는 메서드
   * - 기존에 저장된 토큰이 있다면 UPDATE, 없으면 INSERT 수행.
   *
   * @param userId 사용자 ID
   * @param token  저장할 토큰 값
   * @return 저장된 토큰 값
   */
  private String saveToken(String userId, String token) 
  {
    if (token == null || token.isEmpty())
      throw new IllegalArgumentException("Invalid token.");

    if (userId == null || userId.isEmpty())
      throw new IllegalArgumentException("Invalid user ID.");
    
    Optional<UserToken> storedToken = getUserToken(userId);
    UserToken newUserToken = new UserToken(userId, token);
    try 
    {
      if (storedToken.isPresent()) 
        userTokenService.update(newUserToken, storedToken.get());
      else 
        userTokenService.insert(newUserToken);

      return newUserToken.getToken();
      
    } catch (Exception e) {
      logger.error("Error saving token: " + e.getMessage(), e);
      throw new RuntimeException("Error saving token.", e);
    }
  }
  
}
