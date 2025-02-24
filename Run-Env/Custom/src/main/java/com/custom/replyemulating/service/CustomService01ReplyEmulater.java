package com.custom.replyemulating.service;

import org.apache.commons.logging.Log ;
import org.apache.commons.logging.LogFactory ;

import com.inzent.igate.adapter.AdapterParameter ;
import com.inzent.igate.exception.IGateException ;
import com.inzent.igate.message.MessageBeans ;
import com.inzent.igate.message.MessageConverter ;
import com.inzent.igate.message.Record ;
import com.inzent.igate.replyemulating.ReplyEmulater ;
import com.inzent.igate.replyemulating.ServiceReplyEmulating ;
import com.inzent.igate.repository.log.ReplyEmulate ;
import com.inzent.igate.repository.meta.Service ;
import com.inzent.igate.util.SerializationUtils ;

/**
 * <code>CustomServiceReplyEmulater</code>
 * This class provides a custom implementation of the ServiceReplyEmulating interface,
 * handling service-specific virtual responses.
 * 
 * ServiceReplyEmulating 인터페이스의 사용자 정의 구현을 제공하며, 서비스별 가상 응답을 처리합니다. 
 */

public class CustomService01ReplyEmulater  implements ServiceReplyEmulating
{
  protected final Log log = LogFactory.getLog(getClass()) ;
  
  /**
   * 이 에뮬레이션과 관련된 서비스 ID를 반환합니다.
   * @return 서비스 ID
   */
  @Override
  public String getServiceId()
  {
    return "SR_HUB_0020" ;
  }
  

  /**
   * 미리 정의된 에뮬레이션 응답을 검색하여 응답 메시지를 생성합니다.
   * 
   * @param replyEmulater ReplyEmulater 인스턴스
   * @param adapterParameter 요청 및 응답 데이터를 포함하는 어댑터 파라미터
   * @param service 서비스 메타데이터
   * @param request 요청 레코드
   * @return 응답이 성공적으로 생성되면 true, 그렇지 않으면 false
   * @throws IGateException 오류 발생 시 예외 발생
   */
  @Override
  public boolean makeReply(ReplyEmulater replyEmulater, AdapterParameter adapterParameter, Service service, Record request) throws IGateException
  {
    //서비스 객체로 가상응답 찾기 (emulate.reply.id 기본값 "Normal")
    ReplyEmulate replyEmulate0 = ReplyEmulater.getReplyEmulate(service);
   
    //서비스 ID 로 가상응답 찾기 (emulate.reply.id 기본값 "Normal")
    //ReplyEmulate replyEmulate1 = ReplyEmulater.getReplyEmulate(service.getServiceId());
    
    //서비스 ID 와 emulate.reply.id 설정 정보로 찾기 
    //ReplyEmulate replyEmulate2 = ReplyEmulater.getReplyEmulate(service.getServiceId(), service.getProperty(Service.PROPT_EMULATE_REPLY_ID, "Normal"));

    if (null != replyEmulate0)
    {
      adapterParameter.setResponseData(SerializationUtils.deserialize(replyEmulate0.getReplyData())) ;

      try {
        //SR_HUB_0020 서비스 가상응답 별도 처리 메소드 호출
        if(!handleServiceVirtualResponse(replyEmulater, adapterParameter, service, request))
          adapterParameter.setResponseData(SerializationUtils.deserialize(replyEmulate0.getReplyData())) ;
        return true;
      }
      catch (Exception e) {
        log.error(e);
      }
    }
    return false ;
  }

  /**
   * 가상 응답을 처리하고 요청 데이터 기반으로 응답 필드를 수정합니다.
   * 
   * @param replyEmulater ReplyEmulater 인스턴스
   * @param adapterParameter 요청 및 응답 데이터를 포함하는 어댑터 파라미터
   * @param service 서비스 메타데이터
   * @param request 요청 레코드
   * @return 처리 성공 시 true, 실패 시 false
   * @throws IGateException 처리 중 오류 발생 시 예외 발생
   */
  public boolean handleServiceVirtualResponse(ReplyEmulater replyEmulater, AdapterParameter adapterParameter, Service service, Record request) throws IGateException
  {
    // 요청 및 응답 데이터를 처리하기 위한 MessageConverter 생성
    MessageConverter messageConverterReq = MessageBeans.SINGLETON.createMessageConverter(adapterParameter.getAdapter(), adapterParameter.getRequestData()) ;
    MessageConverter messageConverterRes = MessageBeans.SINGLETON.createMessageConverter(adapterParameter.getAdapter(), adapterParameter.getResponseData()) ;

    // 변환기가 정상적으로 생성되지 않으면 기존 응답 결과 반환
    if (messageConverterReq == null || messageConverterRes == null)
      return false ;

    if(messageConverterReq != null && messageConverterRes != null )
    {
      // 요청 및 응답 데이터를 `Record` 객체로 변환
      Record recordReq = messageConverterReq.parseServiceRequest(service, log);
      Record recordRes = messageConverterRes.parseServiceResponse(service, log);

      //SR_HUB_0020 서비스의  응답 메시지에 GUID 필드의 정보를 요청 필드 정보 값을 그대로 사용
      String GuidPath = "\\Header\\StandardHeader\\Guid";
      if(recordRes.hasField(GuidPath))
        recordRes.getField(GuidPath).setValue(recordReq.getField(GuidPath).getValue());

      //SR_HUB_0020 서비스의  응답 메시지에 RequestMode필드의 정보를 R로 설정
      String RequestModePath = "\\Header\\StandardHeader\\RequestMode";
      if(recordRes.hasField(RequestModePath))
        recordRes.getField(RequestModePath).setValue("R");
      
      //SR_HUB_0020 서비스의  응답 메시지에 ResponseCode필드의 정보를 3으로 설정      
      String ResponseCodePath = "\\Header\\StandardHeader\\ResponseCode";
      if(recordRes.hasField(ResponseCodePath))
        recordRes.getField(ResponseCodePath).setValue("3");

      // 새로운 응답 메시지 변환기 생성
      messageConverterRes = MessageBeans.SINGLETON.createMessageConverter(adapterParameter.getAdapter(), null) ;
      messageConverterRes.composeServiceResponse(service, recordRes, log) ;

      // 응답 데이터를 어댑터 파라미터에 설정
      adapterParameter.setResponseData(messageConverterRes.getComposeValue()) ;
      return true;
    }
    return false;
  }

}
