package com.custom.replyemulating.adapter;

import org.apache.commons.logging.Log ;
import org.apache.commons.logging.LogFactory ;

import com.inzent.igate.adapter.AdapterParameter ;
import com.inzent.igate.exception.IGateException ;
import com.inzent.igate.message.MessageBeans ;
import com.inzent.igate.message.MessageConverter ;
import com.inzent.igate.message.Record ;
import com.inzent.igate.replyemulating.AdapterReplyEmulating ;
import com.inzent.igate.replyemulating.ReplyEmulater ;
import com.inzent.igate.repository.log.ReplyEmulate ;
import com.inzent.igate.repository.meta.Service ;
import com.inzent.igate.util.SerializationUtils ;

/**
 * <code>CustomAdapterComReplyEmulater</code>
 * 
 * This class implements {@link AdapterReplyEmulating} and provides a mechanism for
 * emulating adapter replies based on predefined rules.
 * 
 * The class specifically handles reply emulation for "I_COM" adapter,
 * ensuring the proper response data structure is applied.
 * 
 * 
 * {@link AdapterReplyEmulating}을 구현한 클래스이며, 미리 정의된 규칙을 기반으로 어댑터 응답을 에뮬레이션합니다.
 * 
 * 이 클래스는 "I_COM" 어댑터에 대한 응답을 처리하며,
 * 올바른 응답 데이터 구조를 보장하는 역할을 수행합니다.
 * 
 */
public class CustomAdapterComReplyEmulater implements AdapterReplyEmulating
{
  protected final Log log = LogFactory.getLog(getClass()) ;
  
  /**
   * 이 에뮬레이션을 위한 고유 어댑터 식별자를 반환합니다.
   * @return "A_COM" 어댑터 ID.
   */
  @Override
  public String getAdapterId()
  {
    return "A_COM" ;   
  }

  /**
   * 에뮬레이션 로직을 기반으로 응답 메시지를 생성합니다.
   * 
   * @param replyEmulater 에뮬레이션 처리기.
   * @param adapterParameter 요청 및 응답 데이터를 포함한 어댑터 매개변수.
   * @param service 요청과 연관된 서비스 메타데이터.
   * @param request 입력 요청 레코드.
   * @return 응답이 성공적으로 생성되었으면 true, 그렇지 않으면 false.
   * @throws IGateException 응답 생성 중 오류 발생 시 예외 발생.
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
        if(!handleAdapterVirtualResponse(replyEmulater, adapterParameter, service, request))
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
   * 어댑터별 가상 응답을 수정하는 메서드.
   * 
   * @param replyEmulater 에뮬레이션 처리기.
   * @param adapterParameter 어댑터 매개변수.
   * @param service 서비스 메타데이터.
   * @param request 요청 레코드.
   * @return 성공 시 true, 실패 시 false.
   * @throws IGateException 오류 발생 시 예외 발생.
   */
  public boolean handleAdapterVirtualResponse(ReplyEmulater replyEmulater, AdapterParameter adapterParameter, Service service, Record request) throws IGateException
  {
    // 요청 및 응답 데이터를 처리하기 위한 MessageConverter 생성
    MessageConverter messageConverterReq = MessageBeans.SINGLETON.createMessageConverter(adapterParameter.getAdapter(), adapterParameter.getRequestData()) ;
    MessageConverter messageConverterRes = MessageBeans.SINGLETON.createMessageConverter(adapterParameter.getAdapter(), adapterParameter.getResponseData()) ;

    // 변환기가 정상적으로 생성되지 않으면 기존 응답 결과 반환
    if (messageConverterReq == null || messageConverterRes == null)
      return false ;

    if (messageConverterReq != null && messageConverterRes != null)
    {
      // 요청 및 응답 데이터를 `Record` 객체로 변환
      Record recordReq = messageConverterReq.parseServiceRequest(service, log) ;
      Record recordRes = messageConverterRes.parseServiceResponse(service, log) ;

      // I_COM 어댑터의 서비스들의 응답 메시지에 GUID 필드의 정보를 요청 필드 정보 값을 그대로 사용
      String GuidPath = "\\Header\\StandardHeader\\Guid" ;
      if (recordRes.hasField(GuidPath))
        recordRes.getField(GuidPath).setValue(recordReq.getField(GuidPath).getValue()) ;

      // I_COM 어댑터의 서비스들의 응답 메시지에 그룹사코드 CmgrCd필드의 정보를 COM로 설정
      String CmgrcdPath = "\\Header\\StandardHeader\\CmgrCd" ;
      if (recordRes.hasField(CmgrcdPath))
        recordRes.getField(CmgrcdPath).setValue("COM") ;

      // I_COM 어댑터의 서비스들의 응답 메시지에 채널유형 Channelid 필드의 정보를 C0 설정
      String ChannelidPath = "\\Header\\StandardHeader\\Channelid" ;
      if (recordRes.hasField(ChannelidPath))
        recordRes.getField(ChannelidPath).setValue("C0") ;

      // 새로운 응답 메시지 변환기 생성
      messageConverterRes = MessageBeans.SINGLETON.createMessageConverter(adapterParameter.getAdapter(), null) ;
      messageConverterRes.composeServiceResponse(service, recordRes, log) ;

      // 응답 데이터를 어댑터 파라미터에 설정
      adapterParameter.setResponseData(messageConverterRes.getComposeValue()) ;
      return true ;
    }
    return false ;
  }
}
