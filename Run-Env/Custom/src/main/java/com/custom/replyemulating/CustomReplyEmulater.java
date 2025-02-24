
package com.custom.replyemulating;

import java.util.List;

import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.exception.ExceptionUtils;
import org.apache.commons.logging.Log ;
import org.apache.commons.logging.LogFactory ;

import com.inzent.igate.adapter.AdapterParameter;
import com.inzent.igate.exception.IGateException;
import com.inzent.igate.message.Field;
import com.inzent.igate.message.Field.FieldType ;
import com.inzent.igate.message.MessageBeans;
import com.inzent.igate.message.MessageConverter;
import com.inzent.igate.message.Record;
import com.inzent.igate.replyemulating.ReplyEmulater;
import com.inzent.igate.repository.log.ReplyEmulatePK;
import com.inzent.igate.repository.log.ReplyEmulateProperty;
import com.inzent.igate.repository.meta.Service;
import com.inzent.igate.util.Numeric ;
import com.inzent.igate.util.PatternUtils;

/**
 * **사용자 정의 가상 응답(Emulation) 클래스**
 *
 * <p>이 클래스는 'ReplyEmulater'를 상속받아 응답 데이터를 특정 패턴에 맞게 변환하는 기능을 수행한다.</p>
 *
 * <p>서비스에서 응답 데이터를 가상으로 생성할 때, 'ReplyEmulateProperty'를 기반으로
 * 응답 필드의 값을 변환 및 조작하는 역할을 한다.</p>
 *
 * <h2>📌 주요 기능</h2>
 * <ul>
 *   <li>서비스 ID를 기반으로 응답 에뮬레이션 속성 조회</li>
 *   <li>응답 필드 값을 특정 패턴에 맞게 변환</li>
 *   <li>날짜 변환, 문자열 결합, 값 치환 등의 기능 제공</li>
 *   <li>기본 응답 ID('DEF_REPLYID')를 설정하여 서비스 동작을 정의</li>
 * </ul>
 *
 * <h2>📌 지원하는 패턴 유형</h2>
 * <ul>
 *   <li><b>OPTION_IN</b>: 요청 데이터에서 필드 값을 복사</li>
 *   <li><b>OPTION_DATE</b>: 현재 날짜 또는 특정 형식의 날짜 적용</li>
 *   <li><b>OPTION_CONCAT</b>: 여러 필드를 결합하여 응답 값 생성</li>
 *   <li><b>OPTION_REPLACE</b>: 특정 필드의 일부 값을 치환</li>
 * </ul>
 */
public class CustomReplyEmulater extends ReplyEmulater
{
  protected final Log log = LogFactory.getLog(getClass()) ;
  
  // 에뮬레이션 오류 코드 및 메시지
  private static final String EMULATE_ERROR = "EGASH001" ;
  private static final String EMULATE_ERROR_MESSAGE = "[EGASH001] Error processing virtual response [Reply Emulate property]: " ;

  // 기본 응답 ID 설정 (가상응답 식별하는 기본 ID)
  private static final String DEF_REPLYID = "Normal" ;
  private String replyId = DEF_REPLYID ;

  // 필드 패턴 키워드 정의
  private static final String OPTION_IN = "IN" ; // 입력 필드 값을 복사하여 응답 설정
  private static final String OPTION_DATE = "DATE" ; // 현재 날짜 또는 특정 형식의 날짜 설정
  private static final String OPTION_CONCAT = "CC" ; // 여러 필드를 결합하여 응답 값 생성
  private static final String OPTION_REPLACE = "REP" ; // 특정 필드의 값을 일부 치환
  
  
  @Override
  public boolean makeReply(AdapterParameter adapterParameter, Service service, Record request) throws IGateException
  {
    log.debug(" ■***** serviceReplyEmulatings : " + serviceReplyEmulatings );
    if (null != serviceReplyEmulatings)
    {
       log.debug(" ***** serviceReplyEmulatings.size() : " + serviceReplyEmulatings.size() );
       for(String  repkey : serviceReplyEmulatings.keySet())
         log.debug(" ** [" + repkey + "] / " +serviceReplyEmulatings.get(repkey).getClass().getName() );
    }
    
    log.debug(" ■***** adapterReplyEmulatings : " + adapterReplyEmulatings );
    if (null != adapterReplyEmulatings)
    {
       log.debug(" ***** adapterReplyEmulatings.size() : " + adapterReplyEmulatings.size() );
       for(String  repkey : adapterReplyEmulatings.keySet())
         log.debug(" ** [" + repkey + "] / " +adapterReplyEmulatings.get(repkey).getClass().getName() );
    }

    log.debug(" ■***** isNeedEmulating : " +  isNeedEmulating(adapterParameter, service, request) );

    return super.makeReply(adapterParameter, service, request) ;
  }
  
