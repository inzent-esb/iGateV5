package com.custom.replyemulating;

import java.util.List ;

import org.apache.commons.lang3.StringUtils ;
import org.apache.commons.lang3.exception.ExceptionUtils ;

import com.inzent.igate.adapter.AdapterParameter ;
import com.inzent.igate.exception.IGateException ;
import com.inzent.igate.message.Field ;
import com.inzent.igate.message.Field.FieldType ;
import com.inzent.igate.message.MessageBeans ;
import com.inzent.igate.message.MessageConverter ;
import com.inzent.igate.message.Record ;
import com.inzent.igate.replyemulating.ReplyEmulater ;
import com.inzent.igate.repository.log.ReplyEmulate ;
import com.inzent.igate.repository.log.ReplyEmulatePK ;
import com.inzent.igate.repository.log.ReplyEmulateProperty ;
import com.inzent.igate.repository.meta.Service ;
import com.inzent.igate.util.Numeric ;
import com.inzent.igate.util.PatternUtils ;

public class CustomReplyEmulater extends ReplyEmulater
{
  public static final String INVALID_END_DELIM = "EGASH001" ;
  public static final String INVALID_END_DELIM_MESSAGE = "[EGASH001] Invalid END_DELIM in {0}" ;

  public static final String COMPOSE_FIELD_ERROR = "EGASH002" ;
  public static final String COMPOSE_FIELD_ERROR_MESSAGE = "[EGASH002] Fail to composed the field {0} : {1}" ;

  public static final String EMULATE_ERROR = "EGASH003" ;
  public static final String EMULATE_ERROR_MESSAGE = "[EGASH003] Error processing virtual response [Reply Emulate property]: " ;

  protected final static String DEF_REPLYID = "Normal";
  public String Replyid = DEF_REPLYID;

  /**
   * Field ID KeyWord
   * 입력필드 데이터를 응답필드 데이터로  
   * 사용법 : IN or IN={필드경로}
   *  IN           : 현재 필드와 동일한 위치의 입력 필드 값을 출력 필드 값으로 
   *  IN={필드경로}  : IN=\HDR_COM\GIT_CNT_C   : 입력 {필드경로} 의 값을 출력 필드 값으로
   **/
  protected final static String OPTION_IN = "IN";

  /**
   * DATE Format KeyWord
   * 입력필드 데이터를 응답필드 데이터로  
   * 사용법 : DATE or DATE={날짜 패턴}
   *  DATE                                        :  yyyyMMddHHmmss 기본 14자리 
   *  DATE=${YYYY}${MM}${DD}${HH}${MI}${SS}${sss}  
   *  DATE=${MM}${DD}${HH}${MI}${SS}${sss} 
   **/
  protected final static String OPTION_DATE = "DATE";

  /**
   * Concat KeyWord
   * 문자열 조합 
   * 사용법 : CC={필드경로 or 문자열 } +{필드경로 or 문자열 } + ... 
   * CC=\HDR_COM\GIT_CNT_C
   * CC=A+\HDR_COM\GIT_CNT_C+123
   **/
  protected final static String OPTION_CONCAT ="CC";

  /**
   * Replace KeyWord
   * 응답데이터의 Replace 기능 
   * 사용법 : REP(원본문자열, 변경위치, 변경문자열)
   *  - param1 : 응답으로 셋팅할 원본 문자열로 키워드 'IN' 또는 입력 필드명 사용
   *  - param2 : param1에서 변경할 offset 위치
   *  - param3 : offset 위치 부터 변경할 문자열 상수
   *  
   * [제약사항]
   * param2(offset) + param3의 길이(변경할 상수 문자열) > param1(원본 문자열) 인 경우 원본 문자열 길이로 Fix 처리 (TRIM)
   * 
   * ex)
   * REP(IN , 3, aa)
   * REP(\HDR_COM\GIT_CNT_C , 1, aa )
   **/
  protected final static String OPTION_REPLACE = "REP";
  
  @Override
  public boolean doMakeReply(AdapterParameter adapterParameter, Service service, Record request) throws IGateException 
  {
    Replyid = service.getProperty("emulate.reply.id", DEF_REPLYID);

    if(logger.isDebugEnabled())
      logger.debug("CustomReplyEmulater...makeReply / Replyid : " + Replyid);

    MessageConverter messageConverterReq = null;
    MessageConverter messageConverterRes = null;
    try 
    {
      // 대응답 처리 대상인 경우 : ReplyEmulating (true)
      boolean checkReply = super.doMakeReply(adapterParameter, service, request);

      if (checkReply) 
      {
        messageConverterReq = MessageBeans.SINGLETON.createMessageConverter(adapterParameter.getAdapter(), adapterParameter.getRequestData()) ;                 
        if(messageConverterReq == null)
          return checkReply;

        messageConverterRes = MessageBeans.SINGLETON.createMessageConverter(adapterParameter.getAdapter(), adapterParameter.getResponseData()) ;
        if(messageConverterRes == null)
          return checkReply;

        Record recordReq = messageConverterReq.parseServiceRequest(service, logger);
        Record recordRes = messageConverterRes.parseServiceResponse(service, logger);

        // 가상응답 필드 별 옵션에 따른 패턴 별 값 세팅 처리 추가
        setReplyFieldPatternValue( recordReq, recordRes , service.getServiceId() );                                     
        messageConverterRes.composeServiceResponse(service, recordRes, logger);

        adapterParameter.setResponseData(messageConverterRes.getComposeValue());
        return true;
      }           
    } 
    catch (Exception e) 
    {
      logger.error(EMULATE_ERROR_MESSAGE + ExceptionUtils.getStackTrace(e), e);
      throw new IGateException(EMULATE_ERROR, EMULATE_ERROR_MESSAGE +  e.getMessage());
    }
    return false;
  }

