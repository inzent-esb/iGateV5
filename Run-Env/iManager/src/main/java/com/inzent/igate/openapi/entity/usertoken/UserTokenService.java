package com.inzent.igate.openapi.entity.usertoken;

import org.springframework.beans.factory.annotation.Autowired ;
import org.springframework.stereotype.Service ;

import com.inzent.igate.repository.log.UserToken ;
import com.inzent.imanager.service.LogEntityService ;

/**
 * UserTokenService
 * 
 * - UserToken 엔티티의 비즈니스 로직을 처리하는 서비스 계층
 * - LogEntityService를 상속하여 기본적인 CRUD 서비스 기능 제공
 */
@Service
public class UserTokenService extends LogEntityService<String, UserToken>
{
  @Autowired
  public void setUserTokenRepository(UserTokenRepository userTokenRepository)
  {
    setEntityRepository(userTokenRepository) ;
  }

}