  /**
   * 서비스 가상 응답 데이터를 생성하는 메소드
   *
   * 이 메서드는 'adapterParameter', 'service', 'request'를 기반으로 응답을 생성하고,
   * 'isReplyEmulatePropertyList'를 통해 응답 에뮬레이션 속성('ReplyEmulateProperty')이 존재하는 경우
   * 'setReplyFieldPatternValue'를 사용하여 특정 응답 필드 값을 설정한다.
   *
   * 주요 흐름:
   * 1. 'super.doMakeReply()'를 호출하여 기본 응답 처리를 수행.
   * 2. 'isReplyEmulatePropertyList(service.getServiceId())'를 통해 응답 속성 존재 여부 확인.
   * 3. 'MessageConverter'를 사용하여 요청('request') 및 응답('response') 데이터를 'Record'로 변환.
   * 4. 'setReplyFieldPatternValue'를 호출하여 응답 필드 값을 설정.
   * 5. 변환된 응답 데이터를 'adapterParameter'의 응답 데이터로 설정.
   * 6. 예외 발생 시 로그를 남기고 'IGateException'을 던짐.
   *
   * @param adapterParameter  어댑터에서 전달받은 요청 및 응답 데이터를 포함하는 객체
   * @param service           현재 실행 중인 서비스 정보 객체
   * @param request           요청 데이터가 포함된 'Record' 객체
   * @return                  응답 생성 성공 여부 ('true' - 성공, 'false' - 실패)
   * @throws IGateException   응답 생성 중 오류 발생 시 예외를 던짐
   */
  @Override
  public boolean doMakeReply(AdapterParameter adapterParameter, Service service, Record request) throws IGateException
  {
    // 응답 에뮬레이션을 위한 'replyId' 설정 (기본값 'DEF_REPLYID' 사용 가능)
    replyId = service.getProperty("emulate.reply.id", DEF_REPLYID) ;

    try
    {
      // 부모 클래스에서 응답 생성 수행
      boolean checkReply = super.doMakeReply(adapterParameter, service, request) ;
      if (!checkReply)
        return false ;

      // 응답 에뮬레이션 속성이 존재하는지 확인
      if (isReplyEmulatePropertyList(service.getServiceId()))
      {
        // 요청 및 응답 데이터를 처리하기 위한 MessageConverter 생성
        MessageConverter requestConverter = MessageBeans.SINGLETON.createMessageConverter(adapterParameter.getAdapter(), adapterParameter.getRequestData()) ;
        MessageConverter responseConverter = MessageBeans.SINGLETON.createMessageConverter(adapterParameter.getAdapter(), adapterParameter.getResponseData()) ;

        // 변환기가 정상적으로 생성되지 않으면 기존 응답 결과 반환
        if (requestConverter == null || responseConverter == null)
          return checkReply ;

        // 요청 및 응답 데이터를 'Record' 객체로 변환
        Record recordReq = requestConverter.parseServiceRequest(service, logger) ;
        Record recordRes = responseConverter.parseServiceResponse(service, logger) ;

        // 응답 필드 패턴 값을 설정
        setReplyFieldPatternValue(recordReq, recordRes, service.getServiceId()) ;

        // 새로운 응답 메시지 변환기 생성
        responseConverter = MessageBeans.SINGLETON.createMessageConverter(adapterParameter.getAdapter(), null) ;
        responseConverter.composeServiceResponse(service, recordRes, logger) ;

        // 응답 데이터를 어댑터 파라미터에 설정
        adapterParameter.setResponseData(responseConverter.getComposeValue()) ;
      }
      return true ;
    }
    catch (Exception e)
    {
      // 예외 발생 시 로그를 남기고 'IGateException'을 던짐
      logger.error(EMULATE_ERROR_MESSAGE + ExceptionUtils.getStackTrace(e), e) ;
      throw new IGateException(EMULATE_ERROR, EMULATE_ERROR_MESSAGE + e.getMessage()) ;
    }
  }


/**
 * 서비스 ID에 대한 응답 에뮬레이션 속성 목록 확인
 * 주어진 'serviceId'에 대한 응답 에뮬레이션 속성('ReplyEmulateProperty') 리스트가 존재하는지 여부를 확인하는 메서드.
 *
 * 해당 서비스 ID에 대한 'ReplyEmulateProperty' 목록을 조회하고, 
 * - 리스트가 'null'이 아니고 비어있지 않으면 'true'를 반환.
 * - 조회 중 예외가 발생하면 'false'를 반환하고 로그를 남김.
 *
 * @param serviceId 서비스 식별자 ('ReplyEmulatePK' 생성 시 사용됨)
 * @return 'true' - 응답 에뮬레이션 속성이 존재하는 경우
 *         'false' - 응답 에뮬레이션 속성이 없거나 조회 중 오류 발생 시
 */
  protected boolean isReplyEmulatePropertyList(String serviceId)
  {
    try
    {
      // 서비스 ID와 replyId를 사용하여 응답 에뮬레이션 속성 목록을 가져옴
      List<ReplyEmulateProperty> propertyList = getReplyEmulate(new ReplyEmulatePK(serviceId, replyId)).getReplyEmulateProperty() ;

      // 응답 속성 리스트가 'null'이 아니고, 비어있지 않으면 'true' 반환
      return propertyList != null && !propertyList.isEmpty() ;
    }
    catch (Exception e)
    {
      // 예외 발생 시, 에러 로그 출력 후 'false' 반환
      logger.error("Failed to retrieve ReplyEmulateProperty list for serviceId: " + serviceId, e) ;
      return false ;
    }
  }