  /**
   * 가상응답 속성의 패턴에 따라 가상응답 필드 값 세팅처리.  
   * @ param inRecord
   * @ param outRecord    
   * @ param serviceId
   * @ throws IGateException
   */
  protected void setReplyFieldPatternValue(Record inRecord, Record outRecord, String serviceId ) throws IGateException
  {
    if(logger.isDebugEnabled())
      logger.debug("### setReplyFieldPatternValue /SATRT/ ServiceId[ " + serviceId  + "]");

    List<ReplyEmulateProperty> replyEmulatePropertyList
    = this.getReplyEmulate(new ReplyEmulatePK(serviceId, Replyid)).getReplyEmulateProperty();

    if (replyEmulatePropertyList != null && replyEmulatePropertyList.size() > 0) 
    {
      for (ReplyEmulateProperty replyEmulateProperty : replyEmulatePropertyList) 
      {
        String pattern = replyEmulateProperty.getFieldvalue();

        if (pattern == null || pattern.trim().isEmpty()) 
          continue;

        Field field = null;
        try 
        {
          if (outRecord.hasField(replyEmulateProperty.getPk().getFieldPath() ))
          {
            field = outRecord.getField(replyEmulateProperty.getPk().getFieldPath());
          } 
          else 
          {
            String fieldId = replyEmulateProperty.getPk().getFieldPath().substring(replyEmulateProperty.getPk().getFieldPath().lastIndexOf("\\")+1);
            if (outRecord.hasField(fieldId)) 
              field = outRecord.getField(fieldId);
            else 
              continue;
          }

          // 우선 순위에 대한 Validation 처리 
          if (field.getValue() != null) 
          {
            if (field.getFieldType() == FieldType.String && StringUtils.isNotBlank((String)field.getValue())) 
              continue;
            else if (field.getFieldType() == FieldType.Numeric && ((Numeric) field.getValue()).toNumber().intValue() > 0) 
              continue;
          }

          if(logger.isDebugEnabled())
          {
            logger.debug("### setReplyFieldPatternValue : fieldID[" + field.getId() + "]");
            logger.debug("### setReplyFieldPatternValue : fieldPath[" +field.getPath() +"]");
          }

          // 1. 요청전문의 필드 값 복사 기능 
          // IN={필드경로}
          if (pattern.startsWith(OPTION_IN)) 
          {
            setReplyFieldPatternIN(inRecord,field, pattern);                    
          }
          // 2. DATE 패턴 처리 
          // DATE={YYYY}{YY}{MM}{DD}{HH}{MI}{SS}{sss}
          else if (pattern.startsWith(OPTION_DATE)) 
          {
            setReplyFieldPatternDATE(inRecord,field, pattern);
          }
          // 3. 요청전문의 필드 concat(문자 결합) 기능 
          // CC={필드명}+{필드명}+...
          else if (pattern.startsWith(OPTION_CONCAT)) 
          {
            setReplyFieldPatternCC(inRecord,field, pattern);
          }
          // 4. 데이터 변환(Replace) 패턴 처리 
          // REP(IN , 3, A)
          // REP(필드경로 , 3 , A)
          else if (pattern.startsWith(OPTION_REPLACE)) 
          {                    
            setReplyFieldPatternREP(inRecord,field, pattern);
          } 
          else 
          {
            if(logger.isErrorEnabled())
              logger.error("CustomRplyEmulater Not Found Pattern ["+pattern+"]");
          }
        }
        catch (Exception e) 
        {
          if(logger.isErrorEnabled())
            logger.error("CustomRplyEmulater Setting Error !!!", e);
        }
      }
    }
    if(logger.isDebugEnabled())
      logger.debug("### setReplyFieldPatternValue /END/");
  }


  protected void setReplyFieldPatternIN(Record inRecord, Field field, String pattern) throws IGateException
  {
    if(logger.isDebugEnabled())
      logger.debug("### setReplyFieldPattern[IN] /START/ OPTION_IN: pattern[" + pattern + "]");

    String inFiledPath = null;
    if (pattern.indexOf('=') > 0 && pattern.indexOf('=') +1 < pattern.length()) 
      inFiledPath = pattern.substring(pattern.indexOf('=')+1);
    else 
      inFiledPath = field.getPath();

    if( inRecord.hasField(inFiledPath) )
      field.setValue(inRecord.getField(inFiledPath).getValue());
    else
    {
      if(logger.isErrorEnabled())
        logger.error("CustomRplyEmulater Undefined Field ID Error (Invalid Field Path : " + inFiledPath + ")");
    }

    if(logger.isDebugEnabled())
      logger.debug("### setReplyFieldPattern[IN] /END/ OPTION_IN: value[" + field.getValue() +"]");

  }

