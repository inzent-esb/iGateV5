package com.inzent.igate.openapi.entity.usertoken;

import org.springframework.stereotype.Repository ;

import com.inzent.igate.repository.log.UserToken ;
import com.inzent.imanager.repository.LogEntityRepository ;

/**
 * UserTokenRepository
 * 
 * - UserToken 엔티티에 대한 데이터 액세스를 담당하는 저장소 (Repository)
 * - LogEntityRepository를 상속하여 CRUD 기능 제공
 */
@Repository
public class UserTokenRepository extends LogEntityRepository<String, UserToken>
{
  public UserTokenRepository() throws Exception {
    super(UserToken.class);
  }
}