  /**
  * 응답 필드 속성을 통한 필드 값을 설정하는 메소드
  * 
  * 서비스 ID('serviceId')에 해당하는 응답 에뮬레이션 패턴을 조회하고, 
  * 이를 기반으로 'outRecord'의 필드 값을 설정하는 메서드.
  *
  * 'serviceId'와 'replyId'를 사용하여 'ReplyEmulateProperty' 리스트를 가져온 후, 
  * 각 패턴에 따라 적절한 처리 메서드를 호출하여 필드 값을 설정한다.
  *
  * 패턴 유형:
  * - 'OPTION_IN=value' → 입력 레코드에서 값을 복사
  * - 'OPTION_DATE=value' → 날짜 형식 적용
  * - 'OPTION_CONCAT=value1+value2+...' → 여러 값을 결합
  * - 'OPTION_REPLACE(fiedPath,offset,replacement)' → 특정 부분 문자열을 교체
  *
  * @param inRecord  입력 데이터를 포함하는 'Record' 객체
  * @param outRecord 값을 설정할 대상 'Record' 객체
  * @param serviceId 서비스 식별자 ('ReplyEmulatePK' 생성 시 사용됨)
  * @throws IGateException 필드 값 설정 중 예외가 발생할 경우 예외를 던질 수 있음
  */