  protected void setReplyFieldPatternDATE(Record inRecord, Field field, String pattern) throws IGateException
  {
    if(logger.isDebugEnabled())
      logger.debug("### setReplyFieldPattern[DATE] /START/ OPTION_DATE: pattern[" + pattern + "]");

    String value = null;
    if (pattern.indexOf('=') > 0 && pattern.indexOf('=') +1 < pattern.length()) 
      value = PatternUtils.dateTimePattern(pattern.substring(pattern.indexOf('=')+1), System.currentTimeMillis());
    else 
      value = PatternUtils.dateFormatStandard.format(System.currentTimeMillis());

    if (value.length() > field.getLength()) 
      value = value.substring(0, field.getLength());

    if (field.getFieldType() == FieldType.Numeric) 
      field.setValue(new Numeric(value));
    else 
      field.setValue(value);

    if(logger.isDebugEnabled())
      logger.debug("### setReplyFieldPattern[DATE] /END/ OPTION_DATE: value[" + field.getValue() +"]");
  }


  protected void setReplyFieldPatternCC(Record inRecord, Field field, String pattern) throws IGateException
  {
    if(logger.isDebugEnabled())
      logger.debug("### setReplyFieldPattern[CC] /START/ OPTION_CONCAT: pattern[" + pattern + "]");

    String value = "";
    if (pattern.indexOf('=') > 0 && pattern.indexOf('=') +1 < pattern.length()) 
    {
      String[] filedSplit = pattern.substring(pattern.indexOf('=')+1).split("\\+");
      if(logger.isDebugEnabled())
        logger.debug("### setReplyFieldPattern[CC] / filedSplit length : " + filedSplit.length);
      for (String filePath : filedSplit) 
      {
        if(logger.isDebugEnabled())
          logger.debug("### setReplyFieldPattern[CC] / filePath : " + filePath);
        if (inRecord.hasField(filePath) == true) 
        {
          Field subField = inRecord.getField(filePath);
          value += subField.getValue();
        } 
        else 
        {
          value += filePath;
        }
        if(logger.isDebugEnabled())
          logger.debug("### setReplyFieldPattern[CC] / value : " + value);
      }
    }
    
    field.setValue(value);
    
    if(logger.isDebugEnabled())
      logger.debug("### setReplyFieldPattern[CC] /END/ OPTION_CONCAT: value[" + field.getValue() +"]");
  }

  protected void setReplyFieldPatternREP(Record inRecord, Field field, String pattern) throws IGateException
  {
    if(logger.isDebugEnabled())
      logger.debug("### setReplyFieldPattern[REP] /START/ OPTION_REPLACE: pattern[" + pattern + "]");

    int sOffset = 0;        // 변경할 시작 Offset
    int eOffset = 0;        // 변경할 종료 Offset
    String rStr = null;     // 원본 문자열
    String bStr = null;     // 변경할 문자열

    pattern = pattern.substring(3).replaceAll("\\(", "").replaceAll("\\)", "");
    String[] fieldsplit = pattern.split("\\,");

    // REP Function 파라메터 체크
    if (fieldsplit.length != 3) {
      if(logger.isErrorEnabled())
        logger.error("CustomRplyEmulater Param Count Error (Param Count : " + fieldsplit.length + ")");
      return;
    }

    bStr = fieldsplit[0].trim();
    rStr = fieldsplit[2].trim();
    try {
      sOffset = Integer.parseInt(fieldsplit[1].trim());
    } catch (NumberFormatException ne) {
      if(logger.isErrorEnabled())
        logger.error("CustomRplyEmulater Param Type Error (2nd Param : " + fieldsplit[1] + ")");
      return;
    }

    // CASE "IN"
    if (OPTION_IN.equals(bStr)) 
    {
      bStr = (String)inRecord.getField(field.getPath()).getValue();
    }
    // CASE Field path
    else if (inRecord.hasField(bStr)) 
    {
      bStr = (String)inRecord.getField(bStr).getValue();
    }
    // CASE Undefined Field ID
    else 
    {
      if(logger.isErrorEnabled())
        logger.error("CustomRplyEmulater Undefined Field ID Error (Invalid Field Path : " + bStr + ")");
      return;
    }

    StringBuffer rtnValue = new StringBuffer(bStr);
    eOffset = (bStr.length() - sOffset > rStr.length()) ? sOffset + rStr.length() : bStr.length();

    field.setValue(rtnValue.replace(sOffset, eOffset, rStr).toString());

    if(logger.isDebugEnabled())
    {
      logger.debug("### setReplyFieldPattern[REP] / value : " + rtnValue.replace(sOffset, eOffset, rStr).toString());
      logger.debug("### setReplyFieldPattern[REP] /END/ OPTION_REPLACE: value[" + field.getValue() +"]");
    }
  }

}