  protected void setReplyFieldPatternValue(Record inRecord, Record outRecord, String serviceId) throws IGateException
  {
    // 서비스 ID와 replyId를 사용하여 응답 에뮬레이션 속성 목록을 가져옴
    List<ReplyEmulateProperty> propertyList = getReplyEmulate(new ReplyEmulatePK(serviceId, replyId)).getReplyEmulateProperty() ;
    // 응답 속성이 없으면 처리를 중단
    if (propertyList == null || propertyList.isEmpty())
      return ;

    // 각 응답 속성에 대해 필드 값을 설정
    for (ReplyEmulateProperty property : propertyList)
    {
      String pattern = property.getFieldvalue() ;
      // 패턴이 비어 있으면 건너뜀
      if (StringUtils.isBlank(pattern))
        continue ;

      // 출력 레코드('outRecord')에서 필드를 가져옴
      Field field = outRecord.getField(property.getPk().getFieldPath()) ;
      if (field == null)
        continue ;
      
      // ✅ [우선 순위 로직] 이미 값이 설정되어 있으면 처리하지 않고 SKIP
      Object fieldValue = field.getValue();
      if (fieldValue != null) {
          try {
              // 문자열 필드: 값이 비어있지 않으면 SKIP
              if (field.getFieldType() == FieldType.String && fieldValue instanceof String) {
                  if (StringUtils.isNotBlank((String) fieldValue)) {
                      continue;
                  }
              }
              // 숫자 필드: 값이 0보다 크면 SKIP
              else if (field.getFieldType() == FieldType.Numeric && fieldValue instanceof Numeric) {
                  if (((Numeric) fieldValue).toNumber().intValue() > 0) {
                      continue;
                  }
              }
          } catch (Exception e) {
              logger.error("Field value type mismatch: " + field.getPath(), e);
              continue; // 예외 발생 시 해당 필드 처리 SKIP
          }
      }

      // 패턴을 파악하여 각 패턴에 따른 처리
      switch (pattern.split("=")[0])
      {
      case OPTION_IN :
        setReplyFieldPatternIN(inRecord, field, pattern) ;
        break ;
      case OPTION_DATE :
        setReplyFieldPatternDATE(field, pattern) ;
        break ;
      case OPTION_CONCAT :
        setReplyFieldPatternCC(inRecord, field, pattern) ;
        break ;
      /*
       * case OPTION_REPLACE : setReplyFieldPatternREP(inRecord, field, pattern)
       * ; break ;
       */
      default :
        // OPTION_REPLACE 패턴은 기본적으로 "="이 포함되지 않으므로 별도 처리
        if (pattern.startsWith(OPTION_REPLACE))
        {
          setReplyFieldPatternREP(inRecord, field, pattern) ;
        }
        else
        {
          // 정의되지 않은 패턴일 경우 오류 로그 출력
          logger.error("Invalid pattern: " + pattern) ;
        }
        break ;
      }
    }
  }

  /**
   * 
   * 입력 레코드('inRecord')에서 특정 필드 값을 가져와 대상 필드('field')에 설정하는 메서드.
   *
   * 주어진 패턴('pattern')이 "key=value" 형식일 경우, "=" 이후의 값을 입력 필드 경로로 사용하며,
   * 그렇지 않으면 기본적으로 현재 필드의 경로를 사용한다.
   *
   * 만약 'inRecord'에 해당 필드가 존재하면 값을 복사하여 설정하고, 존재하지 않으면 오류 로그를 남긴다.
   *
   * @param inRecord
   *          입력 데이터를 포함하는 'Record' 객체
   * @param field
   *          값을 설정할 대상 'Field' 객체
   * @param pattern
   *          "IN={요청필드경로}" 형식의 패턴 문자열 
   *          예1: IN
   *          예2: IN=\HDR_COM\GIT_CNT_C
   * @throws IGateException
   *           필드 값 설정 중 예외가 발생할 경우 예외를 던질 수 있음
   */
  protected void setReplyFieldPatternIN(Record inRecord, Field field, String pattern) throws IGateException
  {
    // 패턴에 "="이 포함되어 있다면, "="을 기준으로 나눈 후 두 번째 값을 필드 경로로 사용
    // 패턴이 존재하지 않으면 현재 필드의 경로를 기본값으로 사용
    String inFieldPath = pattern.contains("=") ? pattern.split("=")[1] : field.getPath() ;
    if (inRecord.hasField(inFieldPath))
    {
      // 입력 레코드('inRecord')에 해당 필드가 존재하는 경우, 값을 복사하여 설정
      field.setValue(inRecord.getField(inFieldPath).getValue()) ;
    }
    else
    {
      // 존재하지 않는 필드일 경우 오류 로그 출력
      logger.error("Undefined Field ID: " + inFieldPath) ;
    }
  }

  /**
   * 주어진 필드(field)에 대해 특정 날짜 형식 패턴을 적용하여 값을 설정하는 메서드.
   * 
   * 패턴이 "key=value" 형식일 경우 "=" 이후의 문자열을 날짜 형식 패턴으로 간주하여 변환하며, 
   * 그렇지 않다면 기본 날짜 형식을  사용한다. 
   * 변환된 값은 필드의 길이를 초과하지 않도록 조정되며, 
   * 필드 타입이 Numeric일 경우 Numeric 객체로 변환하여 설정된다.
   *
   * @param field
   *          값을 설정할 대상 필드 객체
   * @param pattern
   *          날짜 형식 패턴 문자열 예1: DATE 예2:
   *          DATE=${YYYY}${YY}${MM}${DD}${HH}${MI}${SS}${sss}
   * @throws IGateException
   *           필드 값 설정 중 예외가 발생할 경우 예외를 던짐
   */
  protected void setReplyFieldPatternDATE(Field field, String pattern) throws IGateException
  {
    // 패턴이 "key=value" 형식이라면 "="을 기준으로 분리하여 value 부분을 추출
    String value ;
    int delimiterIndex = pattern.indexOf("=") ;
    if (delimiterIndex != -1 && delimiterIndex < pattern.length() - 1)
    {
      // "=" 이후의 문자열을 날짜 패턴으로 간주하고 공백을 제거하여 사용
      String dateFormat = pattern.substring(delimiterIndex + 1).trim() ;
      // 현재 시간을 주어진 패턴의 날짜 형식으로 변환
      value = PatternUtils.dateTimePattern(dateFormat, System.currentTimeMillis()) ;
    }
    else
    {
      // 기본 날짜 형식 적용 ( 기본 14자리 "yyyyMMddHHmmss" )
      value = PatternUtils.dateFormatStandard.format(System.currentTimeMillis()) ;
    }

    // 필드 길이를 초과하지 않도록 조정
    if (value.length() > field.getLength())
    {
      value = value.substring(0, field.getLength()) ;
    }

    // 필드 타입이 Numeric이면 Numeric 객체로 변환하여 설정
    if (FieldType.Numeric.equals(field.getFieldType()))
    {
      try
      {
        field.setValue(new Numeric(value)) ;
      }
      catch (Exception e)
      {
        throw e ;
      }
    }
    else
    {
      // 문자열 값으로 설정
      field.setValue(value) ;
    }
  }

  /**
   * 입력 레코드('inRecord')에서 여러 필드 값을 조합하여 대상 필드('field')에 설정하는 메서드.
   *
   * 'pattern'이 "key=value1+value2+..." 형식일 경우, "=" 이후의 값을 "+" 기준으로 분리하여 각 요소를 처리한다. 
   * 만약 해당 값이 'inRecord'에 존재하는 필드명이면 해당 필드의 값을 사용하고, 존재하지 않으면 해당 문자열을 그대로 추가한다.
   *
   * 최종적으로 조합된 문자열을 대상 필드('field')에 설정한다.
   *
   * @param inRecord
   *          입력 데이터를 포함하는 'Record' 객체
   * @param field
   *          값을 설정할 대상 'Field' 객체
   * @param pattern
   *          "CC=value1+value2+..." 형식의 패턴 문자열
   *          CC={필드경로 or 문자열 } +{필드경로 or 문자열 } + ...
   *          예1: CC=\HDR_COM\GIT_CNT_C 
   *          예2: CC=A+\HDR_COM\GIT_CNT_C+123
   * @throws IGateException
   *           필드 값 설정 중 예외가 발생할 경우 예외를 던질 수 있음
   */
  protected void setReplyFieldPatternCC(Record inRecord, Field field, String pattern) throws IGateException
  {
    // 패턴을 "=" 기준으로 나눈 후, 두 번째 부분을 "+" 기준으로 다시 분리
    String[] parts = pattern.split("=")[1].split("\\+") ;
    StringBuilder value = new StringBuilder() ;

    // 각 부분을 확인하며, 'inRecord'에 해당 필드가 존재하면 값을 추가하고, 존재하지 않으면 그대로 사용
    for (String part : parts)
    {
      value.append(inRecord.hasField(part) ? inRecord.getField(part).getValue() : part) ;
    }
    // 최종적으로 조합된 값을 대상 필드에 설정
    field.setValue(value.toString()) ;
  }

  /**
   * 입력 레코드('inRecord')에서 특정 필드 값을 가져와 지정된 위치에서 일부를 대체하여 대상 필드('field')에 설정하는
   * 메서드.
   *
   * 'pattern'은 "REP(fieldName, offset,replacement)" 형식이며, REP(원본문자열, 변경위치, 변경문자열) 
   * - 'fieldName': 변경할 대상 필드정보 ('IN' 또는 요청 필드 경로)또는 기본 문자열
   * - 'offset': 문자열을 대체할 시작 위치 (0부터 시작) 
   * - 'replacement': offset 위치 부터 대체할 문자열
   *
   * 만약 'inRecord'에 'fieldName'이 존재하면 해당 값을 가져오고, 존재하지 않으면 'fieldName'을 기본 문자열로
   * 사용한다. 지정된 'offset'에서 'replacement' 값으로 부분 문자열을 교체한 후, 최종적으로 'field'에 설정한다.
   *
   * [제약사항] offset + replacement 의 길이(변경할 상수 문자열) > param1(원본 문자열) 인 경우 원본 문자열
   * 길이로 Fix 처리 (TRIM)
   * 
   * @param inRecord
   *          입력 데이터를 포함하는 'Record' 객체
   * @param field
   *          값을 설정할 대상 'Field' 객체
   * @param pattern
   *          "REP(fieldName,offset,replacement)" 형식의 패턴 문자열
   *            예1 : REP(IN , 3, aa)
   *            예2 : REP(\HDR_COM\GIT_CNT_C , 1, aa )
   * @throws IGateException
   *           필드 값 설정 중 예외가 발생할 경우 예외를 던질 수 있음
   */

  protected void setReplyFieldPatternREP(Record inRecord, Field field, String pattern) throws IGateException
  {
    // 패턴에서 "REP" 이후의 부분을 추출하고, 괄호와 공백을 제거한 후 "," 기준으로 분리
    String[] params = pattern.substring(3).replaceAll("[() ]", "").split(",") ;

    // 올바른 형식인지 검증 (매개변수 개수는 3개여야 함)
    if (params.length != 3)
    {
      logger.error("Invalid REP pattern: " + pattern) ;
      return ;
    }

    // 'params[0]': 대체할 원본 문자열 또는 필드 이름
    String fieldValue = params[0];
    try
    {
      // CASE "OPTION_IN" (현재 필드의 값 사용)
      if (OPTION_IN.equals(fieldValue))
      {
        Field currentField = inRecord.getField(field.getPath()) ;
        if (currentField != null && currentField.getValue() != null)
        {
          fieldValue = (String) currentField.getValue() ;
        }
        else
        {
          logger.warn("CustomReplyEmulator Warning: Field path [" + field.getPath() + "] is null or empty.") ;
          return ;
        }
      }
      // CASE: 입력 레코드('inRecord')에서 필드가 존재하는 경우 해당 값 사용
      else if (inRecord.hasField(fieldValue))
      {
        Field targetField = inRecord.getField(fieldValue) ;
        if (targetField != null && targetField.getValue() != null)
        {
          fieldValue = (String) targetField.getValue() ;
        }
        else
        {
          logger.warn("CustomReplyEmulator Warning: Target field [" + fieldValue + "] is null or empty.") ;
          return ;
        }
      }
      // CASE: 정의되지 않은 필드일 경우 오류 로그 출력 후 반환
      else
      {
        logger.error("CustomReplyEmulator Undefined Field ID Error (Invalid Field Path: " + fieldValue + ")") ;
        return ;
      }
    }
    catch (Exception e)
    {
      logger.error("CustomReplyEmulator Error processing field [" + fieldValue + "]: " + e.getMessage(), e) ;
      return ;
    }

    // 최종적으로 원본 값을 'fieldValue'로 설정
    String originalValue = fieldValue ;

    // 'params[1]': 대체 시작 위치 (정수 변환)
    int offset = Integer.parseInt(params[1]) ;

    // 'params[2]': 대체할 문자열
    String replaceValue = params[2];

    // 기존 문자열을 기반으로 변경된 문자열을 생성
    StringBuilder result = new StringBuilder(originalValue) ;
    int endOffset = Math.min(originalValue.length(), offset + replaceValue.length()) ;
    result.replace(offset, endOffset, replaceValue) ;

    // 최종 변경된 값을 대상 필드에 설정
    field.setValue(result.toString()) ;
  }
}
